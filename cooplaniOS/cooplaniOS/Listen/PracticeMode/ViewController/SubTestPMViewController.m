//
//  SubTestPMViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SubTestPMViewController.h"
#import "PracticeModeViewController.h"
#import "ListenPlay.h"
#import "PracticeModeHeaderView.h"
#import "AnswerViewController.h"
#import "PracticeModeTiKaCCell.h"
#import "SubTestAnswerViewController.h"
#import "FeedbackViewController.h"

@interface SubTestPMViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) ListenPlay *player;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) PracticeModeHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@property (nonatomic, strong) NSMutableArray *sectionsModelArray;

@property (nonatomic, strong) NSMutableArray *passageModelArray;
@property (nonatomic, strong) NSMutableArray *questionsModelArray;
@property (nonatomic, strong) NSMutableArray *optionsModelArray;

@property (nonatomic, assign) int correctInt;
@property (nonatomic, assign) int NoCorrectInt;
@property (nonatomic, strong) NSMutableArray *itemCountArray;
@property (nonatomic, strong) SectionsModel *modeSectionModel;
@property (nonatomic, strong) NSIndexPath *collectionIndexPath;
@property (nonatomic, assign) BOOL lastPlaying;
@property (nonatomic, assign) BOOL isFinish;//判断听力是否完成
@property (nonatomic, assign) CGPoint collectionCenter;
@end

@implementation SubTestPMViewController
-(NSMutableArray *)passageModelArray{
    if (!_passageModelArray) {
        _passageModelArray = [NSMutableArray array];
    }
    return _passageModelArray;
}
- (NSMutableArray *)questionsModelArray{
    if (!_questionsModelArray) {
        _questionsModelArray = [NSMutableArray array];
    }
    return _questionsModelArray;
}
- (NSMutableArray *)optionsModelArray{
    if (!_optionsModelArray) {
        _optionsModelArray = [NSMutableArray array];
    }
    return _optionsModelArray;
}
- (ListenPlay *)player{
    if (!_player) {
        NSString *className = NSStringFromClass([ListenPlay class]);
        _player = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    return _player;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UINib nibWithNibName:NSStringFromClass([PracticeModeHeaderView class]) bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    [self loadData];
    _correctInt = 0;
    _NoCorrectInt = 0;
    [self.player.player play];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPause) name:@"listenBackground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPlay) name:@"listenForeground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:@"playFinished" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findWordIsOpen) name:kFindWordIsOpen object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(findWordIsClose) name:kFindWordIsClose object:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player.player pause];
    });
}
- (void)findWordIsOpen{
    [UIView animateWithDuration:0.2 animations:^{
        self.tikaCollectionView.hidden = YES;
    }];
}
- (void)findWordIsClose{
    [UIView animateWithDuration:0.2 animations:^{
        self.tikaCollectionView.hidden = NO;
    } completion:^(BOOL finished) {
        self.tikaCollectionView.center = _collectionCenter;
    }];
}
- (void)loadData{
    DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
//    self.title = model.name;
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlString = [model.paperJsonName stringByRemovingPercentEncoding];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSDictionary *dict = [[NSDictionary alloc]init];
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *str2 = [[NSString alloc]initWithData:data encoding:encode];
        NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        if (data2 == nil) {
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }else{
           dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
        }
        NSLog(@" json error:%@",[error localizedDescription]);
        [self.passageModelArray removeAllObjects];
        [self.questionsModelArray removeAllObjects];
        [self.optionsModelArray removeAllObjects];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.headerView.practiceModeTopTitleLb.text = partModel.PartType;
                });
                    PassageModel *passageModel = [PassageModel mj_objectWithKeyValues:dict];
                    [self.passageModelArray addObject:passageModel];
                    for (QuestionsModel *questionModel in passageModel.Questions) {
                        questionModel.PassageId = passageModel.PassageId;
                        questionModel.PassageAudioStartTime = passageModel.PassageAudioStartTime;
                        questionModel.PassageAudioEndTime = passageModel.PassageAudioEndTime;
                        questionModel.PassageDirection = passageModel.PassageDirection;
                        questionModel.PassageDirectionAudioStartTime = passageModel.PassageDirectionAudioStartTime;
                        questionModel.PassageDirectionAudioEndTime = passageModel.PassageDirectionAudioEndTime;
                        [self.questionsModelArray addObject:questionModel];
//                        [self.passageModelArray addObject:questionModel];
//                        [self.itemCountArray addObject:questionModel];
                        passageModel.Questions = [NSMutableArray arrayWithArray:self.questionsModelArray];
                        for (OptionsModel *optionsModel in questionModel.options) {
                            [self.optionsModelArray addObject:optionsModel];
                        }
                    }
                    _NoCorrectInt += self.questionsModelArray.count;
                    //                            sectinsModel.Passages = [NSMutableArray arrayWithArray:self.passageModelArray];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tikaCollectionView reloadData];
                    });
        });
    }
}
- (void)initWithView{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@86);
    }];
    
    [self.view addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    WeakSelf
    self.player.paperName = self.title;
    self.player.contentError = ^{
        [weakSelf.player.player pause];
        weakSelf.player.playSongBtn.selected = YES;
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
        vc.feedbackType = 2;
        vc.errorType = 1;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
    [self.player addSubview:collectionView];
    [self.player insertSubview:collectionView atIndex:1];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(SCREEN_HEIGHT - self.headerView.height - 120 - SafeAreaTopHeight));
        make.top.equalTo(self.player.bottomView.mas_top).offset(-[Tool layoutForAlliPhoneHeight:130]);
    }];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[PracticeModeTiKaCCell class] forCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class])];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    _collectionCenter = CGPointMake(SCREEN_WIDTH/2, [Tool layoutForAlliPhoneHeight:SCREEN_HEIGHT - 220]);
    NSLog(@"%@,%@", NSStringFromCGPoint(_collectionCenter), NSStringFromCGPoint(self.tikaCollectionView.center));
    [self scrollViewDidScroll:collectionView];
    _isOpen = YES;
    
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGr.delegate = self;
    [self.tikaCollectionView addGestureRecognizer:panGr];
}
- (void)handlePan:(UIPanGestureRecognizer *)gr{
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [gr translationInView:self.tikaCollectionView];
    
    CGFloat minY = [Tool layoutForAlliPhoneHeight:185];//可拖动题卡的上限
    CGFloat maxY = UI_IS_IPHONE5 ? [Tool layoutForAlliPhoneHeight:SCREEN_HEIGHT - 150] :[Tool layoutForAlliPhoneHeight:SCREEN_HEIGHT - 200];//可拖动题卡的下限
//    NSLog(@"minX:%f,maxY:%f,gr.center.y:%f", minY,maxY, gr.view.center.y);
//    NSLog(@"%f",translation.y);
    CGFloat tranY = gr.view.center.y + translation.y;
    if (tranY == maxY) {
        _isOpen = NO;
    }
    if (tranY == minY) {
        _isOpen = YES;
    }
    if (tranY - 1 <= maxY && tranY + 1 >= minY) {
        //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        _collectionCenter = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
    }
    [gr setTranslation:CGPointZero inView:self.view];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.tikaCollectionView];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        if (absX > absY ) {
            return YES;
        } else if (absY > absX) {
            return NO;
        }
    }
    NSLog(@"当前手势:%@; 另一个手势:%@", gestureRecognizer, otherGestureRecognizer);
    return NO;
}

#pragma mark 播放完成
- (void)playFinished:(NSNotification *)notifi{
    _isFinish = YES;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.questionsModelArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, self.tikaCollectionView.bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PracticeModeTiKaCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class]) forIndexPath:indexPath];
//    SectionsModel *sectionModel = self.sectionsModelArray[indexPath.section];
//    dispatch_async(dispatch_get_main_queue(), ^{
    if ([self.sectionType isEqualToString:@"4-A"]) {
        self.headerView.practiceModeSubTitleLb.text = @"Section A";
    }else if ([self.sectionType isEqualToString:@"4-B"]){
        self.headerView.practiceModeSubTitleLb.text = @"Section B";
    }else{
        self.headerView.practiceModeSubTitleLb.text = @"Section C";
    }
//    });
    //监听滑到那个section
    QuestionsModel *questionsModel = self.questionsModelArray[indexPath.row];
    cell.questionsModel = questionsModel;
    cell.questionStr = [NSString stringWithFormat:@"%@",questionsModel.PassageDirection];
    cell.collectionIndexPath = indexPath;
    //cell 展开方法
    cell.UpAndDownBtnClick = ^(UIButton *btn) {
        if (_isOpen) {
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.backgroundColor = [UIColor clearColor];
                self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2);
            }];
            _isOpen = NO;
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
                self.tikaCollectionView.transform = CGAffineTransformIdentity;
            }];
            _isOpen = YES;
        }
    };
    WeakSelf
    cell.questionCellClick = ^(NSIndexPath *cellIndexPath, BOOL isCorrect) {
        NSIndexPath *nextIndexPath;
        nextIndexPath = [NSIndexPath indexPathForItem:cellIndexPath.item + 1 inSection:cellIndexPath.section];
        questionsModel.isCorrect = isCorrect;
        if (cellIndexPath.row + 1 < self.questionsModelArray.count) {
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else if (cellIndexPath.row + 1 == self.questionsModelArray.count){
            if (_isFinish) {
                for (QuestionsModel *quModel in self.questionsModelArray) {
                    if (quModel.isCorrect) {
                        _correctInt++;
                    }
                }
                float correctFloat = (float)_correctInt/(float)(_NoCorrectInt);
                [LTHttpManager addOnlyTestWithUserId:IS_USER_ID TestPaperId:@([self.testPaperId integerValue]) Type:@"1" Testpaper_type:self.sectionType Complete:^(LTHttpResult result, NSString *message, id data) {
                    if (result == LTHttpResultSuccess) {
                        [self gotoNextVC:correctFloat];
                    }
                }];
            }else{
                LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"听力还在进行中，确定交卷吗" sureBtn:@"交卷" cancleBtn:@"再检查下" ];
                finishView.resultIndex = ^(NSInteger index) {
                    for (QuestionsModel *quModel in self.questionsModelArray) {
                        if (quModel.isCorrect) {
                            _correctInt++;
                        }
                    }
                    float correctFloat = (float)_correctInt/(float)(_NoCorrectInt);
                    [LTHttpManager addOnlyTestWithUserId:IS_USER_ID TestPaperId:@([self.testPaperId integerValue]) Type:@"1" Testpaper_type:self.sectionType Complete:^(LTHttpResult result, NSString *message, id data) {
                        if (result == LTHttpResultSuccess) {
                            [self gotoNextVC:correctFloat];
                        }
                    }];
                };
                [finishView show];
            }
        }
    };
    return cell;
}
- (void)gotoNextVC:(CGFloat)correctFloat{
    DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
    SubTestAnswerViewController *vc = [[SubTestAnswerViewController alloc]init];
    vc.correct = [NSString stringWithFormat:@"%0.f",correctFloat * 100];
    vc.testPaperId = self.testPaperId;
    vc.paperName = model.name;
    vc.questionsArray = self.questionsModelArray;
    vc.sectionType = self.sectionType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tikaCollectionView) {
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stopRoll];
    [self.player.player pause];
    [self.player.playSongBtn setSelected:NO];
}
- (void)listenPause{
    NSLog(@"---%d",_lastPlaying ? 1:0);
    _lastPlaying = [self.player.player isPlaying];
    [self.player stopRoll];
    [self.player.player pause];
    [self.player.playSongBtn setSelected:NO];
}
- (void)listenPlay{
    NSLog(@"---%d",_lastPlaying ? 1:0);
    if (_lastPlaying) {
        [self.player.playSongBtn setSelected:YES];
        [self.player.player play];
        [self.player startRoll];
    }else{
        [self.player stopRoll];
        [self.player.player pause];
        [self.player.playSongBtn setSelected:NO];
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
