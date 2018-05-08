//
//  PracticeModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PracticeModeViewController.h"
#import "ListenPlay.h"
#import "PracticeModeHeaderView.h"
#import "AnswerViewController.h"
#import "PracticeModeTiKaCCell.h"
#import "PMAnswerViewController.h"
#import "FeedbackViewController.h"

@interface PracticeModeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGR;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) ListenPlay *player;
@property (nonatomic, strong) PracticeModeHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@property (nonatomic, strong) NSMutableArray *partModelArray;
@property (nonatomic, strong) NSMutableArray *sectionsModelArray;
@property (nonatomic, strong) NSMutableArray *passageModelArray;
@property (nonatomic, strong) NSMutableArray *questionsModelArray;
@property (nonatomic, strong) NSMutableArray *optionsModelArray;
@property (nonatomic, strong) TestPaperModel *testPaperModel;
@property (nonatomic, copy) NSString *paperSection;
@property (nonatomic, assign) int correctInt;
@property (nonatomic, assign) int NoCorrectInt;
@end

@implementation PracticeModeViewController
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
    [self initWithView];
    [self loadData];
    _correctInt = 0;
    _NoCorrectInt = 0;
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
                self.headerView.practiceModeTopTitleLb.text = partModel.PartType;
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
                            });
                        }
                    }
                }
            }
        }
    });
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
    self.player.contentError = ^{
        [weakSelf.player.player pause];
        weakSelf.player.playSongBtn.selected = YES;
        FeedbackViewController *vc = [[FeedbackViewController alloc]init];
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
//        make.bottom.equalTo(self.player.bottomView.mas_top);
        make.height.equalTo(@(SCREEN_HEIGHT - 86 - 120 - 64));
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    collectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[PracticeModeTiKaCCell class] forCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class])];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    self.swipeDownGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.swipeDownGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.tikaCollectionView addGestureRecognizer:self.swipeDownGR];
    
    [self.swipeUpGR setDirection:UISwipeGestureRecognizerDirectionUp];
    self.swipeUpGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.tikaCollectionView addGestureRecognizer:self.swipeUpGR];
    [self scrollViewDidScroll:collectionView];
    _isOpen = YES;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.passageModelArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.questionsModelArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, self.tikaCollectionView.bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PracticeModeTiKaCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class]) forIndexPath:indexPath];
    QuestionsModel *questionsModel = self.questionsModelArray[indexPath.row];
    cell.questionsModel = questionsModel;
    PassageModel *passageModel = self.passageModelArray[indexPath.section];
    cell.questionStr = [NSString stringWithFormat:@"%@",passageModel.PassageDirection];
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
    cell.collectionIndexPath = indexPath;
    WeakSelf
    //cell tableview点击方法 isCorrect 是否正确 cellIndexPath collection cell 的indexPath
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
        NSLog(@"indexPathrow+1 = %ld---indexPath.row%ld---",cellIndexPath.row + 1, cellIndexPath.row);
        if (cellIndexPath.row + 1 < self.questionsModelArray.count) {
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else if (cellIndexPath.row + 1 == self.questionsModelArray.count){
            float correctFloat = (float)_correctInt/(float)(_correctInt + _NoCorrectInt);
            PMAnswerViewController *vc = [[PMAnswerViewController alloc]init];
            vc.correct = [NSString stringWithFormat:@"%0.f",correctFloat * 100];
            vc.paperName = _testPaperModel.PaperFullName;
            vc.paperSection = _paperSection;
            vc.questionsArray = self.questionsModelArray;
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tikaCollectionView) {
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark 手势操作
- (void)SwipeGR:(UISwipeGestureRecognizer *)gr{
    NSLog(@"%lu",gr.direction);
    [self.view layoutIfNeeded];
    if (gr.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformIdentity;
        }];
        _isOpen = YES;
    }
    if (gr.direction == UISwipeGestureRecognizerDirectionDown) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/3 + 50);
        }];
        _isOpen = NO;
    }
}
- (void)panGr:(UIPanGestureRecognizer *)pan{
    [self.view layoutIfNeeded];
    if (_isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2);
            _isOpen = !_isOpen;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformIdentity;
            _isOpen = !_isOpen;
        }];
    }
}
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor blackColor];
//        [self addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(tableView.mas_left);
//            make.right.equalTo(tableView.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(tableView.mas_top).offset(2);
//        }];
//        [btn setTitle:@"click" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.player.player play];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.player.player pause];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stopRoll];
    [self.player.player pause];
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
