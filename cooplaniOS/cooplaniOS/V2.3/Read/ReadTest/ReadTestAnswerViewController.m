//
//  ReadTestAnswerViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/19.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadTestAnswerViewController.h"
#import "ReadTrainingViewController.h"
#import "ReadSAResultsHeaderView.h"
#import "AnswerTableViewCell.h"
#import "ReadTestViewController.h"
#import "ReadTestListViewController.h"

@interface ReadTestAnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic ,strong) ReadSAResultsHeaderView *headView;
@end

@implementation ReadTestAnswerViewController

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
    
    NSString *className = NSStringFromClass([ReadSAResultsHeaderView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = self.correct;
    _headView.userTimeLb.text = self.userTime;
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
    ReadTestListViewController *vc = [[ReadTestListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)testAgainBtnClick:(UIButton *)btn{
    ReadTestViewController *vc = [[ReadTestViewController alloc]init];
    vc.testPaperNumber = self.testPaperNumber;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.rsaModel.Answer.count;
    }else if (section == 1){
        return self.rsbModel.Options.count;
    }else if (section == 2){
        return self.rscModel.Questions.count;
    }else{
        return self.rscModel2.Questions.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ReadSAAnswerModel *model = self.rsaModel.Answer[indexPath.row];
        if (model.isSelected) {
            return self.myTableView.rowHeight;
        }else{
            return 50;
        }
    }else if (indexPath.section == 1){
        ReadSBOptionsModel *model = self.rsbModel.Options[indexPath.row];
        if (model.isSelected) {
            return self.myTableView.rowHeight;
        }else{
            return 50;
        }
    }else if (indexPath.section == 2){
        QuestionsItem *model = self.rscModel.Questions[indexPath.row];
        if (model.isSelected) {
            return self.myTableView.rowHeight;
        }else{
            return 50;
        }
    }else{
        QuestionsItem *model = self.rscModel2.Questions[indexPath.row];
        if (model.isSelected) {
            return self.myTableView.rowHeight;
        }else{
            return 50;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section < self.questionsArray.count) {
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = UIColorFromRGB(0xf7f7f7);
        UILabel *sectionLb = [UILabel new];
        if (section == 0) {
            sectionLb.text = @"Section A";
        }else if (section == 1){
            sectionLb.text = @"Section B";
        }else if (section == 2){
            sectionLb.text = @"Section C Passage One";
        }else{
            sectionLb.text = @"Section C Passage Two";
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
    }else{
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor whiteColor];
        return headerView;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        ReadSAAnswerModel *model = self.rsaModel.Answer[indexPath.row];
        cell.questionNameLb.text = [NSString stringWithFormat:@"Q%ld",26 + indexPath.row];
        cell.readSAAnswerModel = model;
    }else if (indexPath.section == 1){
        ReadSBOptionsModel *model = self.rsbModel.Options[indexPath.row];
        cell.readSBOptionsModel = model;
    }else if (indexPath.section == 2){
        QuestionsItem *model = self.rscModel.Questions[indexPath.row];
        cell.readSCAnswerModel = model;
    }else{
        QuestionsItem *model = self.rscModel2.Questions[indexPath.row];
        cell.readSCAnswerModel = model;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.questionsArray.count) {
        if (indexPath.section == 0) {
            ReadSAAnswerModel *readSAAnswerModel = self.rsaModel.Answer[indexPath.row];
            readSAAnswerModel.isSelected = !readSAAnswerModel.isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }else if (indexPath.section == 1){
            ReadSBOptionsModel *readSBOptionsModel = self.rsbModel.Options[indexPath.row];
            readSBOptionsModel.isSelected = !readSBOptionsModel.isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }else if (indexPath.section == 2){
            QuestionsItem *readSCQuestionModel = self.rscModel.Questions[indexPath.row];
            readSCQuestionModel.isSelected = !readSCQuestionModel.isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }else{
            QuestionsItem *readSCQuestionModel = self.rscModel2.Questions[indexPath.row];
            readSCQuestionModel.isSelected = !readSCQuestionModel.isSelected;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
        }
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
