//
//  ListenTrainingViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenTrainingViewController.h"
#import "ListenTeacherTableViewCell.h"
#import "PracticeTestTableViewCell.h"
#import "PaperModel.h"
#import "HomeListenCell.h"
#import "PaperDetailViewController.h"
#import "VideoViewController.h"

@interface ListenTrainingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *paperMutableArray;
@end

@implementation ListenTrainingViewController
- (NSMutableArray *)paperMutableArray{
    if (!_paperMutableArray) {
        _paperMutableArray = [NSMutableArray array];
    }
    return _paperMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"听力训练";
    [self initWithView];
    [self loadData];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListenTeacherTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PracticeTestTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListenCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeListenCell class])];
    [self.view addSubview:tableView];
    self.myTableView = tableView;
}
- (void)loadData{
    [LTHttpManager FindAllWithUseId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"];
            NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
            [self.paperMutableArray removeAllObjects];
            for (NSDictionary *dic in array) {
                muDict = [NSMutableDictionary dictionaryWithDictionary:dic[@"tp"]];
                [muDict addEntriesFromDictionary:@{@"collection":dic[@"type"]}];
                PaperModel *model = [PaperModel mj_objectWithKeyValues:muDict];
                [self.paperMutableArray addObject:model];
            }
            [USERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:self.paperMutableArray]forKey:@"homeData"];
            [self.myTableView reloadData];
        }else{
            [self.paperMutableArray removeAllObjects];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:@"homeData"]];
            if (array.count) {
                self.paperMutableArray = [NSMutableArray arrayWithArray:array];
                [self.myTableView reloadData];
            }else{
                self.myTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                    [self loadData];
                }];
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) return 1;
    return self.paperMutableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        return 97;
    }
    else{
//        return SCREEN_HEIGHT - 300;
        return 78;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"听力·讲解课";
    }else if (section == 1){
        return @"模拟考场";
    }
    else {
        return @"听力·真题训练";
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
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
    HomeListenCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeListenCell class])];
    cell.selectionStyle = NO;
    cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    cell.Model = self.paperMutableArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        HomeListenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PaperDetailViewController *vc = [PaperDetailViewController new];
        vc.nextTitle = cell.TitleLabel.text;
        vc.onePaperModel = self.paperMutableArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0){
        VideoViewController *vc = [[VideoViewController alloc]init];
        vc.title = @"听力训练";
        [self.navigationController pushViewController:vc animated:YES];
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
