//
//  VideoViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "VideoViewController.h"
#import <WMPlayer.h>
#import "VideoTableViewCell.h"
#import "WordWebViewTableViewCell.h"
#import "VideoBottomView.h"
#import "LessonListTableViewCell.h"
#import <PopoverView.h>
#import "LTDownloadView.h"
#import "OneLessonModel.h"
#import "DownloadVideoModel.h"

#define kAllLessonTableViewHeight SCREEN_HEIGHT - SCREEN_WIDTH * 9 / 16 - SafeAreaTopHeight - 48
@interface VideoViewController ()<WMPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) WordWebViewTableViewCell *scrollCell;
@property (nonatomic, strong) WMPlayer *wmPlayer;
@property (nonatomic, strong) VideoTableViewCell *currentCell;
@property (nonatomic, strong) UITableView *allSelectionTableView;
@property (nonatomic, strong) VideoBottomView *videoBottomView;
@property (nonatomic, strong) LTDownloadView *downloadView;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, strong) OneLessonModel *oneLessonModel;
@property (nonatomic, strong) UIImageView *videoImg;
@property (nonatomic, assign) int clarityIndex;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) DownloadVideoModel *downloadModel;
@property (nonatomic, strong) NSMutableArray *lessonArray;
@end
@implementation VideoViewController

- (NSMutableArray *)lessonArray{
    if (!_lessonArray) {
        _lessonArray = [NSMutableArray array];
    }
    return _lessonArray;
}
-(BOOL)prefersStatusBarHidden{
    if (self.wmPlayer.isFullscreen) {
        return self.wmPlayer.prefersStatusBarHidden;
    }
    return NO;
}
///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    NSLog(@"didClickedCloseButton");
    if (wmplayer.isFullscreen) {
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{
        [self.wmPlayer pause];
        [self releaseWMPlayer];
//        [self.currentCell.playBtn.superview bringSubviewToFront:self.currentCell.playBtn];
        self.playBtn.hidden = NO;
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (self.wmPlayer.isFullscreen) {//全屏
        [self toOrientation:UIInterfaceOrientationPortrait];
    }else{//非全屏
        [self toOrientation:UIInterfaceOrientationLandscapeRight];
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    if(self.wmPlayer.isFullscreen==NO){
  
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}

///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerGotVideoSize:(WMPlayer *)wmplayer videoSize:(CGSize )presentationSize{
    
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
}
//操作栏隐藏或者显示都会调用此方法
-(void)wmplayer:(WMPlayer *)wmplayer isHiddenTopAndBottomView:(BOOL)isHidden{
    [self setNeedsStatusBarAppearanceUpdate];
}
/**
 *  旋转屏幕通知
 */
- (void)onDeviceOrientationChange:(NSNotification *)notification{
    if (self.wmPlayer==nil){
        return;
    }
    if (self.wmPlayer.playerModel.verticalVideo) {
        return;
    }
    if (self.wmPlayer.isLockScreen){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            [self toOrientation:UIInterfaceOrientationPortrait];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            [self toOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            [self toOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}
//点击进入,退出全屏,或者监测到屏幕旋转去调用的方法
-(void)toOrientation:(UIInterfaceOrientation)orientation{
    //获取到当前状态条的方向
    UIInterfaceOrientation currentOrientation = [UIApplication sharedApplication].statusBarOrientation;
    [self.wmPlayer removeFromSuperview];
    //根据要旋转的方向,使用Masonry重新修改限制
    if (orientation ==UIInterfaceOrientationPortrait) {
        [self.videoImg addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = NO;
        self.wmPlayer.backBtnStyle = BackBtnStyleNone;
        [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.wmPlayer.superview);
        }];
        
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self.wmPlayer];
        self.wmPlayer.isFullscreen = YES;
        self.wmPlayer.backBtnStyle = BackBtnStylePop;
        
        if(currentOrientation ==UIInterfaceOrientationPortrait){
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }else{
            if (self.wmPlayer.playerModel.verticalVideo) {
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.wmPlayer.superview);
                }];
            }else{
                [self.wmPlayer mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@([UIScreen mainScreen].bounds.size.width));
                    make.height.equalTo(@([UIScreen mainScreen].bounds.size.height));
                    make.center.equalTo(self.wmPlayer.superview);
                }];
            }
            
        }
    }
    //iOS6.0之后,设置状态条的方法能使用的前提是shouldAutorotate为NO,也就是说这个视图控制器内,旋转要关掉;
    //也就是说在实现这个方法的时候-(BOOL)shouldAutorotate返回值要为NO
    if (self.wmPlayer.playerModel.verticalVideo) {
        [self setNeedsStatusBarAppearanceUpdate];
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:orientation animated:NO];
        //更改了状态条的方向,但是设备方向UIInterfaceOrientation还是正方向的,这就要设置给你播放视频的视图的方向设置旋转
        //给你的播放视频的view视图设置旋转
        [UIView animateWithDuration:0.4 animations:^{
            self.wmPlayer.transform = CGAffineTransformIdentity;
            self.wmPlayer.transform = [WMPlayer getCurrentDeviceOrientation];
            [self.wmPlayer layoutIfNeeded];
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initWithView];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self loadData];
    _clarityIndex = 0;
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([VideoTableViewCell class])];
    [tableView registerClass:[WordWebViewTableViewCell class] forCellReuseIdentifier:NSStringFromClass([WordWebViewTableViewCell class])];
    self.tableView = tableView;
//    
//    VideoBottomView *bottomView = [[VideoBottomView alloc]init];
//    [self.view addSubview:bottomView];
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//        make.height.equalTo(@50);
//    }];
//    bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
//    bottomView.layer.shadowOffset = CGSizeMake(-3, 0);
//    bottomView.layer.shadowOpacity = 0.4;
//    self.videoBottomView = bottomView;
//    WeakSelf
//    bottomView.selectionClickBlock = ^(UIButton *btn) {
//        btn.selected = !btn.selected;
//        if (btn.selected) {
//            [weakSelf.allSelectionTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.view);
//                make.right.equalTo(self.view);
//                make.height.equalTo(@(SCREEN_HEIGHT - 220 - 50 - 64 - 48));
//                make.bottom.equalTo(self.videoBottomView.mas_top);
//            }];
//            [UIView animateWithDuration:0.2 animations:^{
//                [self.view layoutIfNeeded];
//            }];
//        }else{
//            [weakSelf.allSelectionTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.view);
//                make.right.equalTo(self.view);
//                make.top.equalTo(self.view.mas_bottom);
//                make.height.equalTo(@(SCREEN_HEIGHT - 220 - 50 - 64 - 48));
//            }];
//            [UIView animateWithDuration:0.2 animations:^{
//                [self.view layoutIfNeeded];
//            }];
//        }
//    };
//#pragma mark 下载
//    bottomView.downloadClickBlcok = ^(UIButton *btn) {
//        NSString *GPRSDownload = [USERDEFAULTS objectForKey:@"GPRSDownload"];
//        if ([kNetworkState isEqualToString:@"GPRS"] && [GPRSDownload isEqualToString:@"0"]) {
//            LTAlertView *alert = [[LTAlertView alloc]initWithTitle:@"移动网络环境下确定下载吗" sureBtn:@"确定" cancleBtn:@"取消"];
//            [alert show];
//            alert.resultIndex = ^(NSInteger index) {
//                [self downloadVideo:btn];
//            };
//        }else{
//            [self downloadVideo:btn];
//        }
//    };
//    bottomView.shareClickBlock = ^(UIButton *btn) {
//        
//    };
//#pragma mark 清晰度修改
//    bottomView.clarityClickBlock = ^(UIButton *btn) {
//        PopoverAction *action1 = [PopoverAction actionWithTitle:@"标清" handler:^(PopoverAction *action) {
//            // 该Block不会导致内存泄露, Block内代码无需刻意去设置弱引用.
//            [btn setTitle:@"标清" forState:UIControlStateNormal];
//            _clarityIndex = 0;
//            [self.wmPlayer resetWMPlayer];
//            [self videoPlay:self.playBtn];
//        }];
//        PopoverAction *action2 = [PopoverAction actionWithTitle:@"高清" handler:^(PopoverAction *action) {
//            [btn setTitle:@"高清" forState:UIControlStateNormal];
//            _clarityIndex = 1;
//            [self.wmPlayer resetWMPlayer];
//            [self videoPlay:self.playBtn];
//        }];
//        PopoverAction *action3 = [PopoverAction actionWithTitle:@"超清" handler:^(PopoverAction *action) {
//            [btn setTitle:@"超清" forState:UIControlStateNormal];
//            _clarityIndex = 2;
//            [self.wmPlayer resetWMPlayer];
//            [self videoPlay:self.playBtn];
//        }];
//        PopoverView *popoverView = [PopoverView popoverView];
//        popoverView.style = PopoverViewStyleDark;
//        [popoverView showToView:btn withActions:@[action1, action2, action3]];
//    };
    
    UITableView *selectionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    selectionTableView.delegate = self;
    selectionTableView.dataSource = self;
    selectionTableView.separatorStyle  =UITableViewCellSeparatorStyleNone;
    [selectionTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonListTableViewCell class])];
    [self.view addSubview:selectionTableView];
    [selectionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(kAllLessonTableViewHeight));
    }];
    self.allSelectionTableView = selectionTableView;
    
    UIImageView *videoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 9 /16)];
    [self.view addSubview:videoImg];
    videoImg.image = [UIImage imageNamed:@"视频封面"];
    videoImg.userInteractionEnabled = YES;
    self.videoImg = videoImg;
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [videoImg addSubview:playBtn];
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@65);
        make.width.equalTo(@65);
        make.centerX.equalTo(videoImg.mas_centerX);
        make.centerY.equalTo(videoImg.mas_centerY);
    }];
    [playBtn setImage:[UIImage imageNamed:@"video_play_btn_bg"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(videoPlay:) forControlEvents:UIControlEventTouchUpInside];
    self.playBtn = playBtn;
}
- (void)videoPlay:(UIButton *)btn{
    self.wmPlayer = [[WMPlayer alloc] init];
    self.wmPlayer.tintColor = DRGBCOLOR;
    self.wmPlayer.delegate = self;
    [self.videoImg addSubview:self.wmPlayer];
    [self.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.videoImg);
    }];
    WMPlayerModel *playerModel = [[WMPlayerModel alloc]init];
    playerModel.title = self.oneLessonModel.name;
    if (_clarityIndex == 0) {
        playerModel.videoURL = [NSURL URLWithString:self.oneLessonModel.burl];
    }else if (_clarityIndex == 1){
        playerModel.videoURL = [NSURL URLWithString:self.oneLessonModel.gurl];
    }else if (_clarityIndex == 2){
        playerModel.videoURL = [NSURL URLWithString:self.oneLessonModel.curl];
    }
    self.wmPlayer.playerModel = playerModel;
   
    NSString *GPRSPlay = [[NSUserDefaults standardUserDefaults]objectForKey:@"GPRSPlay"];
    if ([kNetworkState isEqualToString:@"WIFI"] || [GPRSPlay isEqualToString:@"1"]) {
        btn.hidden = YES;
        [self.wmPlayer play];
    }else{
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"移动网络下确定要播放吗" sureBtn:@"确定" cancleBtn:@"取消"];
        [alertView show];
        alertView.resultIndex = ^(NSInteger index) {
            btn.hidden = YES;
            [self.wmPlayer play];
        };
    }
}
- (void)loadData{
    if (self.lessonType.length == 0) {
        self.lessonType = @"1";
    }
    [LTHttpManager getCategoryLessonWithCourse_type:self.lessonType Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *dataArray = data[@"responseData"];
            [self.lessonArray removeAllObjects];
            for (NSDictionary *dict in dataArray) {
                VideoLessonModel *model = [VideoLessonModel mj_objectWithKeyValues:dict];
                [self.lessonArray addObject:model];
            }
            self.allSelectionTableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"还没有课程哦"];
            self.playBtn.hidden = YES;//隐藏播放器
            [self.allSelectionTableView reloadData];
            [self changeClick:self.rightBtn];
            
        }else{
            self.allSelectionTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                [self loadData];
            }];
        }
    }];
    //课程列表
//    [LTHttpManager findByCurriculumTypeWithUserId:IS_USER_ID CurriculumType:@"1" Complete:^(LTHttpResult result, NSString *message, id data) {
//       
//    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.allSelectionTableView) return 1;
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.allSelectionTableView) {
        return self.lessonArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.allSelectionTableView) {
        return 100;
    }
    if (indexPath.section == 0) {
        return SCREEN_WIDTH * 9 /16;
    }else{
        return SCREEN_HEIGHT - 64;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.allSelectionTableView) {
        return CGFLOAT_MIN;
    }
    if (section > 0) {
         return 48;
    }else{
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        changeView.backgroundColor = [UIColor whiteColor];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftBtn setTitle:@"本课讲义" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateSelected];
        [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [changeView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(changeView);
            make.right.equalTo(changeView.mas_centerX);
            make.height.equalTo(changeView);
            make.top.equalTo(changeView);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitle:@"课程目录" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateSelected];
        [rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [changeView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(changeView);
            make.left.equalTo(changeView.mas_centerX);
            make.height.equalTo(changeView);
            make.top.equalTo(changeView);
        }];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0xFFCE43);
        [changeView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@85);
            make.height.equalTo(@3);
            make.centerX.equalTo(leftBtn.mas_centerX);
            make.bottom.equalTo(changeView);
        }];
        
        UILabel *line = [UILabel new];
        [changeView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(changeView);
            make.right.equalTo(changeView);
            make.height.equalTo(@1);
            make.bottom.equalTo(changeView);
        }];
        line.backgroundColor = UIColorFromRGB(0xF0F0F0);

        self.bottomView = bottomView;
        self.leftBtn = leftBtn;
        self.leftBtn.tag = 101;
        self.rightBtn.tag = 102;
        self.rightBtn = rightBtn;
        [self.leftBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
        return changeView;
    }else{
        return nil;
    }
}
- (void)scrollClick:(UIButton *)sender{
    [self changeClick:sender];
    if (sender.tag == 101) {
        [MobClick event:@"listeningcoursepage_tab1"];
        self.allSelectionTableView.hidden = YES;
    }else{
        [MobClick event:@"listeningcoursepage_tab2"];
        self.allSelectionTableView.hidden = NO;
    }
}
- (void)changeClick:(UIButton *)sender{
    if (_tempBtn == nil){
        sender.selected = YES;
        _tempBtn = sender;
    }else if (_tempBtn !=nil && _tempBtn == sender){
        sender.selected = YES;
    }else if (_tempBtn!= sender && _tempBtn!=nil){
        _tempBtn.selected = NO;
        sender.selected = YES;
        _tempBtn = sender;
    }

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
        make.width.equalTo(@85);
        make.height.equalTo(@3);
        make.bottom.equalTo(self.bottomView.superview);
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        if (indexPath.section > 0) {
            WordWebViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordWebViewTableViewCell class])];
            if (self.oneLessonModel) cell.model = self.oneLessonModel;
//            self.scrollCell = cell;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
            }
    }else{
        LessonListTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonListTableViewCell class])];
        cell.model = self.lessonArray[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//选集
    if (tableView == self.allSelectionTableView) {
        [MobClick event:@"listeningcoursepage_course"];
        VideoLessonModel *videoModel = self.lessonArray[indexPath.row];
        [self.wmPlayer resetWMPlayer];
        [self.videoImg bringSubviewToFront:self.playBtn];
        self.playBtn.hidden = NO;
        self.videoId = videoModel.ID;
        self.downloadModel = [[DownloadVideoModel alloc]init];
        SVProgressShow();
        [LTHttpManager findOneCurriculumWithUserId:IS_USER_ID CurriculumId:[NSString stringWithFormat:@"%ld",(long)self.videoId] Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                OneLessonModel *model = [OneLessonModel mj_objectWithKeyValues:data[@"responseData"]];
                self.oneLessonModel = model;
                self.downloadModel.name = self.oneLessonModel.name;
                self.downloadModel.videoSize = self.oneLessonModel.bsize;
                self.downloadModel.videoId = [NSString stringWithFormat:@"%ld",(long)self.oneLessonModel.ID];
                self.downloadModel.testPaperHtml = self.oneLessonModel.handouts;
                self.downloadModel.wordHtml = self.oneLessonModel.vocabulary;
                self.downloadModel.time = self.oneLessonModel.time;
                J_Insert(self.downloadModel).updateResult;
                [self scrollClick:self.leftBtn];
                [self.tableView reloadData];
                self.title = self.oneLessonModel.name;
                SVProgressHiden();
            }
            SVProgressHiden();
        }];
    }
}
#pragma mark 下载视频
- (void)downloadVideo:(UIButton *)sender{
    self.downloadView = [[LTDownloadView alloc]initWithTitle:@"是否下载此资源" sureBtn:@"立即下载" fileSize:[NSString stringWithFormat:@"%dM",[self.oneLessonModel.bsize intValue]/(1024 * 1024)]];

    [self.downloadView show];
    __block VideoViewController *blockSelf = self;
    self.downloadView.resultIndex = ^(NSInteger index) {
        if (index == 2000) {
            sender.enabled = NO;
            DownloadVideoModel *model = [DownloadVideoModel jr_findByPrimaryKey:[NSString stringWithFormat:@"%ld",(long)blockSelf.oneLessonModel.ID]];
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            NSString *urlString = [model.videourl stringByRemovingPercentEncoding];
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:fullPath]) {
                blockSelf.videoBottomView.downloadImg.image = [UIImage imageNamed:@"downloaded"];
                blockSelf.videoBottomView.downloadImg.hidden = YES;
                blockSelf.videoBottomView.downloadLb.hidden = YES;
                sender.enabled = NO;
                SVProgressShowStuteText(@"您已经下载过了，请到下载页查看", NO);
                return;
            }else{
                blockSelf.downloadTask = [LTHttpManager downloadURL:blockSelf.oneLessonModel.burl progress:^(NSProgress *downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [blockSelf.downloadView.progressView setProgress:downloadProgress.fractionCompleted];
                        blockSelf.downloadView.progressLb.text = [NSString stringWithFormat:@"%.1f%%",downloadProgress.fractionCompleted * 100];
                    });
                    if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [blockSelf.downloadView dismiss];
                        });
                    }
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    blockSelf.downloadModel.videourl = fileName;
                    BOOL result =
                     J_Update(blockSelf.downloadModel).Columns(@[@"videourl"]).updateResult;
                    if (result) {
                        SVProgressShowStuteText(@"下载成功", YES);
                        blockSelf.videoBottomView.downloadImg.image = [UIImage imageNamed:@"downloaded"];
                        blockSelf.videoBottomView.downloadLb.text = @"已下载";
                        sender.enabled = NO;
                        blockSelf.videoBottomView.downloadImg.hidden = YES;
                        blockSelf.videoBottomView.downloadLb.hidden = YES;
                    }
                    NSLog(@"%@",fileName);
                } failure:^(NSError *error) {
                    sender.enabled = YES;
                }];
            }
        }else{
            [blockSelf.downloadTask cancel];;
        }
    };
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    [MobClick beginLogPageView:@"听力讲解课页面"];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"听力讲解课页面"];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [LTHttpManager addPlayRecordWithUseId:IS_USER_ID ? IS_USER_ID : @"" CurriculumId:[NSString stringWithFormat:@"%ld",(long)self.videoId] LastTime:[NSString stringWithFormat:@"%f",self.wmPlayer.currentTime] Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kLoadLearnedList object:nil];
        }
    }];
    [self releaseWMPlayer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    [self.wmPlayer pause];
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer = nil;
}
-(void)dealloc{
    [self releaseWMPlayer];
    NSLog(@"%@ dealloc",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
