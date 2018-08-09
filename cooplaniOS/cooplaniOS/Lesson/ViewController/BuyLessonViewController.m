//
//  BuyLessonViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "BuyLessonViewController.h"
#import "BuyLessonTableHeaderView.h"
#import "AddressTableViewCell.h"
#import "PayViewController.h"
#import <YJLocationPicker.h>

@interface BuyLessonViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) BuyLessonTableHeaderView *headerView;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *telephoneStr;
@property (nonatomic, strong) NSString *addresseeStr;
@end

@implementation BuyLessonViewController

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        _myTableView.scrollEnabled = NO;
        _myTableView.backgroundColor = UIColorHex(0xf7f7f7);
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressTableViewCell class])];
    }
    return _myTableView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程详情";
    [self initWithView];
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
    [self.headerView selectIndex:0];
}
- (void)nextStep:(UIButton *)btn{
    if (_addresseeStr.length > 0) {
        if (_telephoneStr.length > 0) {
            if (![Tool judgePhoneNumber:_telephoneStr]) {
                SVProgressShowStuteText(@"请输入正确的手机号码", NO);
                return;
            }else{
                if (_addressStr.length > 10) {
                    if (IS_USER_ID) {
                        [LTHttpManager addOrderInfoWIthUserId:IS_USER_ID Addressee:_addresseeStr Phone:_telephoneStr Address:_addressStr CommodityId:self.commodity_id Complete:^(LTHttpResult result, NSString *message, id data) {
                            if (LTHttpResultSuccess == result) {
                                PayViewController *vc = [[PayViewController alloc]init];
                                vc.orderId = data[@"responseData"];
                                vc.commodity_id = self.commodity_id;
                                [self.navigationController pushViewController:vc animated:YES];
                            }else{
                                SVProgressShowStuteText(message, NO);
                            }
                        }];

                    }else{
                        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
                        [alertView show];
                        alertView.resultIndex = ^(NSInteger index) {
                            LoginViewController *vc = [[LoginViewController alloc]init];
                            [self.navigationController pushViewController:vc animated:YES];
                        };
                    }
                }else{
                    SVProgressShowStuteText(@"请填写地址", NO);
                }
            }
        }else{
            SVProgressShowStuteText(@"请输入手机号码", NO);
        }
    }else{
        SVProgressShowStuteText(@"请填写收件人", NO);
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请填写正确地址，以便我们寄送学习资料";//17bold
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:UIColorFromRGB(0x707070)];
    [header.textLabel setFont:[UIFont systemFontOfSize:12]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 277 + 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddressTableViewCell class])];
    cell.selectionStyle = NO;
    cell.addressClick = ^(NSString *text) {
        _addressStr = [NSString stringWithFormat:@"%@%@",_addressStr,text];
        NSLog(@"%@",_addressStr);
    };
    cell.addresseeClick = ^(NSString *text) {
        _addresseeStr = text;
        NSLog(@"%@",_addresseeStr);
    };
    cell.telephoneClick = ^(NSString *text) {
        NSLog(@"%@",text);
        _telephoneStr = text;
    };
    cell.changeAddressClick = ^(UILabel *lb) {
        [[[YJLocationPicker alloc]initWithSlectedLocation:^(NSArray *locationArray) {
            lb.text = [NSString stringWithFormat:@"%@ %@ %@",locationArray[0],locationArray[1],locationArray[2]];
            _addressStr = lb.text;
        }]show];
    };
    return cell;
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