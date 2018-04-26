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
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic ,strong) AnswerHeadView *headView;
@end

@implementation AnswerViewController

- (NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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
    [self.view addSubview:self.myTableView];
    [self.dataSourceArray removeAllObjects];
    for (int i = 0; i < 3; i ++) {
        answerModel *model = [[answerModel alloc]init];
        model.yourAnswer = @"1";
        model.correctAnswer = @"2";
        model.questionNum = [NSString stringWithFormat:@"Q%d",i];
        model.correct = @"70%";
        model.answerDetail = @"【精析】事实细节题。新闻讲述了Addison卖柠檬水和画为生病的弟弟筹资的故事。新闻开门见山讲到，新墨西哥州9岁的女孩Addison已经为需要做心脏手术的弟弟筹集了500多美元。由此可知，女孩筹钱是为了给弟弟看病。";
        model.isCorrect = NO;
        model.isSelected = NO;
        [self.dataSourceArray addObject:model];
    }
    [self.myTableView reloadData];
    NSString *className = NSStringFromClass([AnswerHeadView class]);
    _headView = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
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
        return self.dataSourceArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    answerModel *model = self.dataSourceArray[indexPath.row];
//    return model.cellHeight;
    if (self.isOpen && self.selectIndexPath == indexPath) {
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
    sectionLb.text = @"Section A News Report One";
    sectionLb.font = [UIFont boldSystemFontOfSize:14];
    [headerView addSubview:sectionLb];
    [sectionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.right.equalTo(headerView.mas_right).offset(10);
        make.top.equalTo(headerView);
        make.height.equalTo(@40);
    }];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    answerModel *model = self.dataSourceArray[indexPath.row];
    if (!self.selectIndexPath) {
        self.isOpen = YES;
        model.isSelected = YES;
        self.selectIndexPath = indexPath;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        if (self.isOpen) {
            if (self.selectIndexPath == indexPath) {
                self.isOpen = NO;
                model.isSelected = NO;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.selectIndexPath = nil;
            } else {
                self.isOpen = NO;
                answerModel *models = self.dataSourceArray[self.selectIndexPath.row];
                models.isSelected = NO;
                [tableView reloadRowsAtIndexPaths:@[self.selectIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.selectIndexPath = nil;
            }
        }
    }
//    model.isSelected = !model.isSelected;
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:nil];
    NSLog(@"indexPath:%ld, selectedIndexPath:%ld, lastSelectedIndexPath:%ld",(long)indexPath.row, self.selectIndexPath.row, self.lastSelectedIndexPath.row);
}
//设置table view 为可编辑的
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}
//#pragma mark - 返回按钮／处理按钮的点击事件
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //添加一个更多按钮
//    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"加入错题本" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        NSLog(@"点击了更多");
//        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
//
//    }];
//
//    return @[moreRowAction];
//}
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
