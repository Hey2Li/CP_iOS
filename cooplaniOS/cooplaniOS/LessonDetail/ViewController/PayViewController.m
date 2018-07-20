//
//  PayViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PayViewController.h"
#import "BuyLessonTableHeaderView.h"
#import "LessonTableViewCell.h"
#import "PaySuccessViewController.h"
#import "WXPayTableViewCell.h"
#import "WXApi.h"

@interface PayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) BuyLessonTableHeaderView *headerView;
@end

@implementation PayViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        _myTableView.scrollEnabled = NO;
        _myTableView.backgroundColor = UIColorHex(0xf7f7f7);
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonTableViewCell class])];
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WXPayTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WXPayTableViewCell class])];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程详情";
    [self initWithView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxPayHandle:) name:@"WXPay" object:nil];
}
- (void)initWithView{
    self.headerView = [[BuyLessonTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.headerView selectIndex:HeaderSelectLearn];
    self.myTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.myTableView];
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextStepBtn];
    [self.view bringSubviewToFront:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView.mas_left).offset(48);
        make.right.equalTo(self.myTableView.mas_right).offset(-48);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.myTableView.mas_bottom).offset(-145);
    }];
    [nextStepBtn.layer setCornerRadius:8.0f];
    [nextStepBtn setBackgroundColor:UIColorFromRGB(0xd76f67)];
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    nextStepBtn.tag = 1;
    [self.headerView selectIndex:1];
}
- (void)nextStep:(UIButton *)btn{
    [self wxPay];
}
- (void)weiXinPayWithDic:(NSDictionary *)dict {
    PayReq *req = [[PayReq alloc] init];
    req.partnerId           = [dict objectForKey:@"partnerid"];
    req.prepayId            = [dict objectForKey:@"prepayid"];
    req.nonceStr            = [dict objectForKey:@"noncestr"];
    req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
    req.package             = [dict objectForKey:@"package"];
    req.sign                = [dict objectForKey:@"paysign"];
    [WXApi sendReq:req];
    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
}
- (void)wxPay{
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    if (IS_USER_ID) {
        [LTHttpManager wxPayWithCoodsId:@"1" UserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            NSDictionary *dict = [data objectForKey:@"responseData"];
            NSLog(@"-------%@",dict);
            [self weiXinPayWithDic:dict[@"data"]];
        }];
    }else{
        [Tool gotoLogin:self];
    }
}
- (void)wxPayHandle:(NSNotification *)notifi{
    PayResp *resp = notifi.object;
    NSLog(@"resp.errcode%d",resp.errCode);
    switch (resp.errCode) {
        case WXSuccess:
        {
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            SVProgressShowStuteText(@"支付成功", YES);
            PaySuccessViewController *vc = [[PaySuccessViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            SVProgressShowStuteText(@"支付失败", NO);
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"已选课程";//17bold
    }else{
        return @"请选择支付方式";
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = UIColorFromRGB(0xf7f7f7);
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:UIColorFromRGB(0x707070)];
    [header.textLabel setFont:[UIFont systemFontOfSize:12]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0 ? 150 : 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonTableViewCell class])];
        cell.backgroundColor = UIColorHex(0xf7f7f7);
        cell.selectionStyle = NO;
        return cell;
    }else{
        WXPayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WXPayTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
