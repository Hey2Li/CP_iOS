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
    self.title = @"考试成绩单";
    [self.view addSubview:self.myTableView];
    [self.myTableView reloadData];
    NSString *className = NSStringFromClass([AnswerHeadView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    _headView.correctStr = self.correct;
    _headView.paperDateLb.text = [self.paperName substringToIndex:7];
    _headView.paperNameLb.text = [self.paperName substringFromIndex:7];
    self.myTableView.tableHeaderView = _headView;
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 0;
    }else{
        return self.questionsArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsModel *model = self.questionsArray[indexPath.row];
    if (model.isSelected) {
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
    sectionLb.text = self.paperSection;
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
    cell.model = self.questionsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionsModel *model = self.questionsArray[indexPath.row];
    model.isSelected = !model.isSelected;
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
