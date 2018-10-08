//
//  ReadTrainingViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadTrainingViewController.h"
#import "ListenTeacherTableViewCell.h"
#import "PracticeTestTableViewCell.h"
#import "HomeListenCell.h"
#import "VideoViewController.h"
#import "MyCollectionViewController.h"
#import "ReadSectionA/ReadSectionAViewController.h"

@interface ReadTrainingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation ReadTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"阅读训练";
    [self initWithView];
    [self loadData];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListenTeacherTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PracticeTestTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListenCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeListenCell class])];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [UIView new];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kLoadListenTraining object:nil];
    self.myTableView = tableView;
}
- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager FindAllWithUseId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self.myTableView reloadData];
            }else{
            }
            }];
    }else{
        WeakSelf
        [Tool gotoLogin:self CancelClick:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) return 1;
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        return 97;
    }
    else{
        return 48;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"阅读·讲解课";
    }else if (section == 1){
        return @"模拟考场";
    }
    else {
        return @"阅读·真题训练";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section < 2) {
        // Background color
        view.tintColor = [UIColor whiteColor];
        
        // Text Color
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor blackColor]];
        [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ListenTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else if (indexPath.section == 1){
        PracticeTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = NO;
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"选词填空";
        cell.imageView.image = [UIImage imageNamed:@"短篇新闻"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"已练习%@/%@道",@"1",@"20"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"段落匹配";
        cell.imageView.image = [UIImage imageNamed:@"长对话"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"已练习%@/%@道",@"1",@"20"];
    }else{
        cell.textLabel.text = @"仔细阅读";
        cell.imageView.image = [UIImage imageNamed:@"听力篇章"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"已练习%@/%@道",@"1",@"20"];
    }
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:ReadSectionAViewController.new animated:YES];
        }else if (indexPath.row == 1){
            
        }else{
            
        }
    }else if (indexPath.section == 0){
        [MobClick endEvent:@"listeningpage_course"];
        VideoViewController *vc = [[VideoViewController alloc]init];
        vc.title = @"阅读·讲解课";
        vc.lessonType = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        [MobClick endEvent:@"listeningpage_examination"];
        MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
        vc.title = @"阅读训练";
        [self.navigationController pushViewController:vc animated:YES];
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