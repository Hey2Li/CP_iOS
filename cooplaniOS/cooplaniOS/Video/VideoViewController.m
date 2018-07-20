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

@interface VideoViewController ()<WMPlayerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) WordWebViewTableViewCell *scrollCell;
@property (nonatomic, strong) WMPlayer *wmPlayer;
@property (nonatomic, strong) VideoTableViewCell *currentCell;
@end
@implementation VideoViewController

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
        self.currentCell.playBtn.hidden = NO;
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
        [self.currentCell.backgroundImageView addSubview:self.wmPlayer];
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
    self.title = @"视频详情";
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
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
    
    VideoBottomView *bottomView = [[VideoBottomView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(-3, 0);
    bottomView.layer.shadowOpacity = 0.4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 220;
    }else{
        return SCREEN_HEIGHT - 64;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftBtn setTitle:@"课件" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0x4DAC7D) forState:UIControlStateSelected];
        [leftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [changeView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(changeView);
            make.right.equalTo(changeView.mas_centerX);
            make.height.equalTo(changeView);
            make.top.equalTo(changeView);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightBtn setTitle:@"词汇" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0x4DAC7D) forState:UIControlStateSelected];
        [rightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [changeView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(changeView);
            make.left.equalTo(changeView.mas_centerX);
            make.height.equalTo(changeView);
            make.top.equalTo(changeView);
        }];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0x4DAC7D);
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
        [self changeClick:self.leftBtn];
        return changeView;
    }else{
        return nil;
    }
}
- (void)scrollClick:(UIButton *)sender{
    [self changeClick:sender];
    if (sender.tag == 101) {
        [self.scrollCell.scrollView setContentOffset:CGPointMake(0, 0) ];
    }else{
        [self.scrollCell.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) ];
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
    if (indexPath.section > 0) {
         WordWebViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordWebViewTableViewCell class])];
        cell.scrollSize = ^(CGFloat x) {
            NSLog(@"%f",x);
            if (x > SCREEN_WIDTH/2) {
                [self changeClick:self.rightBtn];
            }else{
                [self changeClick:self.leftBtn];
            }
        };
        self.scrollCell = cell;
        return cell;
    }else{
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([VideoTableViewCell class])];
        WeakSelf
        NSString *GPRSPlay = [[NSUserDefaults standardUserDefaults]objectForKey:@"GPRSPlay"];
        if ([kNetworkState isEqualToString:@"WIFI"] || [GPRSPlay isEqualToString:@"1"]) {
            cell.playStartClickBlock = ^(UIImageView *imageView, UIButton *sender) {
                sender.hidden = YES;
                [weakSelf releaseWMPlayer];
                weakSelf.currentCell = (VideoTableViewCell *)imageView.superview.superview;
                WMPlayerModel *playerModel = [WMPlayerModel new];
                playerModel.title = @"测试视频";
                playerModel.indexPath = indexPath;
                playerModel.videoURL = [NSURL URLWithString:@"https://oss.cooplan.cn/curriculums/%E5%88%B7%E9%A2%98%E8%AF%BE1/%E5%9B%9B%E7%BA%A7%E5%90%AC%E5%8A%9B%E5%88%B7%E9%A2%98%E8%AF%BE1_480.mp4"];
                weakSelf.wmPlayer = [[WMPlayer alloc] init];
                weakSelf.wmPlayer.tintColor = DRGBCOLOR;
                weakSelf.wmPlayer.playerModel = playerModel;
                weakSelf.wmPlayer.delegate = weakSelf;
                [imageView addSubview:weakSelf.wmPlayer];
                [weakSelf.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(imageView);
                }];
                [weakSelf.wmPlayer play];
            };
        }else{
            cell.playStartClickBlock = ^(UIImageView *imageView, UIButton *sender) {
                LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"移动网络下确定要播放吗" sureBtn:@"确定" cancleBtn:@"取消"];
                [alertView show];
                alertView.resultIndex = ^(NSInteger index) {
                    sender.hidden = YES;
                    [weakSelf releaseWMPlayer];
                    weakSelf.currentCell = (VideoTableViewCell *)imageView.superview.superview;
                    WMPlayerModel *playerModel = [WMPlayerModel new];
                    playerModel.title = @"测试视频";
                    playerModel.indexPath = indexPath;
                    playerModel.videoURL = [NSURL URLWithString:@"https://oss.cooplan.cn/curriculums/%E5%88%B7%E9%A2%98%E8%AF%BE1/%E5%9B%9B%E7%BA%A7%E5%90%AC%E5%8A%9B%E5%88%B7%E9%A2%98%E8%AF%BE1_480.mp4"];
                    weakSelf.wmPlayer = [[WMPlayer alloc] init];
                    weakSelf.wmPlayer.tintColor = DRGBCOLOR;
                    weakSelf.wmPlayer.playerModel = playerModel;
                    weakSelf.wmPlayer.delegate = weakSelf;
                    [imageView addSubview:weakSelf.wmPlayer];
                    [weakSelf.wmPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(imageView);
                    }];
                    [weakSelf.wmPlayer play];
                };
            };
        }
        cell.selectionStyle = NO;
        return cell;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self releaseWMPlayer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)releaseWMPlayer{
    [self.wmPlayer removeFromSuperview];
    self.wmPlayer = nil;
}
-(void)dealloc{
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
