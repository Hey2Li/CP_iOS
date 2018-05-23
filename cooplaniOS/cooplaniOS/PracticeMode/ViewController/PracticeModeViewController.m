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
@property (nonatomic, strong) NSMutableArray *itemCountArray;
@property (nonatomic, strong) SectionsModel *modeSectionModel;
@property (nonatomic, strong) NSIndexPath *collectionIndexPath;
@property (nonatomic, assign) BOOL lastPlaying;
@end

@implementation PracticeModeViewController
@synthesize modeSectionModel;

- (NSMutableArray *)itemCountArray{
    if (!_itemCountArray) {
        _itemCountArray = [NSMutableArray array];
    }
    return _itemCountArray;
}
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
    [self.player.player play];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPause) name:@"listenBackground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPlay) name:@"listenForeground" object:nil];
}
- (void)loadData{
    DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlString = [model.paperJsonName stringByRemovingPercentEncoding];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSData *data = [NSData dataWithContentsOfFile:fullPath];
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
                if (_mode < 3) {
                    for (SectionsModel *sectinsModel in partModel.Sections) {
                        _paperSection = sectinsModel.SectionTitle;
                        [self.sectionsModelArray addObject:sectinsModel];
                    }
                    modeSectionModel = self.sectionsModelArray[0];
                    for (PassageModel *passageModel in modeSectionModel.Passage) {
                        [self.questionsModelArray removeAllObjects];
                        for (QuestionsModel *questionModel in passageModel.Questions) {
                            questionModel.PassageId = passageModel.PassageId;
                            questionModel.PassageAudioStartTime = passageModel.PassageAudioStartTime;
                            questionModel.PassageAudioEndTime = passageModel.PassageAudioEndTime;
                            questionModel.PassageDirection = passageModel.PassageDirection;
                            questionModel.PassageDirectionAudioStartTime = passageModel.PassageDirectionAudioStartTime;
                            questionModel.PassageDirectionAudioEndTime = passageModel.PassageDirectionAudioEndTime;
                            [self.questionsModelArray addObject:questionModel];
                            [self.passageModelArray addObject:questionModel];
                            [self.itemCountArray addObject:questionModel];
                            passageModel.Questions = [NSMutableArray arrayWithArray:self.questionsModelArray];
                            for (OptionsModel *optionsModel in questionModel.Options) {
                                [self.optionsModelArray addObject:optionsModel];
                            }
                        }
                        modeSectionModel.Passage = [NSMutableArray arrayWithArray:self.passageModelArray];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tikaCollectionView reloadData];
                        });
                    }
                }else if (_mode == 3){
                    [self.passageModelArray removeAllObjects];
                    for (SectionsModel *sectinsModel in partModel.Sections) {
                        _paperSection = sectinsModel.SectionTitle;
                        [self.sectionsModelArray addObject:sectinsModel];
                        [self.passageModelArray removeAllObjects];
                        for (PassageModel *passageModel in sectinsModel.Passage) {
                            [self.questionsModelArray removeAllObjects];
                            for (QuestionsModel *questionModel in passageModel.Questions) {
                                questionModel.PassageId = passageModel.PassageId;
                                questionModel.PassageAudioStartTime = passageModel.PassageAudioStartTime;
                                questionModel.PassageAudioEndTime = passageModel.PassageAudioEndTime;
                                questionModel.PassageDirection = passageModel.PassageDirection;
                                questionModel.PassageDirectionAudioStartTime = passageModel.PassageDirectionAudioStartTime;
                                questionModel.PassageDirectionAudioEndTime = passageModel.PassageDirectionAudioEndTime;
                                [self.questionsModelArray addObject:questionModel];
                                [self.passageModelArray addObject:questionModel];
                                [self.itemCountArray addObject:questionModel];
                                passageModel.Questions = [NSMutableArray arrayWithArray:self.questionsModelArray];
                                for (OptionsModel *optionsModel in questionModel.Options) {
                                    [self.optionsModelArray addObject:optionsModel];
                                }
                            }
                            sectinsModel.Passage = [NSMutableArray arrayWithArray:self.passageModelArray];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.tikaCollectionView reloadData];
                            });
                        }
                    }
                    
                }
                __block NSArray *array;
                NSMutableArray *questionAndArray = [NSMutableArray array];
                for (SectionsModel *secModel in self.sectionsModelArray) {
                    for (QuestionsModel *quesModel in secModel.Passage) {
                        NSString *question = quesModel.QuestionNo;
                        NSString *paperId = _testPaperModel.PaperSerialNumber;
                        NSDictionary *dict = @{@"testPaperNum":paperId,@"topicNum":question};
                        [questionAndArray addObject:dict];
                    }
                }
                [LTHttpManager questionMistakesWithJsonString:[self arrayToJSONString:questionAndArray] Complete:^(LTHttpResult result, NSString *message, id data) {
                    if (LTHttpResultSuccess == result) {
                        array = data[@"responseData"];
                        int q = 0;
                        if (q < array.count) {
                            for (SectionsModel *sectinsModel in self.sectionsModelArray) {
                                for (QuestionsModel *questionModel in sectinsModel.Passage) {
                                    questionModel.correctStr = array[q][@"ratio"];
                                    q++;
                                }
                            }
                        }
                    }
                }];
            }
        });
    }
}
- (NSString *)arrayToJSONString:(NSArray *)array

{
    
    NSError *error = nil;
    //    NSMutableArray *muArray = [NSMutableArray array];
    //    for (NSString *userId in array) {
    //        [muArray addObject:[NSString stringWithFormat:@"\"%@\"", userId]];
    //    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    NSLog(@"json array is: %@", jsonResult);
    return jsonString;
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
    [self scrollViewDidScroll:collectionView];
    _isOpen = YES;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_mode < 3) {
        return 1;
    }else{
        return self.sectionsModelArray.count;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_mode < 3) {
        return modeSectionModel.Passage.count;
    }else{
         SectionsModel *model = self.sectionsModelArray[section];
        return model.Passage.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, self.tikaCollectionView.bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PracticeModeTiKaCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class]) forIndexPath:indexPath];
    SectionsModel *sectionModel = self.sectionsModelArray[indexPath.section];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headerView.practiceModeSubTitleLb.text = sectionModel.SectionTitle;
    });
    //监听滑到那个section
    if (_mode == 3) {
        QuestionsModel *questionsModel = sectionModel.Passage[indexPath.row];
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
            if (cellIndexPath.row == sectionModel.Passage.count - 1 && cellIndexPath.section < self.sectionsModelArray.count - 1) {
                nextIndexPath = [NSIndexPath indexPathForItem:0 inSection:cellIndexPath.section + 1];
                [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }else{
                nextIndexPath = [NSIndexPath indexPathForItem:cellIndexPath.item + 1 inSection:cellIndexPath.section];
            }
            questionsModel.isCorrect = isCorrect;
            if (isCorrect) {
                _correctInt++;
            }else{
                _NoCorrectInt++;
            }
            if (cellIndexPath.row + 1 < sectionModel.Passage.count) {
                [weakSelf.view layoutIfNeeded];
                [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }else if (cellIndexPath.row + 1 == sectionModel.Passage.count && cellIndexPath.section == self.sectionsModelArray.count - 1){
                float correctFloat = (float)_correctInt/(float)(_correctInt + _NoCorrectInt);
                PMAnswerViewController *vc = [[PMAnswerViewController alloc]init];
                vc.correct = [NSString stringWithFormat:@"%0.f",correctFloat * 100];
                vc.paperName = _testPaperModel.PaperFullName;
                vc.paperSection = _paperSection;
                vc.questionsArray = self.sectionsModelArray;
                vc.mode = self.mode;
                [self.navigationController pushViewController:vc animated:YES];
                  }
        };
        return cell;
    }
    QuestionsModel *questionsModel = modeSectionModel.Passage[indexPath.row];
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
    //cell tableview点击方法 isCorrect 是否正确 cellIndexPath collection cell 的indexPath
    cell.questionCellClick = ^(NSIndexPath *cellIndexPath, BOOL isCorrect) {
        NSIndexPath *nextIndexPath;
        if (cellIndexPath.row == modeSectionModel.Passage.count - 1) {
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
        if (cellIndexPath.row + 1 < modeSectionModel.Passage.count) {
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else if (cellIndexPath.row + 1 == modeSectionModel.Passage.count){
            float correctFloat = (float)_correctInt/(float)(_correctInt + _NoCorrectInt);
            PMAnswerViewController *vc = [[PMAnswerViewController alloc]init];
            vc.correct = [NSString stringWithFormat:@"%0.f",correctFloat * 100 ];
            vc.paperName = _testPaperModel.PaperFullName;
            vc.paperSection = _paperSection;
            vc.questionsArray = @[modeSectionModel];
            vc.mode = self.mode;
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
