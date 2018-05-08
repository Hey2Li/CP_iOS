//
//  TestModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestModeViewController.h"
#import "ListenPaperViewController.h"
#import "TikaCollectionViewCell.h"
#import "ListenPlay.h"
#import "AnswerViewController.h"
#import "TestModeBottomView.h"
#import "QuestionTableViewCell.h"
#import "SUPlayer.h"

@interface TestModeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@property (nonatomic, strong) UITableView *questionTableView;
@property (nonatomic, strong) TestModeBottomView *bottomView;
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, strong) NSMutableArray *partModelArray;
@property (nonatomic, strong) NSMutableArray *sectionsModelArray;
@property (nonatomic, strong) NSMutableArray *passageModelArray;
@property (nonatomic, strong) NSMutableArray *questionsModelArray;
@property (nonatomic, strong) NSMutableArray *optionsModelArray;
@property (nonatomic, strong) TestPaperModel *testPaperModel;
@property (nonatomic, assign) int correctInt;
@property (nonatomic, assign) int NoCorrectInt;
@property (nonatomic, copy) NSString *paperSection;
@property (nonatomic, strong) NSIndexPath *collectionIndexPath;
@end

@implementation TestModeViewController
- (NSMutableArray *)partModelArray{
    if (!_partModelArray) {
        _partModelArray = [NSMutableArray array];
    }
    return _partModelArray;
}
- (NSMutableArray *)sectionsModelArray{
    if (!_sectionsModelArray) {
        _sectionsModelArray = [NSMutableArray array];
    }
    return _sectionsModelArray;
}
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
- (SUPlayer *)player{
    if (!_player) {
        NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"2017年6月四级真题（一）" withExtension:@"MP3"];
        _player = [[SUPlayer alloc]initWithURL:fileUrl];
        [_player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        [_player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
        [_player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _player;
}
- (UITableView *)questionTableView{
    if (!_questionTableView) {
        _questionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [self.view addSubview:_questionTableView];
        [_questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.tikaCollectionView.mas_top);
        }];
        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
        _questionTableView.estimatedRowHeight = 50;
        _questionTableView.rowHeight = UITableViewAutomaticDimension;
        _questionTableView.separatorStyle = NO;
        [_questionTableView registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionTableViewCell class])];
    }
    return _questionTableView;
}
- (TestModeBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TestModeBottomView alloc]init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.view);
        }];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self.view setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [self loadData];
    _correctInt = 0;
    _NoCorrectInt = 0;
    [self initWithNavi];
}
- (void)initWithNavi{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}
- (void)back{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)loadData{
    NSString *str = [[NSBundle mainBundle] pathForResource:@"CET-Template" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:str];
    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str2 = [[NSString alloc]initWithData:data encoding:encode];
    NSData *data2 = [str2 dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:nil];
    TestPaperModel *model = [TestPaperModel mj_objectWithKeyValues:dict];
    _testPaperModel = model;
    [self.partModelArray removeAllObjects];
    [self.sectionsModelArray removeAllObjects];
    [self.passageModelArray removeAllObjects];
    [self.questionsModelArray removeAllObjects];
    [self.optionsModelArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (PartsModel *partModel in model.Parts) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            [self.partModelArray addObject:partModel];
            for (SectionsModel *sectinsModel in partModel.Sections) {
                _paperSection = sectinsModel.SectionTitle;
                [self.sectionsModelArray addObject:sectinsModel];
                for (PassageModel *passageModel in sectinsModel.Passage) {
                    [self.passageModelArray addObject:passageModel];
                    for (QuestionsModel *questionModel in passageModel.Questions) {
                        [self.questionsModelArray addObject:questionModel];
                        for (OptionsModel *optionsModel in questionModel.Options) {
                            [self.optionsModelArray addObject:optionsModel];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tikaCollectionView reloadData];
                                [self.questionTableView reloadData];
                            });
                        }
                    }
                }
            }
        }
    });
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stop];
}
#pragma mark 播放完成
- (void)playFinished:(NSNotification *)notifi{
    [self.player seekToTime:0];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *time = [NSString stringWithFormat:@"%@",[self convertStringWithTime:self.player.progress * self.player.duration]];
            self.bottomView.leftTimeLb.text = time;
        });
    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        //
    }
}
- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.2f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}
- (void)initWithView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10);
        make.height.equalTo(@(SCREEN_HEIGHT/2 - 25));
    }];

    collectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TikaCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    
    [self questionTableView];
    [self.bottomView.donePapersBtn addTarget:self action:@selector(donePaperClick:) forControlEvents:UIControlEventTouchUpInside];
    [self scrollViewDidScroll:collectionView];
 
}
- (void)donePaperClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定交卷" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[AnswerViewController alloc]init] animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.sectionsModelArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  2;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/2 - 25);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    _collectionIndexPath = indexPath;
    TikaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class]) forIndexPath:indexPath];
    QuestionsModel *questionsModel = self.questionsModelArray[indexPath.row];
    cell.questionsModel = questionsModel;
    PassageModel *passageModel = self.passageModelArray[indexPath.section];
    cell.questionStr = [NSString stringWithFormat:@"%@",passageModel.PassageDirection];
    cell.collectionIndexPath = indexPath;
    WeakSelf
    cell.questionCellClick = ^(NSIndexPath *cellIndexPath, BOOL isCorrect) {
        NSIndexPath *nextIndexPath;
        if (cellIndexPath.row == self.questionsModelArray.count && cellIndexPath.section < self.passageModelArray.count) {
            nextIndexPath = [NSIndexPath indexPathForItem:cellIndexPath.item + 1 inSection:cellIndexPath.section];
        }else{
            nextIndexPath = [NSIndexPath indexPathForItem:cellIndexPath.item + 1 inSection:cellIndexPath.section];
        }
        questionsModel.isCorrect = isCorrect;
        if (isCorrect) {
            _correctInt++;
        }else{
            _NoCorrectInt++;
        }
        if (cellIndexPath.row + 1 < self.questionsModelArray.count) {
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else if (cellIndexPath.row + 1 == self.questionsModelArray.count){
            float correctFloat = (float)_correctInt/(float)(_correctInt + _NoCorrectInt);
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            vc.correct = [NSString stringWithFormat:@"%0.f",correctFloat * 100];
            vc.paperName = _testPaperModel.PaperFullName;
            vc.paperSection = _paperSection;
            vc.questionsArray = self.questionsModelArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    //    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tikaCollectionView) {
        int index = scrollView.contentOffset.x/SCREEN_WIDTH;
        self.bottomView.questionIndexLb.text = [NSString stringWithFormat:@"%d/%lu",index+1, self.questionsModelArray.count * self.sectionsModelArray.count];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sectionsModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionTableViewCell class])];
    PartsModel *partsModel = self.partModelArray[0];
    SectionsModel *sectionModel = self.sectionsModelArray[_collectionIndexPath.section];
    cell.selectionStyle = NO;
    cell.TopTitleLb.text = partsModel.PartType;
    cell.sectionLb.text = [NSString stringWithFormat:@"%@\n%@",sectionModel.SectionTitle,sectionModel.SectionType];
    NSLog(@"%@",sectionModel.SectionTitle);
    cell.directionsLb.text = sectionModel.SectionDirection;
    return cell;
}
-(void)viewDidAppear:(BOOL)animated{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定考试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.player play];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
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
