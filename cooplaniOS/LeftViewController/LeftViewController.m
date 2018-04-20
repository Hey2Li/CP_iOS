//
//  LeftViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LeftViewController.h"
#import "MyNoteViewController.h"
#import "MyCollectionViewController.h"
#import "MyDownloadViewController.h"
#import "WrongTopicViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "LeftViweTableViewCell.h"
#import "NoContentViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *headerBtn;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initWithView];
}
- (void)initWithView{
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 160.0, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [tableView registerNib:[UINib nibWithNibName:@"LeftViweTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LeftViweTableViewCell class])];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160.0, 200)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    [headerView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    headerBtn.layer.cornerRadius = 40.0f;
    headerBtn.layer.masksToBounds = YES;
    headerBtn.layer.borderWidth = 2.0f;
    headerBtn.layer.borderColor = DRGBCOLOR.CGColor;
    [headerBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerBtn = headerBtn;
    UILabel *userNameLb = [[UILabel alloc]init];
    NSString *phoneStr = [USERDEFAULTS objectForKey:USER_PHONE_KEY];
    userNameLb.text =  phoneStr.length > 0 ? [USERDEFAULTS objectForKey:USER_PHONE_KEY] : @"请登录";
    userNameLb.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:userNameLb];
    [userNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBtn.mas_centerX);
        make.top.equalTo(headerBtn.mas_bottom).offset(20);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    userNameLb.font = [UIFont boldSystemFontOfSize:16];
    userNameLb.textColor = UIColorFromRGB(0x444444);
    tableView.tableHeaderView = headerView;
    [self.view addSubview:tableView];
}
- (void)headerBtnClick:(UIButton *)btn{
    if ([USERDEFAULTS objectForKey:USER_ID]) {
        return;
    }else{
        LoginViewController *vc = [[LoginViewController alloc]init];
        //拿到我们的ViewController，让它去push
        UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:vc animated:NO];
        //当我们push成功之后，关闭我们的抽屉
        [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
            //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
            [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:45];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    LeftViweTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftViweTableViewCell class])];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DRGBCOLOR;
    cell.selectedBackgroundView = view;
    switch (indexPath.row) {
        case 0:
            cell.titleLb.text = @"我的笔记";
            cell.leftImageVIew.image = [UIImage imageNamed:@"note"];
            break;
        case 1:
            cell.titleLb.text = @"我的收藏";
            cell.leftImageVIew.image = [UIImage imageNamed:@"collection"];
            break;
        case 2:
            cell.titleLb.text = @"我的错题";
            cell.leftImageVIew.image = [UIImage imageNamed:@"errorlog"];
            break;
        case 3:
            cell.titleLb.text = @"我的下载";
            cell.leftImageVIew.image = [UIImage imageNamed:@"download"];
            break;
        case 4:
            cell.titleLb.text = @"设置";
            cell.leftImageVIew.image = [UIImage imageNamed:@"settings"];
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *VC;
//    switch (indexPath.row) {
//        case 0:{
//            VC = [[MyNoteViewController alloc]init];
//        }
//            break;
//        case 1:{
//            VC = [[MyCollectionViewController alloc]init];
//        }
//            break;
//        case 2:{
//            VC = [[WrongTopicViewController alloc]init];
//        }
//            break;
//        case 3:{
//            VC = [[MyDownloadViewController alloc]init];
//        }
//            break;
//        case 4:{
//            VC = [[SettingViewController alloc]init];
//        }
//        default:
//            break;
//    }
    VC = [[NoContentViewController alloc]init];
    switch (indexPath.row) {
        case 0:
        {
            VC.title = @"我的笔记";
        }
            break;
        case 1:
        {
            VC.title = @"我的收藏";
        }
            break;
        case 2:
        {
            VC.title = @"我的错题";
        }
            break;
        case 3:
        {
            VC.title = @"我的下载";
        }
            break;
        case 4:
        {
            VC = [[SettingViewController alloc]init];
            VC.title = @"我的设置";
        }
        default:
            break;
    }
    ;   //拿到我们的ViewController，让它去push
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:VC animated:NO];
    //当我们push成功之后，关闭我们的抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
    }];
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
