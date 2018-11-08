//
//  ReadTestViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadTestViewController.h"
#import "ReadRefreshGifHeader.h"
#import "ReadRfreshBackGifFooter.h"
#import "ReadSATableViewCell.h"
#import "SAQuestionCollectionViewCell.h"
#import "SAOptionsCollectionViewCell.h"
#import "ReadSAModel.h"

#import "ReadSBTableViewCell.h"
#import "ReadSBQuestionCardCCell.h"
#import "ReadSBModel.h"

#import "ReadSCQuestionCardCCell.h"
#import "ReadSCModel.h"

#import "ReadTestAnswerViewController.h"


@interface ReadTestViewController ()
<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL questionCardIsOpen;
@property (nonatomic, assign) BOOL isFirstLoadSectionA;
@property (nonatomic, strong) NSTimer *myTimer;
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) UILabel *pageLb;

@property (nonatomic, strong) ReadSAModel *readModel;
@property (nonatomic, strong) ReadSBModel *readSbModel;
@property (nonatomic, strong) ReadSCModel *readScModel;
@property (nonatomic, strong) ReadSCModel *readScModel2;

@property (nonatomic, assign) NSInteger userIndex;//用户点击的题目
@property (nonatomic, assign) int correctInt;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL isFinish;
@end

@implementation ReadTestViewController
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
        self.flowLayout = flowlayout;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480]) collectionViewLayout:self.flowLayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAQuestionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAOptionsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class])];
        
        [_collectionView registerClass:[ReadSBQuestionCardCCell class] forCellWithReuseIdentifier:NSStringFromClass([ReadSBQuestionCardCCell class])];

        [_collectionView registerClass:[ReadSCQuestionCardCCell class] forCellWithReuseIdentifier:NSStringFromClass([ReadSCQuestionCardCCell class])];
        
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
    self.title = @"模拟考场";
    [self initWithView];
    [self initWithNavi];
    [self loadData];
    BOOL isFirstTestPaper = [USERDEFAULTS boolForKey:kIsFisrtTestPaper];
    if (!isFirstTestPaper) {
        [self loadFirstReadAlert];
        [USERDEFAULTS setBool:YES forKey:kIsFisrtTestPaper];
    }
    _seconds = 2400;
    _correctInt = 0;
    self.ReadSetionEnum = ReadSectionA;
}
#pragma mark 加载试卷数据
- (void)loadData{
    [LTHttpManager searchReadingTestPapersWithId:self.testPaperNumber Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *dataArray = data[@"responseData"];
            if (dataArray.count) {
                NSDictionary *dDic = dataArray[0];
                NSDictionary *eDic = dataArray[1];
                NSDictionary *fDic = dataArray[2];
                NSDictionary *gDic = dataArray[3];
                [LTHttpManager downloadURL:eDic[@"testPaperUrl"] progress:^(NSProgress *downloadProgress) {
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
                        if (data == nil) {
                            dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                        }else{
                            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        }
                        self.readModel = [ReadSAModel mj_objectWithKeyValues:dict];
                        self.readModel.testPaperName = eDic[@"testName"];
                        [self.tableView reloadData];
                        [self.collectionView reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                //
                [LTHttpManager downloadURL:dDic[@"testPaperUrl"] progress:^(NSProgress *downloadProgress) {
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
                        if (data == nil) {
                            dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                        }else{
                            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        }
                        self.readSbModel = [ReadSBModel mj_objectWithKeyValues:dict];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                //
                [LTHttpManager downloadURL:fDic[@"testPaperUrl"] progress:^(NSProgress *downloadProgress) {
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
                        if (data == nil) {
                             dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                        }else{
                            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        }
                        self.readScModel = [ReadSCModel mj_objectWithKeyValues:dict];
                    }
                } failure:^(NSError *error) {
                    
                }];
                
                //
                [LTHttpManager downloadURL:gDic[@"testPaperUrl"] progress:^(NSProgress *downloadProgress) {
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
                        if (data == nil) {
                            dict = [NSJSONSerialization JSONObjectWithData:data2 options:NSJSONReadingAllowFragments error:&error];
                        }else{
                            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                        }
                        self.readScModel2 = [ReadSCModel mj_objectWithKeyValues:dict];
                    }
                } failure:^(NSError *error) {
                    
                }];
            }
        }
    }];
}
- (void)initWithNavi{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}
#pragma mark 返回
- (void)back{
    LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"确定退出" sureBtn:@"确定" cancleBtn:@"取消"];
    [alertView show];
    alertView.resultIndex = ^(NSInteger index) {
        [self.navigationController popViewControllerAnimated:YES];
    };
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
    WeakSelf
    ReadRefreshGifHeader *header = [ReadRefreshGifHeader headerWithRefreshingBlock:^{
        if (self.ReadSetionEnum > 0) {
            self.ReadSetionEnum --;
            if (self.ReadSetionEnum == ReadSectionA) {
                self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                [self.collectionView setFrame:CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480])];
                [self.collectionView setBackgroundColor:[UIColor whiteColor]];
            }else{
                self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480])];
                [self.collectionView setBackgroundColor:[UIColor clearColor]];
            }
            if (self.ReadSetionEnum == ReadSectionA) {
                self.pageLb.text = @"1/1";
            }else if (self.ReadSetionEnum == ReadSectionB) {
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readSbModel.Options.count];
            }else if (self.ReadSetionEnum == ReadSectionC) {
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readScModel.Questions.count];
            }else if (self.ReadSetionEnum == ReadSectionCPassageTwo){
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readScModel2.Questions.count];
            }else{
                self.pageLb.text = @"1/1";
            }
            [self.tableView reloadData];
            [self.collectionView reloadData];
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else{
            SVProgressShowStuteText(@"没有更多了", NO);
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_header = header;
    
    ReadRfreshBackGifFooter *footer = [ReadRfreshBackGifFooter footerWithRefreshingBlock:^{
        if (self.ReadSetionEnum < 3) {
            self.ReadSetionEnum ++;
            if (self.ReadSetionEnum == ReadSectionA) {
                self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                [self.collectionView setFrame:CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480])];
                [self.collectionView setBackgroundColor:[UIColor whiteColor]];
            }else{
                self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480])];
                [self.collectionView setBackgroundColor:[UIColor clearColor]];
            }
            if (self.ReadSetionEnum == ReadSectionA) {
                self.pageLb.text = @"1/1";
            }else if (self.ReadSetionEnum == ReadSectionB) {
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readSbModel.Options.count];
            }else if (self.ReadSetionEnum == ReadSectionC) {
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readScModel.Questions.count];
            }else if (self.ReadSetionEnum == ReadSectionCPassageTwo){
                self.pageLb.text = [NSString stringWithFormat:@"1/%lu", (unsigned long)self.readScModel2.Questions.count];
            }else{
                self.pageLb.text = @"1/1";
            }
            [self.tableView reloadData];
            [self.collectionView reloadData];
            [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }else{
             SVProgressShowStuteText(@"没有更多了", NO);
        }
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    self.tableView.mj_footer = footer;

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
    loadTimeLb.text = @"40:00";
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
        make.width.equalTo(@50);
        make.centerY.equalTo(bottomView.mas_centerY);
    }];
    pageLb.textColor = UIColorFromRGB(0x999999);
    pageLb.font = [UIFont systemFontOfSize:12];
    pageLb.textAlignment = NSTextAlignmentRight;
    self.pageLb = pageLb;
    self.pageLb.text = @"1/1";

    [bottomView.layer setShadowColor:[UIColor blackColor].CGColor];
    [bottomView.layer setShadowOffset:CGSizeMake(0, -2)];
    [bottomView.layer setShadowOpacity:0.2];
    [bottomView.layer setMasksToBounds:NO];
    
    [takePaperBtn addTarget:self action:@selector(takePaperClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)loadFirstReadAlert{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *maskView = [[UIView alloc]initWithFrame:keyWindow.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [keyWindow addSubview:maskView];
    
    UIView *alertView = [[UIView alloc]init];
    alertView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskView.mas_left).offset(30);
        make.right.equalTo(maskView.mas_right).offset(-30);
        make.height.equalTo(@(300));
        make.centerY.equalTo(maskView.mas_centerY);
    }];
    [alertView.layer setCornerRadius:10];
    [alertView.layer setMasksToBounds:YES];
    
    UIImageView *topImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"加载题目演示"]];
    [alertView addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView);
        make.left.equalTo(alertView);
        make.right.equalTo(alertView);
        make.bottom.equalTo(alertView.mas_bottom).offset(-150);
    }];
    
    UILabel *titleLb = [UILabel new];
    [alertView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImg.mas_bottom).offset(10);
        make.height.equalTo(@30);
        make.left.equalTo(alertView);
        make.right.equalTo(alertView);
    }];
    titleLb.text = @"上下滑动切换阅读文章";
    titleLb.font = [UIFont boldSystemFontOfSize:16];
    titleLb.textColor = [UIColor blackColor];
    titleLb.textAlignment = NSTextAlignmentCenter;
    
    UILabel *subTitleLb = [UILabel new];
    [alertView addSubview:subTitleLb];
    [subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLb.mas_bottom);
        make.height.equalTo(@30);
        make.left.equalTo(alertView);
        make.right.equalTo(alertView);
    }];
    subTitleLb.text = @"滑动到底部切换下一篇文章";
    subTitleLb.font = [UIFont systemFontOfSize:14];
    subTitleLb.textColor = [UIColor blackColor];
    subTitleLb.textAlignment = NSTextAlignmentCenter;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [sureBtn setTitleColor:DRGBCOLOR forState:UIControlStateNormal];
    [alertView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subTitleLb.mas_bottom);
        make.bottom.equalTo(alertView.mas_bottom);
        make.left.equalTo(alertView);
        make.right.equalTo(alertView);
    }];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)sureBtnClick:(UIButton *)btn{
    [btn.superview.superview  removeFromSuperview];
}
#pragma mark 交卷
- (void)takePaperClick:(UIButton *)btn{
    if (_isFinish) {
        LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定交卷吗？" sureBtn:@"交卷" cancleBtn:@"再检查下" ];
        finishView.resultIndex = ^(NSInteger index) {
            [self loadPaperData];
        };
        [finishView show];
    }else{
        LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"还有题目没做完，确定交卷吗?" sureBtn:@"交卷" cancleBtn:@"继续做" ];
        finishView.resultIndex = ^(NSInteger index) {
            [self loadPaperData];
        };
        [finishView show];
    }
}
- (void)loadPaperData{
    for (ReadSAAnswerModel *model in self.readModel.Answer) {
        if (model.isCorrect) {
            _correctInt++;
        }
    }
    for (ReadSBOptionsModel *quModel in self.readSbModel.Options) {
        if (quModel.isCorrect) {
            _correctInt++;
        }
    }
    for (QuestionsItem *quModel in self.readScModel.Questions) {
        if (quModel.isCorrect) {
            _correctInt++;
        }
    }
    for (QuestionsItem *quModel in self.readScModel2.Questions) {
        if (quModel.isCorrect) {
            _correctInt++;
        }
    }
    NSLog(@"%d", _correctInt);
    ReadTestAnswerViewController *vc = [ReadTestAnswerViewController new];
    vc.userTime = self.timeLb.text;
    vc.questionsArray = @[self.readModel.Answer,self.readSbModel.Options,self.readScModel, self.readScModel2];
    vc.rsaModel = self.readModel;
    vc.rsbModel = self.readSbModel;
    vc.rscModel = self.readScModel;
    vc.rscModel2 = self.readScModel2;
    vc.testPaperNumber = self.testPaperNumber;
    vc.paperName = self.readModel.testPaperName;
    vc.correctNum = [NSString stringWithFormat:@"%d", _correctInt];
    float correctFloat = (float)_correctInt/(float)(self.readScModel.Questions.count + self.readSbModel.Options.count + self.readModel.Answer.count + self.readScModel2.Questions.count)* 100;
    vc.correct = [NSString stringWithFormat:@"%.0f",correctFloat];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)time{
    if (_seconds > 0) {
        self.timeLb.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%ld", (long)_seconds--]];
    }else{
        self.timeLb.text = [self getMMSSFromSS:[NSString stringWithFormat:@"%d", 0]];
    }
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
        CGPoint center = CGPointMake(self.view.center.x, SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2 - 1);
        self.collectionView.center = center;
        _questionCardIsOpen = YES;
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
    if (self.ReadSetionEnum == ReadSectionA) {
        return 1;
    }else if (self.ReadSetionEnum == ReadSectionB){
        return self.readSbModel.Passage.count;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ReadSetionEnum == ReadSectionA) {
        if (!self.readModel.Passage) return 0;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 35, MAXFLOAT);
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.readModel.Passage];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 120;
    }else if (self.ReadSetionEnum == ReadSectionB){
        ReadSBPassageModel *passageModel = self.readSbModel.Passage[indexPath.row];
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        maxSize.width = maxSize.width - 25;
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@  %@", passageModel.Alphabet, passageModel.Text]];
        [textStr yy_setFont:[UIFont systemFontOfSize:14] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 20;
    }else if (self.ReadSetionEnum == ReadSectionC){
        if (!self.readScModel.Passage) return 0;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.readScModel.Passage];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 20;
    }else{
        if (!self.readScModel2.Passage) return 0;
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.readScModel2.Passage];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        textStr.yy_lineSpacing = 8;
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        CGFloat introHeight = layout.textBoundingSize.height;
        return introHeight + 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ReadSetionEnum == ReadSectionA) {
        ReadSATableViewCell *cell = [[ReadSATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.readModel.Passage) {
            if (_isFirstLoadSectionA) {
                cell.secondPassage = self.readModel.Passage;
            }else{
                cell.passage = self.readModel.Passage;
                _isFirstLoadSectionA = YES;
            }
        }
        cell.selectionStyle = NO;
        return cell;
    }else if (self.ReadSetionEnum == ReadSectionB){
        ReadSBTableViewCell *cell = [[ReadSBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = NO;
        cell.isTest = YES;
        ReadSBPassageModel *passageModel = self.readSbModel.Passage[indexPath.row];
        cell.passage = [NSString stringWithFormat:@"%@  %@", passageModel.Alphabet, passageModel.Text];
        return cell;
    }else if (self.ReadSetionEnum == ReadSectionC){
        ReadSBTableViewCell *cell = [[ReadSBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.isTest = YES;
        if (self.readScModel.Passage) {
            cell.passage = self.readScModel.Passage;
        }
        cell.selectionStyle = NO;
        return cell;
    }else{
        ReadSBTableViewCell *cell = [[ReadSBTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.isTest = YES;
        if (self.readScModel2.Passage) {
            cell.passage = self.readScModel2.Passage;
        }
        cell.selectionStyle = NO;
        return cell;
    }
}
#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (self.ReadSetionEnum == ReadSectionA) {
        return 3;
    }else{
        return 1;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.ReadSetionEnum == ReadSectionA) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return 1;
        }else{
            return self.readModel.Options.count;
        }
    }else if (self.ReadSetionEnum == ReadSectionB){
        return self.readSbModel.Options.count;
    }else if (self.ReadSetionEnum == ReadSectionC){
        return self.readScModel.Questions.count;
    }else{
        return self.readScModel2.Questions.count;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ReadSetionEnum == ReadSectionA) {
        if (indexPath.section == 1) {
            return CGSizeMake(self.collectionView.width, 45);
        }else if (indexPath.section == 0){
            return CGSizeMake(self.collectionView.width, 35);
        }else{
            if (UI_IS_IPHONE5) {
                return CGSizeMake((self.collectionView.width - 10)/2, 39);
            }else{
                return CGSizeMake((self.collectionView.width - 10)/2, 44);
            }
        }
    }else{
        return CGSizeMake(self.collectionView.width, [Tool layoutForAlliPhoneHeight:480]);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.ReadSetionEnum == ReadSectionA) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }else{
        return UIEdgeInsetsZero;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ReadSetionEnum == ReadSectionA) {
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
            cell.questionLb.text = [NSString stringWithFormat:@"%@", self.readModel.Question ?self.readModel.Question : @""];
            return cell;
        }else{
            SAOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class]) forIndexPath:indexPath];
            if (indexPath.row < self.readModel.Options.count) {
                cell.model = self.readModel.Options[indexPath.row];
            }
            return cell;
        }
    }else if (self.ReadSetionEnum == ReadSectionB){
        ReadSBQuestionCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSBQuestionCardCCell class]) forIndexPath:indexPath];
        cell.superIndexPath = indexPath;
        cell.optionsModel = self.readSbModel.Options[indexPath.row];
        cell.questionsArray = self.readSbModel.Passage;
        cell.question = self.readSbModel.Question;
        cell.collectionScroll = ^(NSIndexPath * indexPaths) {
            if (indexPaths.row + 1 < self.readSbModel.Options.count) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:indexPaths.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }else{
                LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定进入下一个Section？" sureBtn:@"确定" cancleBtn:@"再等等" ];
                finishView.resultIndex = ^(NSInteger index) {
                    //SectionB答完题
                    if (self.ReadSetionEnum < 2) {
                        self.ReadSetionEnum ++;
                    }
                    if (self.ReadSetionEnum == ReadSectionA) {
                        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
                        [self.collectionView setFrame:CGRectMake(16, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH - 32, [Tool layoutForAlliPhoneHeight:480])];
                        [self.collectionView setBackgroundColor:[UIColor whiteColor]];
                    }else{
                        self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT - 130 - SafeAreaTopHeight, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:480])];
                        [self.collectionView setBackgroundColor:[UIColor clearColor]];
                    }
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                };
                [finishView show];
            }
        };
        return cell;
    }else if (self.ReadSetionEnum == ReadSectionC){
        ReadSCQuestionCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSCQuestionCardCCell class]) forIndexPath:indexPath];
        cell.model = self.readScModel.Questions[indexPath.row];
        cell.passageNoLb.text = self.readScModel.Question;
        cell.superIndexPath = indexPath;
        cell.cellClick = ^(NSIndexPath * _Nonnull nextIndexPath) {
            if (nextIndexPath.row + 1 < self.readScModel.Questions.count) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }else{
                LTAlertView *finishView = [[LTAlertView alloc]initWithTitle:@"确定进入下一个Passage？" sureBtn:@"确定" cancleBtn:@"再等等" ];
                finishView.resultIndex = ^(NSInteger index) {
                    if (self.ReadSetionEnum < 3) {
                        self.ReadSetionEnum ++;
                    }
                    [self.tableView reloadData];
                    [self.collectionView reloadData];
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
                };
                [finishView show];
            }
        };
        return cell;
    }else{
        ReadSCQuestionCardCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([ReadSCQuestionCardCCell class]) forIndexPath:indexPath];
        cell.model = self.readScModel2.Questions[indexPath.row];
        cell.passageNoLb.text = self.readScModel2.Question;
        cell.superIndexPath = indexPath;
        cell.cellClick = ^(NSIndexPath * _Nonnull nextIndexPath) {
            if (nextIndexPath.row + 1 < self.readScModel2.Questions.count) {
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndexPath.row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
            }else{
                _isFinish = YES;
                //SectionC答完题 交卷
                [self takePaperClick:nil];
            }
        };
        return cell;
    }
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.ReadSetionEnum == ReadSectionA) {
        if (indexPath.section == 2) {
            if (_questionCardIsOpen) {
                ReadSAOptionsModel *model = self.readModel.Options[indexPath.row];
                [[NSNotificationCenter defaultCenter]postNotificationName:kClickReadCard object:nil userInfo:@{@"options":[NSString stringWithFormat:@"%@", model.Text], @"index":@(indexPath.row)}];
                ReadSAAnswerModel *questionModel = self.readModel.Answer[_userIndex ? _userIndex : 0];
                if ([model.Alphabet isEqualToString:questionModel.Alphabet]) {
                    questionModel.isCorrect = YES;
                }else{
                    questionModel.isCorrect = NO;
                }
                questionModel.yourAnswer = model.Alphabet;
                for (ReadSAOptionsModel *otherModel in self.readModel.Options) {
                    otherModel.isSelectedOption = NO;
                }
                for (ReadSAAnswerModel *otherOptions in self.readModel.Answer) {
                    for (ReadSAOptionsModel *otherModel in self.readModel.Options) {
                        if ([otherOptions.yourAnswer isEqualToString:otherModel.Alphabet]) {
                            otherModel.isSelectedOption = YES;
                        }
                    }
                }
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
    }else if (self.ReadSetionEnum == ReadSectionB){
        
    }else{
        
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.collectionView) {
        if (self.ReadSetionEnum == ReadSectionA) {
            self.pageLb.text = @"1/1";
        }else if (self.ReadSetionEnum == ReadSectionB) {
            self.pageLb.text = [NSString stringWithFormat:@"%.0f/%lu", self.collectionView.contentOffset.x/self.collectionView.width + 1, (unsigned long)self.readSbModel.Options.count];
        }else if (self.ReadSetionEnum == ReadSectionC) {
             self.pageLb.text = [NSString stringWithFormat:@"%.0f/%lu", self.collectionView.contentOffset.x/self.collectionView.width + 1, (unsigned long)self.readScModel.Questions.count];
        }else if (self.ReadSetionEnum == ReadSectionCPassageTwo){
            self.pageLb.text = [NSString stringWithFormat:@"%.0f/%lu", self.collectionView.contentOffset.x/self.collectionView.width + 1, (unsigned long)self.readScModel2.Questions.count];
        }
        else{
            self.pageLb.text = @"1/1";
        }
    }
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
