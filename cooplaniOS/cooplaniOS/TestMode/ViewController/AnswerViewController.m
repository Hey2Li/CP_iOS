//
//  AnswerViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerTableViewCell.h"
#import "answerModel.h"
#import "AnswerHeadView.h"
#import "PaperDetailViewController.h"

@interface AnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;
@property (nonatomic ,strong) AnswerHeadView *headView;
@end

@implementation AnswerViewController

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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
    self.title = @"成绩单";
    [self.view addSubview:self.myTableView];
    [self.myTableView reloadData];
    NSString *className = NSStringFromClass([AnswerHeadView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = self.correct;
    _headView.paperDateLb.text = [self.paperName substringToIndex:7];
    _headView.paperNameLb.text = [self.paperName substringFromIndex:7];
    self.myTableView.tableHeaderView = _headView;
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
        if ([controller isKindOfClass:[PaperDetailViewController class]]) {
            PaperDetailViewController *revise = (PaperDetailViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.questionsArray.count + 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.questionsArray.count) {
        return 0;
    }else{
        SectionsModel *model = self.questionsArray[section];
        return model.Passage.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionsModel *model = self.questionsArray[indexPath.section];
    QuestionsModel *questionModel = model.Passage[indexPath.row];
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
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SectionsModel *model = self.questionsArray[indexPath.section];
    QuestionsModel *questionModel = model.Passage[indexPath.row];
    cell.model = questionModel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SectionsModel *model = self.questionsArray[indexPath.section];
    QuestionsModel *questionModel = model.Passage[indexPath.row];
    questionModel.isSelected = !questionModel.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 40;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
