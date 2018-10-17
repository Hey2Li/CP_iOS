//
//  ReadSectionBViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSectionBViewController.h"
#import "SAQuestionCollectionViewCell.h"
#import "ReadSBTableViewCell.h"
#import "ReadSBQuestionCardCCell.h"
#import "ReadSBResultViewController.h"
#import "ReadSBModel.h"

NSString* ssstring =  @"[A] I have always been a poor test-taker. So it may seem rather strange that I have returned to college to finish the degree I left undone some four decades ago. I am making my way through Columbia University, surrounded by students who quickly supply the verbal answer while I am still processing the question.";

@interface ReadSectionBViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL questionCardIsOpen;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) ReadSBModel *readSbModel;

@property (nonatomic, assign) int correctInt;
@property (nonatomic, assign) int NoCorrectInt;
@end

@implementation ReadSectionBViewController
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
        [_collectionView registerClass:[ReadSBQuestionCardCCell class] forCellWithReuseIdentifier:NSStringFromClass([ReadSBQuestionCardCCell class])];
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
    self.title = @"段落匹配";
    self.correctInt = 0;
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"20160601SB" ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    NSData *data1 = [NSData dataWithContentsOfFile:path];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str2 = [[NSString alloc]initWithData:data1 encoding:encode];
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict1;
    if (data2 == nil) {
        dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }else{
        dict1 = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:nil];
    }
    self.readSbModel = [ReadSBModel mj_objectWithKeyValues:dict1];
    NSLog(@"%@, %@", self.readSbModel.Options, self.readSbModel.Passage);
    [self.tableView reloadData];
    [self.collectionView reloadData];
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
    WeakSelf
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [weakSelf.tableView.mj_footer endRefreshing];
        });
    }];
    [footer setTitle:@"要再来一题吗" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载下一题" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在为您加载" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@40);
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
        make.width.equalTo(@19);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    pageLb.textColor = UIColorFromRGB(0x999999);
    pageLb.font = [UIFont systemFontOfSize:12];
    pageLb.text = @"1/1";
    
    [bottomView.layer setShadowColor:[UIColor blackColor].CGColor];
    [bottomView.layer setShadowOffset:CGSizeMake(0, -2)];
    [bottomView.layer setShadowOpacity:0.2];
    [bottomView.layer setMasksToBounds:NO];
    
    [takePaperBtn addTarget:self action:@selector(takePaperClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)takePaperClick:(UIButton *)btn{
    LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定交卷吗" sureBtn:@"交卷" cancleBtn:@"再检查下" ];
    finishView.resultIndex = ^(NSInteger index) {
        [self.navigationController pushViewController:ReadSBResultViewController.new animated:YES];
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
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    if (absX > absY ) {
        return;
    } else if (absY > absX) {
        CGFloat minY = SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的上限
        CGFloat maxY = SCREEN_HEIGHT - 130 - SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的下限
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
    
}
#pragma mark UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.readSbModel.Options.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSBPassageModel *passageModel = self.readSbModel.Passage[indexPath.row];
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:passageModel.Text];
    [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
    textStr.yy_lineSpacing = 8;
    //计算文本尺寸
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight + 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSBTableViewCell *cell = [[ReadSBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = NO;
    ReadSBPassageModel *passageModel = self.readSbModel.Passage[indexPath.row];
    cell.passage = [NSString stringWithFormat:@"%@  %@", passageModel.Alphabet, passageModel.Text];
    return cell;
}

#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.readSbModel.Options.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480]);
}
 - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadSBQuestionCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSBQuestionCardCCell class]) forIndexPath:indexPath];
     cell.superIndexPath = indexPath;
     cell.optionsModel = self.readSbModel.Options[indexPath.row];
     cell.questionsArray = self.readSbModel.Passage;
     cell.question = self.readSbModel.Question;
     cell.collectionScroll = ^(NSIndexPath * indexPaths) {
         if (indexPaths.row + 1 < self.readSbModel.Options.count) {
             [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPaths.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
         }else{
             LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定交卷吗" sureBtn:@"交卷" cancleBtn:@"再检查下" ];
             finishView.resultIndex = ^(NSInteger index) {
                 for (ReadSBOptionsModel *quModel in self.readSbModel.Options) {
                     if (quModel.isCorrect) {
                         _correctInt++;
                     }
                 }
                 NSLog(@"%d", _correctInt);
                 ReadSBResultViewController *vc = [ReadSBResultViewController new];
                 vc.userTime = self.timeLb.text;
                 vc.questionsArray = self.readSbModel.Options;
                 float correctFloat = (float)_correctInt/(float)self.readSbModel.Options.count * 100;
                 vc.correct = [NSString stringWithFormat:@"%.0f",correctFloat];
                 [self.navigationController pushViewController:vc animated:YES];
             };
             [finishView show];
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
