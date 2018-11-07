//
//  ReadSectionCViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSectionCViewController.h"
#import "SAQuestionCollectionViewCell.h"
#import "ReadSBTableViewCell.h"
#import "ReadSCQuestionCardCCell.h"
#import "ReadSCResultsViewController.h"
#import "ReadSCModel.h"

@interface ReadSectionCViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL questionCardIsOpen;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) ReadSCModel *readScModel;
@property (nonatomic, strong) UILabel *pageLb;
@property (nonatomic, assign) int correctInt;
@property (nonatomic, assign) int NoCorrectInt;

@property (nonatomic, strong) DownloadFileModel *downloadModel;
@property (nonatomic, copy) NSString *downloadJsonUrl;
@end

@implementation ReadSectionCViewController
- (NSTimer *)myTimer{
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(time) userInfo:nil repeats:YES];
    }
    return _myTimer;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = SCREEN_HEIGHT;
        _tableView.backgroundColor  = UIColorFromRGB(0xF7F7F7);
    }
    return _tableView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480]) collectionViewLayout:flowlayout];
        [_collectionView registerClass:[ReadSCQuestionCardCCell class] forCellWithReuseIdentifier:NSStringFromClass([ReadSCQuestionCardCCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    self.title = @"仔细阅读";
    _correctInt = 0;
    self.downloadModel = [[DownloadFileModel alloc]init];
    [self loadData];
}
- (void)loadData{
    if (self.readSCPassageOneId) {
        DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.readSCPassageOneId];
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
            if (data == nil) {
                dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
            }else{
                dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }
            self.readScModel = [ReadSCModel mj_objectWithKeyValues:dict];
            self.pageLb.text = [NSString stringWithFormat:@"1/%ld", self.readScModel.Questions.count];;
            self.readScModel.testPaperName = model.name;
            [self.tableView reloadData];
            [self.collectionView reloadData];
        }
    }else{
        [LTHttpManager getOneNewTestWithUserId:IS_USER_ID Type:@"4-F" Testpaper_kind:@"1Y" Testpaper_type:@"4-F" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                self.readSCPassageOneId = data[@"responseData"][@"id"];
                self.downloadJsonUrl = data[@"responseData"][@"testPaperUrl"];
                self.downloadModel.testPaperId = data[@"responseData"][@"id"];
                self.downloadModel.name = data[@"responseData"][@"name"];
                self.downloadModel.info = data[@"responseData"][@"info"];
                self.downloadModel.number = data[@"responseData"][@"number"];                [LTHttpManager downloadURL:self.downloadJsonUrl progress:^(NSProgress *downloadProgress) {
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    
                    self.downloadModel.paperJsonName = fileName;
                    J_Update(self.downloadModel).Columns(@[@"paperJsonName"]).updateResult;
                    
                    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *urlString = [fileName stringByRemovingPercentEncoding];
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:fullPath]) {
                        NSDictionary *dict = [[NSDictionary alloc]init];
                        NSData *data = [NSData dataWithContentsOfFile:fullPath];
                        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSString *str2 = [[NSString alloc]initWithData:data encoding:encode];
                        NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *error;
                        if (data == nil) {
                            dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                        }else{
                            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        }
                        self.readScModel = [ReadSCModel mj_objectWithKeyValues:dict];
                        self.pageLb.text = [NSString stringWithFormat:@"1/%ld", self.readScModel.Questions.count];
                        self.readScModel.testPaperName = self.downloadModel.name;
                        [self.tableView reloadData];
                        [self.collectionView reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];
                J_Insert(self.downloadModel).updateResult;
            }
        }];
    }
}
- (void)initWithView{
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-130);
    }];
    
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGr.delegate = self;
    [self.collectionView addGestureRecognizer:panGr];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openQuestionCard) name:kReadOpenQuestion object:nil];
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        if (UI_IS_IPHONEX) {
            make.height.equalTo(@60);
        }else{
            make.height.equalTo(@40);
        }
    }];
    UILabel *loadTimeLb = [UILabel new];
    [bottomView addSubview:loadTimeLb];
    [loadTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(36);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    loadTimeLb.textColor = UIColorFromRGB(0x999999);
    loadTimeLb.font = [UIFont systemFontOfSize:12];
    loadTimeLb.text = @"00:00";
    self.timeLb = loadTimeLb;
    [self myTimer];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];

    UIButton *takePaperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePaperBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [takePaperBtn setTitle:@"交卷" forState:UIControlStateNormal];
    [takePaperBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateNormal];
    [takePaperBtn.layer setBorderWidth:1.0f];
    [takePaperBtn.layer setBorderColor:UIColorFromRGB(0xFFCE43).CGColor];
    [takePaperBtn.layer setCornerRadius:10];
    [bottomView addSubview:takePaperBtn];
    [takePaperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.equalTo(@102);
        make.height.equalTo(@26);
    }];
    
    UILabel *pageLb = [UILabel new];
    [bottomView addSubview:pageLb];
    [pageLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-36);
        make.height.equalTo(@20);
        make.width.equalTo(@40);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    pageLb.textColor = UIColorFromRGB(0x999999);
    pageLb.font = [UIFont systemFontOfSize:12];
    self.pageLb = pageLb;

    [bottomView.layer setShadowColor:[UIColor blackColor].CGColor];
    [bottomView.layer setShadowOffset:CGSizeMake(0, -2)];
    [bottomView.layer setShadowOpacity:0.2];
    [bottomView.layer setMasksToBounds:NO];
    [takePaperBtn addTarget:self action:@selector(takePaperClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark 交卷
- (void)takePaperClick:(UIButton *)btn{
    LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定交卷吗" sureBtn:@"交卷" cancleBtn:@"再检查下" ];
    finishView.resultIndex = ^(NSInteger index) {
        for (QuestionsItem *quModel in self.readScModel.Questions) {
            if (quModel.isCorrect) {
                _correctInt++;
            }
        }
        [LTHttpManager addOnlyTestWithUserId:IS_USER_ID TestPaperId:@([self.readSCPassageOneId integerValue]) Type:@"2" Testpaper_type:@"4-F" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
            }
        }];
        NSLog(@"%d", _correctInt);
        ReadSCResultsViewController *vc = [ReadSCResultsViewController new];
        vc.userTime = self.timeLb.text;
        vc.questionsArray = self.readScModel.Questions;
        float correctFloat = (float)_correctInt/(float)(self.readScModel.Questions.count ) * 100;
        vc.readSCPassageOneId = self.readSCPassageOneId;
        vc.paperName = self.readScModel.testPaperName;
        vc.correct = [NSString stringWithFormat:@"%.0f",correctFloat];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [finishView show];
}
//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSString *)totalTime{
    NSInteger seconds = [totalTime integerValue];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
}
- (void)time{
    self.timeLb.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)_seconds++]];
}
- (void)openQuestionCard{
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.center = self.view.center;
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self.collectionView];
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        if (absX > absY ) {
            return YES;
        } else if (absY > absX) {
            return NO;
        }
    }
    return NO;
}
-(void)handlePan:(UIPanGestureRecognizer *)gr{
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [gr translationInView:self.collectionView];
    
    CGFloat minY = SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的上限
    CGFloat maxY = SCREEN_HEIGHT - 130 - SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的下限
    NSLog(@"minX:%f,maxY:%f,gr.center.y:%f", minY,maxY, gr.view.center.y);
    CGFloat tranY = gr.view.center.y + translation.y;
    if (tranY <= minY) {
        //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
        tranY = minY;
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
    }else if (tranY >= maxY) {
        tranY = maxY;
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
    }else{
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        [gr setTranslation:CGPointZero inView:self.view];
    }
}
#pragma mark UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.readScModel.Passage) {
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.readScModel.Passage];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 20;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSBTableViewCell *cell = [[ReadSBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.readScModel.Passage) {
        cell.passage = self.readScModel.Passage;
    }
    cell.selectionStyle = NO;
    return cell;
}

#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.readScModel.Questions.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480]);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadSCQuestionCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSCQuestionCardCCell class]) forIndexPath:indexPath];
    cell.model = self.readScModel.Questions[indexPath.row];
    cell.passageNoLb.text = self.readScModel.Question;
    cell.superIndexPath = indexPath;
    cell.cellClick = ^(NSIndexPath * _Nonnull nextIndexPath) {
        if (nextIndexPath.row + 1 < self.readScModel.Questions.count) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }else{
            [self takePaperClick:nil];
        }
    };
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        self.pageLb.text = [NSString stringWithFormat:@"%.0f/%lu", self.collectionView.contentOffset.x/self.collectionView.width + 1, (unsigned long)self.readScModel.Questions.count];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.myTimer invalidate];
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
