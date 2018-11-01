//
//  ReadSectionAViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSectionAViewController.h"
#import "ReadSATableViewCell.h"
#import "SAQuestionCollectionViewCell.h"
#import "SAOptionsCollectionViewCell.h"
#import "ReadSAResultsViewController.h"
#import "ReadRefreshGifHeader.h"
#import "ReadRfreshBackGifFooter.h"
#import "ReadSAModel.h"

NSString* sstring =  @"The method for making beer has changed over time. Hops (啤酒花)，for example, which give many amodern beer its bitter flavor, are a (26)_______ recent addition to the beverage. This was first mentioned in reference to brewing in the ninth century. Now, researchers have found a (27)_______ ingredient in residue (残留物) from 5,000-year-old beer brewing equipment. While digging two pits at a site in the central plains of China, scientists discovered fragments from pots and vessels. The different shapes of the containers (28)_______    they were used to brew, filter, and store beer. They may be ancient “beer-making tools,” and the earliest (29)_______ evidence of beer brewing in China, the researchers reported in the Proceedings of the National Academy of Sciences. To (30)_______    that theory, the team examined the yellowish, dried (31)_______    inside the vessels. The majority of the grains, about 80%, were from cereal crops like barley(大麦), and about 10% were bits of roots, (32)_______ lily, which would have made the beer sweeter, the scientists say. Barley was an unexpected find: the crop was domesticated in Western Eurasia and didn't become a (33)_______ food in central China until about 2,000 years ago, according to the researchers. Based on that timing, they indicate barley may have (34)_______ in the region not as food, but as (35)_______ material for beer brewing.";

@interface ReadSectionAViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL questionCardIsOpen;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) ReadSAModel *readModel;
@property (nonatomic, assign) NSInteger userIndex;//用户点击的题目
@property (nonatomic, assign) int correctInt;
@end

@implementation ReadSectionAViewController
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
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480]) collectionViewLayout:flowlayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAQuestionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAOptionsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
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
    self.title = @"选词填空";
    [self initWithView];
    _seconds = 0;
    _correctInt = 0;
    [self loadData];
}
- (void)loadData{
    [LTHttpManager getOneNewTestWithUserId:IS_USER_ID Type:@"4-E" Testpaper_kind:@"1Y" Testpaper_type:@"4-E" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSString *testPaperUrl = data[@"responseData"][@"testPaperUrl"];
            [LTHttpManager downloadURL:testPaperUrl progress:^(NSProgress *downloadProgress) {
            } destination:^(NSURL *targetPath) {
                NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                NSString *fileName = [url lastPathComponent];
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
                    if (data2 == nil) {
                        dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    }else{
                        dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                    }
                    self.readModel = [ReadSAModel mj_objectWithKeyValues:dict];
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }];
}
- (void)initWithView{
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];

    [self.collectionView.layer setCornerRadius:12];
    [self.collectionView.layer setShadowOpacity:0.2];
    [self.collectionView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.collectionView.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.collectionView.layer setMasksToBounds:NO];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-130);
    }];
    
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGr.delegate = self;
    [self.collectionView addGestureRecognizer:panGr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openQuestionCard:) name:kReadOpenQuestion object:nil];

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
        for (ReadSAAnswerModel *model in self.readModel.Answer) {
            if (model.isCorrect) {
                _correctInt++;
            }
        }
        NSLog(@"%d", _correctInt);
        ReadSAResultsViewController *vc = [ReadSAResultsViewController new];
        vc.userTime = self.timeLb.text;
        vc.questionsArray = self.readModel.Answer;
        float correctFloat = (float)_correctInt/(float)self.readModel.Answer.count * 100;
        vc.correct = [NSString stringWithFormat:@"%.0f",correctFloat];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [finishView show];
}
- (void)time{
    self.timeLb.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)_seconds++]];
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

- (void)openQuestionCard:(NSNotification *)notifi{
    NSInteger index = [notifi.object[@"userClick"] integerValue];
    _userIndex = index;
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.center = self.view.center;
        _questionCardIsOpen = YES;
    }];
}
-(void)handlePan:(UIPanGestureRecognizer *)gr{
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [gr translationInView:self.collectionView];
    
    CGFloat minY = SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的上限
    CGFloat maxY = SCREEN_HEIGHT - 130 - SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的下限
//    NSLog(@"minX:%f,maxY:%f,gr.center.y:%f", minY,maxY, gr.view.center.y);
    CGFloat tranY = gr.view.center.y + translation.y;
    if (tranY <= minY) {
        //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
        tranY = minY;
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
    }
    if (tranY >= maxY) {
        tranY = maxY;
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
    }
    gr.view.center = CGPointMake(gr.view.center.x, tranY);
    [gr setTranslation:CGPointZero inView:self.view];
}
#pragma mark UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
    if (self.readModel.Passage) {
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.readModel.Passage];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 100;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSATableViewCell *cell = [[ReadSATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (self.readModel.Passage) {
        cell.passage = self.readModel.Passage;
    }
    cell.selectionStyle = NO;
    return cell;
}
#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return self.readModel.Options.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return CGSizeMake(self.collectionView.width, 45);
    }else if (indexPath.section == 0){
        return CGSizeMake(self.collectionView.width, 35);
    }else{
        return CGSizeMake((self.collectionView.width - 10)/2, 44);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        [cell.layer setCornerRadius:12.0f];
        [cell.layer setMasksToBounds:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"上下拉动"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(30);
            make.right.equalTo(cell.mas_right).offset(-30);
            make.height.equalTo(@35);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        return cell;
    }else if (indexPath.section == 1){
        SAQuestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class]) forIndexPath:indexPath];
        cell.questionLb.text = [NSString stringWithFormat:@"%@", self.readModel.Question];
        return cell;
    }else{
        SAOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class]) forIndexPath:indexPath];
        if (indexPath.row < self.readModel.Options.count) {
            cell.model = self.readModel.Options[indexPath.row];
        }
        return cell;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (_questionCardIsOpen) {
            ReadSAOptionsModel *model = self.readModel.Options[indexPath.row];
            [[NSNotificationCenter defaultCenter]postNotificationName:kClickReadCard object:nil userInfo:@{@"options":[NSString stringWithFormat:@"%@", model.Text], @"index":@(indexPath.row)}];
            model.isSelectedOption = YES;
            ReadSAAnswerModel *questionModel = self.readModel.Answer[_userIndex ? _userIndex : 0];
            if ([model.Text isEqualToString:questionModel.Alphabet]) {
                questionModel.isCorrect = YES;
            }
            questionModel.yourAnswer = model.Alphabet;
            [collectionView reloadData];
            [self.view setNeedsUpdateConstraints];
            [self.view updateConstraints];
            [self.view layoutIfNeeded];
            [UIView animateWithDuration:0.2 animations:^{
                self.collectionView.frame = CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480]);
                _questionCardIsOpen = NO;
            }];
        }else{
            SVProgressShowStuteText(@"请先选择一题", NO);
            return;
        }
    }
}
//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:UIColorFromRGB(0xFAE7B0)];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:[UIColor whiteColor]];
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
