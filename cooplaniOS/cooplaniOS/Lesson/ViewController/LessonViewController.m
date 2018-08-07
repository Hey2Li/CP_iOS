  //
//  LessonViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonTableViewCell.h"
#import "BuyLessonViewController.h"
#import "LessonDetailViewController.h"
#import "LessonModel.h"
#import "LessonListMenuViewController.h"

@interface LessonViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation LessonViewController

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
    [self loadData];
}
- (void)loadData{
    [LTHttpManager findAllCommodityWithComplete:^(LTHttpResult result, NSString *message, id data) {
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
}
- (void)initWithView{
    //底部背景
    UIView *backView;
    if (UI_IS_IPHONE4) {
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64 - 100 , 750, 750)];
    }else{
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64, 750, 750)];
    }
    backView.backgroundColor = DRGBCOLOR;
    backView.layer.cornerRadius = 375;
    backView.layer.masksToBounds = YES;
    backView.clipsToBounds = YES;
    [self.view addSubview:backView];
    [self.view insertSubview:backView atIndex:0];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonTableViewCell class])];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView = tableView;
    
    self.myTableView.tableFooterView = [UIView new];
    
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:152];
}
//修改sectionheader背景颜色
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = DRGBCOLOR;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"四级精品课"];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17]range:NSMakeRange(0, 3)];
    return [titleStr string];//17bold
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonTableViewCell class])];
    cell.lessonModel = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LessonModel *model = self.dataArray[indexPath.row];
    if ([model.state isEqualToString:@"1"]) {
        LessonListMenuViewController *vc = [[LessonListMenuViewController alloc]init];
        vc.lessonType = [NSString stringWithFormat:@"%@",model.type];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        LessonDetailViewController *vc = [[LessonDetailViewController alloc]init];
        vc.commodity_id = [NSString stringWithFormat:@"%@",model.ID];
        vc.lessDetailUrl = model.url;
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
