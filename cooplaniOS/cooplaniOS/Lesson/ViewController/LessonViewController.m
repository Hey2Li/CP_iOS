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
#import <AlibcTradeSDK/AlibcTradeSDK.h>


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
    
    self.view.backgroundColor = [UIColor clearColor];
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
        vc.title = model.name;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (model.url) {
            AlibcWebViewController* view = [[AlibcWebViewController alloc] init];
            
            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
            showParam.openType = AlibcOpenTypeNative;
            //8位数appkey
            showParam.backUrl=@"tbopen24996842";
            showParam.isNeedPush=YES;
            showParam.linkKey = @"taobao_scheme";
            showParam.nativeFailMode=AlibcNativeFailModeJumpH5;
            id<AlibcTradePage> page = [AlibcTradePageFactory itemDetailPage:model.url];
            
            //    0:  标识跳转到手淘打开了
            //    1:  标识用h5打开
            //    -1:  标识出错
            NSInteger ret =[[AlibcTradeSDK sharedInstance].tradeService show:self webView:view.webView page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
            NSLog(@"ret-----%ld",ret);
            if (ret == 1) {
                [self.navigationController pushViewController:view animated:YES];
            }
        }
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