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
#import "LoginViewController.h"
#import "LeftViweTableViewCell.h"
#import "NoContentViewController.h"
#import "FeedbackViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UILabel *userNameLb;
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
    self.userNameLb = userNameLb;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
        case 2:
        case 4:
            return 2;
            break;
        case 3:
            return 95;
            break;
        case 5:
            return 20;
            break;
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:45];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftViweTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftViweTableViewCell class])];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DRGBCOLOR;
    cell.selectedBackgroundView = view;
    switch (indexPath.section) {
        case 0:
            cell.titleLb.text = @"我的笔记";
            cell.leftImageVIew.image = [UIImage imageNamed:@"note"];
            break;
        case 1:
            cell.titleLb.text = @"我的收藏";
            cell.leftImageVIew.image = [UIImage imageNamed:@"collection"];
            break;
        case 2:
            cell.titleLb.text = @"我的下载";
            cell.leftImageVIew.image = [UIImage imageNamed:@"errorlog"];
            break;
        case 3:
            cell.titleLb.text = @"意见反馈";
            cell.leftImageVIew.image = [UIImage imageNamed:@"Feedback"];
            break;
        case 4:
            cell.titleLb.text = @"关于我们";
            cell.leftImageVIew.image = [UIImage imageNamed:@"about us"];
            break;
        case 5:
            cell.titleLb.text = @"退出登录";
            cell.titleLb.textAlignment = NSTextAlignmentLeft;
            cell.titleLb.font = [UIFont systemFontOfSize:14];
            cell.titleLb.textColor = UIColorFromRGB(0xFFFFFF);
            cell.contentView.backgroundColor = UIColorFromRGB(0xD76F67);
            cell.selectionStyle = NO;
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoContentViewController *VC = [[NoContentViewController alloc]init];
    switch (indexPath.section) {
        case 0:
        {
            MyNoteViewController *vc = [[MyNoteViewController alloc]init];
            vc.title = @"我的笔记";
            //拿到我们的ViewController，让它去push
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:vc animated:NO];
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
        }
            break;
        case 1:
        {
            MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
            //拿到我们的ViewController，让它去push
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:vc animated:NO];
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
        }
            break;
        case 2:
        {
            MyDownloadViewController *vc = [[MyDownloadViewController alloc]init];
            vc.title = @"我的下载";
            //拿到我们的ViewController，让它去push
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:vc animated:NO];
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
        }
            break;
        case 3:
        {
            FeedbackViewController *vcccc = [[FeedbackViewController alloc]init];
            vcccc.title = @"意见反馈";
            //拿到我们的ViewController，让它去push
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:vcccc animated:NO];
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
        }
            break;
        case 4:
        {
            VC.title = @"关于我们";
            //拿到我们的ViewController，让它去push
            UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
            [nav pushViewController:VC animated:NO];
            //当我们push成功之后，关闭我们的抽屉
            [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
                //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
                [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
            }];
        }
            break;
        case 5:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出登录" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
                [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
                [alert dismissViewControllerAnimated:YES completion:nil];
                SVProgressShowStuteText(@"退出成功", YES);
                self.userNameLb.text = @"请登录";
                [self.myTableView reloadData];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        default:
            break;
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
