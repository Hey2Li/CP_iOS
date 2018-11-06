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
@property (nonatomic, strong) ReadSAResultsHeaderView *headView;
@property (nonatomic, strong) NSDictionary *socreDict;
@end

@implementation ReadTestAnswerViewController

- (NSDictionary *)socreDict{
    if (!_socreDict) {
        _socreDict = @{@"35":@"248.5",@"34":@"238",@"33":@"227.5",@"32":@"220.5",@"31":@"213.5",@"30":@"206.5",@"29":@"199.5",@"28":@"192.5",@"27":@"185.5",@"26":@"178.5",@"25":@"175",@"24":@"171.5",@"23":@"168",@"22":@"164.5",@"21":@"161",@"20":@"157.5",@"19":@"154",@"18":@"154",@"17":@"150.5",@"16":@"147",@"15":@"178.5",@"14":@"140",@"13":@"136.5",@"12":@"133",@"11":@"129.5",@"10":@"126",@"9":@"126",@"8":@"122.5",@"7":@"119",@"6":@"119",@"5":@"115.5",@"4":@"112",@"3":@"108.5",@"2":@"105",@"1":@"105",@"0":@"101.5"};
    }
    return _socreDict;
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
    
    NSString *className = NSStringFromClass([ReadSAResultsHeaderView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = self.correct;
    _headView.userTimeLb.text = self.userTime;
    _headView.userTimeNameLb.text = @"剩余时间";
    //    _headView.paperDateLb.text = [self.paperName substringToIndex:7];
    _headView.paperNameLb.text = self.paperName;
    self.myTableView.tableHeaderView = _headView;
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 46 - 64, SCREEN_WIDTH, 46)];
    bottomView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:bottomView];
    UILabel *scoreLb = [UILabel new];
    NSString *socreStr = self.socreDict[[NSString stringWithFormat:@"%@", self.correctNum]];
    scoreLb.textColor = UIColorFromRGB(0x999999);
    scoreLb.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"得分:%@",socreStr]];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x2A2A2A)
                          range:NSMakeRange(3, socreStr.length)];
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont boldSystemFontOfSize:12]
                          range:NSMakeRange(3, socreStr.length)];
    scoreLb.attributedText = AttributedStr;
    [bottomView addSubview:scoreLb];
    [scoreLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    UIButton *testAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [testAgainBtn setTitle:@"返回" forState:UIControlStateNormal];
    [testAgainBtn setBackgroundColor:[UIColor whiteColor]];
    [testAgainBtn setTitleColor:UIColorFromRGB(0xFFCD43) forState:UIControlStateNormal];
    [bottomView addSubview:testAgainBtn];
    [testAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-17);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.equalTo(@26);
        make.width.equalTo(@102);
    }];
    [testAgainBtn.layer setBorderColor:DRGBCOLOR.CGColor];
    [testAgainBtn.layer setCornerRadius:10];
    [testAgainBtn.layer setBorderWidth:1];
    [testAgainBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *lineLb = [UILabel new];
//    [bottomView addSubview:lineLb];
//    [bottomView bringSubviewToFront:lineLb];
//    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bottomView.mas_centerX);
//        make.centerY.equalTo(bottomView.mas_centerY);
//        make.height.equalTo(@24);
//        make.width.equalTo(@2);
//    }];
//    [lineLb setBackgroundColor:UIColorFromRGB(0xEEEEEE)];
    
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
