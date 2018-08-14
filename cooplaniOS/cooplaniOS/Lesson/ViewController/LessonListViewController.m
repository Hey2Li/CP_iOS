//
//  LessonListViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonListViewController.h"
#import "LessonTableViewCell.h"
#import "LessonListMenuViewController.h"
#import "LessonDetailViewController.h"
#import "LessonModel.h"

@interface LessonListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LessonListViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的课程";
    [self loadData];
}
- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager findAllMyCommodityWithUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *dataArray = data[@"responseData"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in dataArray) {
                    LessonModel *model = [LessonModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.myTableView reloadData];
            }
        }];        
    }else{
        [Tool gotoLogin:self];
    }
}
- (void)initWithView{
   
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = NO;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonTableViewCell class])];
    self.myTableView = tableView;
    self.myTableView.backgroundColor = UIColorFromRGB(0xF7F7F7);

    self.myTableView.tableFooterView = [UIView new];
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:152];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonTableViewCell class])];
    cell.myLessonModel = self.dataArray[indexPath.row];
    cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    cell.selectionStyle = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{    
    LessonListMenuViewController *vc = [[LessonListMenuViewController alloc]init];
    LessonModel *model = self.dataArray[indexPath.row];
    vc.qr_code = model.qr_code;
    vc.lessonType = [NSString stringWithFormat:@"%@",model.type];
    vc.title = model.name;
    [self.navigationController pushViewController:vc animated:YES];
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
