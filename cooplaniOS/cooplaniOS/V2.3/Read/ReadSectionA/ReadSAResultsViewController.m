//
//  ReadSAResultsViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSAResultsViewController.h"
#import "AnswerTableViewCell.h"
#import "answerModel.h"
#import "ReadSectionAViewController.h"
#import "ReadTrainingViewController.h"
#import "ReadSAResultsHeaderView.h"

@interface ReadSAResultsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic ,strong) ReadSAResultsHeaderView *headView;
@end

@implementation ReadSAResultsViewController
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
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AnswerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerTableViewCell class])];
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
}
- (void)initWithNavi{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}
- (void)back{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ReadTrainingViewController class]]) {
            ReadTrainingViewController *vc = (ReadTrainingViewController *)controller;
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
- (void)initWithView{
    [self.view addSubview:self.myTableView];
    [self.dataSourceArray removeAllObjects];
    for (int i = 0; i < self.questionsArray.count; i ++) {
            answerModel *model = [[answerModel alloc]init];
            model.yourAnswer = @"1";
            model.correctAnswer = @"2";
            model.questionNum = [NSString stringWithFormat:@"Q%d",i];
            model.correct = self.correct ? self.correct : @"100%";
            model.answerDetail = @"【精析】事实细节题。新闻讲述了Addison卖柠檬水和画为生病的弟弟筹资的故事。新闻开门见山讲到，新墨西哥州9岁的女孩Addison已经为需要做心脏手术的弟弟筹集了500多美元。由此可知，女孩筹钱是为了给弟弟看病。";
            model.isCorrect = i%2 ? YES : NO;
            model.isSelected = NO;
            [self.dataSourceArray addObject:model];
        }
    [self.myTableView reloadData];
    NSString *className = NSStringFromClass([ReadSAResultsHeaderView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = @"50";
//    _headView.paperDateLb.text = [self.paperName substringToIndex:7];
//    _headView.paperNameLb.text = [self.paperName substringFromIndex:7];
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
 
}
- (void)testAgainBtnClick:(UIButton *)btn{
   
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questionsArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.questionsArray.count) {
        return 0;
    }else{
        SectionsModel *model = self.questionsArray[section];//刷题模式只有有一个section
        return model.Passages.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.questionsArray.count) {
        SectionsModel *model = self.questionsArray[indexPath.section];
        QuestionsModel *questionModel = model.Passages[indexPath.row];
        if (questionModel.isSelected) {
            return self.myTableView.rowHeight;
        }else{
            return 50;
        }
    }else{
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < self.questionsArray.count) {
        UIView *headerView = [[UIView alloc]init];
        SectionsModel *model = self.questionsArray[section];
        headerView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        UILabel *sectionLb = [UILabel new];
        sectionLb.text = model.SectionTitle;
        sectionLb.font = [UIFont boldSystemFontOfSize:14];
        [headerView addSubview:sectionLb];
        [sectionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(15);
            make.right.equalTo(headerView.mas_right).offset(10);
            make.top.equalTo(headerView);
            make.height.equalTo(@40);
        }];
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section < self.questionsArray.count) {
        SectionsModel *model = self.questionsArray[indexPath.section];
        QuestionsModel *questionModel = model.Passages[indexPath.row];
        cell.model = questionModel;
    }else{
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.questionsArray.count) {
        SectionsModel *model = self.questionsArray[indexPath.section];
        QuestionsModel *questionModel = model.Passages[indexPath.row];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
