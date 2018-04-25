//
//  AnswerViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerTableViewCell.h"

@interface AnswerViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end

@implementation AnswerViewController

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [_myTableView registerNib:[UINib nibWithNibName:@"AnswerTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AnswerTableViewCell class])];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myTableView];
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isOpen && self.selectIndexPath.section == section) {
        return 3;
    }else{
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isOpen && self.selectIndexPath != nil) {
        if (indexPath.row == self.selectIndexPath.row + 1 && indexPath.section == self.selectIndexPath.section) {
            return 150;
        }else{
            return 50;
        }
    }else{
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *sectionLb = [UILabel new];
    sectionLb.text = @"Section A";
    [headerView addSubview:sectionLb];
    [sectionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(10);
        make.right.equalTo(headerView.mas_right).offset(10);
        make.top.equalTo(headerView);
        make.height.equalTo(@30);
    }];
    
    UILabel *questionLb = [UILabel new];
    questionLb.text = @"News Report One";
    [headerView addSubview:questionLb];
    [questionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sectionLb);
        make.right.equalTo(sectionLb);
        make.top.equalTo(sectionLb.mas_bottom);
        make.bottom.equalTo(headerView.mas_bottom);
    }];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//    cell.textLabel.text = [NSString stringWithFormat:@"%ld,%ld",indexPath.section, indexPath.row];
//    if (self.isOpen && self.selectIndexPath.row < indexPath.row && indexPath.row <= self.selectIndexPath.row + 1) {
//        
//    }else{
//      
//    }
//    if (self.isOpen && self.selectIndexPath.row) {
//        AnswerTableViewCell *acell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class])];
//        return acell;
//    }else{
//        return cell;
//    }
    UITableViewCell *cell;
    if (self.isOpen && self.selectIndexPath.row < indexPath.row && indexPath.row <= self.selectIndexPath.row + 1) {   // Expand cell
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AnswerTableViewCell class]) forIndexPath:indexPath];
    } else {    // Normal cell
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld,%ld",indexPath.section, indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (!self.selectIndexPath) {
//        self.isOpen = YES;
//        self.selectIndexPath = indexPath;
//        [tableView beginUpdates];
//        NSIndexPath *indexPat = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
//        [tableView insertRowsAtIndexPaths:@[indexPat] withRowAnimation:UITableViewRowAnimationTop];
//        [tableView endUpdates];
//    }else{
//        self.isOpen = NO;
//        [tableView beginUpdates];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
//        [tableView endUpdates];
//        self.selectIndexPath = nil;
//    }
    if (!self.selectIndexPath) {
        self.isOpen = YES;
        self.selectIndexPath = indexPath;
        [self.myTableView beginUpdates];
        [self.myTableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.myTableView endUpdates];
    } else {
        if (self.isOpen) {
            if (self.selectIndexPath == indexPath) {
                self.isOpen = NO;
                [self.myTableView beginUpdates];
                [self.myTableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                [self.myTableView endUpdates];
                self.selectIndexPath = nil;
            } else if (self.selectIndexPath.row < indexPath.row && indexPath.row <= self.selectIndexPath.row + 1) {
                
            } else {
                self.isOpen = NO;
                [self.myTableView beginUpdates];
                [self.myTableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.myTableView endUpdates];
                self.selectIndexPath = nil;
            }
        }
    }
}
- (NSArray *)indexPathsForExpandRow:(NSIndexPath *)indexPath {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= 1; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
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
