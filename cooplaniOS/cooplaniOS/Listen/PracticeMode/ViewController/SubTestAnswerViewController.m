//
//  SubTestAnswerViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SubTestAnswerViewController.h"
#import "AnswerTableViewCell.h"
#import "answerModel.h"
#import "AnswerHeadView.h"
#import "PaperDetailViewController.h"
#import "PracticeModeViewController.h"
#import "ListenTrainingViewController.h"
#import "SubTestPMViewController.h"

@interface SubTestAnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic ,strong) AnswerHeadView *headView;

@property (nonatomic, strong) DownloadFileModel *downloadModel;
@property (nonatomic, copy) NSString *downloadVoiceUrl;
@property (nonatomic, copy) NSString *downloadlrcUrl;
@property (nonatomic, copy) NSString *downloadJsonUrl;
@end

@implementation SubTestAnswerViewController

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 46) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"AnswerTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerTableViewCell class])];
        _myTableView.estimatedRowHeight = 60;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
        _myTableView.separatorStyle = NO;
        
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"成绩单";
    [self initWithView];
    [self initWithNavi];
    self.downloadModel = [[DownloadFileModel alloc]init];
}
- (void)initWithNavi{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}
- (void)back{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ListenTrainingViewController class]]) {
            ListenTrainingViewController *revise = (ListenTrainingViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}
- (void)initWithView{
    [self.view addSubview:self.myTableView];
    [self.dataSourceArray removeAllObjects];
    [self.myTableView reloadData];
    NSString *className = NSStringFromClass([AnswerHeadView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = self.correct;
    _headView.paperDateLb.text = [self.paperName substringToIndex:7];
    _headView.paperNameLb.text = [self.paperName substringFromIndex:7];
    self.myTableView.tableHeaderView = _headView;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 46 - 64, SCREEN_WIDTH, 46)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [continueBtn setTitle:@"继续" forState:UIControlStateNormal];
    [continueBtn setBackgroundColor:[UIColor whiteColor]];
    [continueBtn setTitleColor:UIColorFromRGB(0xFFCD43) forState:UIControlStateNormal];
    [bottomView addSubview:continueBtn];
    [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    [continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *testAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testAgainBtn setTitle:@"再次练习" forState:UIControlStateNormal];
    [testAgainBtn setBackgroundColor:[UIColor whiteColor]];
    [testAgainBtn setTitleColor:UIColorFromRGB(0xFFCD43) forState:UIControlStateNormal];
    [bottomView addSubview:testAgainBtn];
    [testAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    [testAgainBtn addTarget:self action:@selector(testAgainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lineLb = [UILabel new];
    [bottomView addSubview:lineLb];
    [bottomView bringSubviewToFront:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@2);
    }];
    [lineLb setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
    
    [bottomView.layer setShadowOpacity:0.4];
    [bottomView.layer setShadowColor:[UIColor blackColor].CGColor];
    [bottomView.layer setShadowOffset:CGSizeMake(0, 3)];
}
#pragma mark 继续
- (void)continueBtnClick:(UIButton *)btn{
    kPreventRepeatClickTime(3);
    if (!self.sectionType) {
        return;
    }
    [MobClick event:@"practicetranscriptpage_continue"];
    [LTHttpManager getOneNewTestWithUserId:IS_USER_ID Type:@"1" Testpaper_kind:@"1T" Testpaper_type:self.sectionType Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.downloadVoiceUrl = data[@"responseData"][@"voiceUrl"];
            self.downloadlrcUrl = data[@"responseData"][@"lic"];
            self.downloadJsonUrl = data[@"responseData"][@"testPaperUrl"];
            self.downloadModel.testPaperId = data[@"responseData"][@"id"];
            self.downloadModel.name = data[@"responseData"][@"name"];
            self.downloadModel.info = data[@"responseData"][@"info"];
            self.downloadModel.number = data[@"responseData"][@"number"];
            DownloadFileModel *model = [DownloadFileModel jr_findByPrimaryKey:self.downloadModel.testPaperId];
            if (model.paperVoiceName == nil || [model.paperVoiceName isEqualToString:@""]) {
                self.downloadModel.paperVoiceName = self.downloadVoiceUrl;
                J_Update(self.downloadModel).Columns(@[@"paperVoiceName"]).updateResult;
            }
            [USERDEFAULTS setObject:self.downloadModel.testPaperId forKey:@"testPaperId"];
            [LTHttpManager downloadURL:self.downloadJsonUrl progress:^(NSProgress *downloadProgress) {
                
            } destination:^(NSURL *targetPath) {
                NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                NSString *fileName = [url lastPathComponent];
                self.downloadModel.paperJsonName = fileName;
                J_Update(self.downloadModel).Columns(@[@"paperJsonName"]).updateResult;
                [LTHttpManager downloadURL:self.downloadlrcUrl progress:^(NSProgress *downloadProgress) {
                    
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    self.downloadModel.paperLrcName = fileName;
                    J_Update(self.downloadModel).Columns(@[@"paperLrcName"]).updateResult;
                    SubTestPMViewController *vc = [[SubTestPMViewController alloc]init];
                    vc.sectionType = self.sectionType;
                    if ([self.sectionType isEqualToString: @"4-A"]) {
                        vc.title = @"短篇新闻";
                    }else if ([self.sectionType isEqualToString: @"4-B"]){
                        vc.title = @"长对话";
                    }else{
                        vc.title = @"听力篇章";
                    }
                    vc.testPaperId = self.downloadModel.testPaperId;
                    //                        vc.subTestPaper = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                } failure:^(NSError *error) {
                    
                }];
            } failure:^(NSError *error) {
                
            }];
            
            J_Insert(self.downloadModel).updateResult;
            
            NSLog(@"%@",self.downloadModel);
        }
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoadListenTraining object:nil];
}
- (void)testAgainBtnClick:(UIButton *)btn{
    kPreventRepeatClickTime(3);
    [[NSNotificationCenter defaultCenter]postNotificationName:kLoadListenTraining object:nil];
    [MobClick event:@"practicetranscriptpage_retry"];
    SubTestPMViewController *vc = [[SubTestPMViewController alloc]init];
    vc.testPaperId = self.testPaperId;
    if ([self.sectionType isEqualToString: @"4-A"]) {
        vc.title = @"短篇新闻";
    }else if ([self.sectionType isEqualToString: @"4-B"]){
        vc.title = @"长对话";
    }else{
        vc.title = @"听力篇章";
    }
    vc.sectionType = self.sectionType;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsModel *questionModel = self.questionsArray[indexPath.row];
    if (questionModel.isSelected) {
        return self.myTableView.rowHeight;
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UILabel *sectionLb = [UILabel new];
    if ([self.sectionType isEqualToString: @"4-A"]) {
        sectionLb.text = @"Section A";
    }else if ([self.sectionType isEqualToString: @"4-B"]){
        sectionLb.text = @"Section B";
    }else{
        sectionLb.text = @"Section C";
    }
    sectionLb.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:sectionLb];
    [sectionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(15);
        make.right.equalTo(headerView.mas_right).offset(10);
        make.top.equalTo(headerView);
        make.height.equalTo(@40);
    }];
    return headerView;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    QuestionsModel *questionModel = self.questionsArray[indexPath.row];
    cell.model = questionModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.questionsArray.count) {
        [MobClick endEvent:@"practicetranscriptpage_analysis"];
        QuestionsModel *questionModel = self.questionsArray[indexPath.row];
        questionModel.isSelected = !questionModel.isSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:nil];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
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
