//
//  SettingViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SettingViewController.h"
#import "ChangePhoneViewController.h"

@interface SettingViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.myTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    self.title = @"设置";
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.sectionHeaderHeight = 10.0f;
    tableView.sectionFooterHeight = CGFLOAT_MIN;
    tableView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    tableView.tableFooterView = [UIView new];
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:quitBtn];
    [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@48);
        make.bottom.equalTo(self.view).offset(-220);
    }];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn setBackgroundColor:UIColorFromRGB(0xD76F67)];
    [quitBtn addTarget:self action:@selector(quitLogin:) forControlEvents:UIControlEventTouchUpInside];
    if (!IS_USER_ID) {
        quitBtn.hidden = YES;
    }else{
        quitBtn.hidden = NO;
    }
}
- (void)quitLogin:(UIButton *)btn{
    LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"确定退出登录" sureBtn:@"确定" cancleBtn:@"取消"];
    alertView.resultIndex = ^(NSInteger index) {
        NSString *appDomain = [[NSBundle mainBundle]bundleIdentifier];
        [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
        SVProgressShowStuteText(@"退出成功", YES);
        [[NSNotificationCenter defaultCenter]postNotificationName:kHomeReloadData object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"quitLogin" object:nil];
        [self.myTableView reloadData];
        btn.hidden = YES;
    };
    [alertView show];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 2:
        case 3:
        case 4:
            return 1;
            break;
        case 1:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.selectionStyle = NO;
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"修改绑定手机号码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            return cell;
        }
            break;
         case 1:
        {
            if (indexPath.row == 0) {
                UISwitch *cellSwitch = [[UISwitch alloc]init];
                cellSwitch.onTintColor = UIColorFromRGB(0x4DAC7D);
                [cell addSubview:cellSwitch];
                [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).offset(-18);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
                NSString *GPRSPlay = [USERDEFAULTS objectForKey:@"GPRSPlay"];
                if ([GPRSPlay isEqualToString:@"0"]) {
                    cellSwitch.on = NO;
                }else{
                    cellSwitch.on = YES;
                }
                cellSwitch.tag = 0;
                [cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                cell.textLabel.text = @"允许移动网络播放";
                return cell;
            }else{
                UISwitch *cellSwitch = [[UISwitch alloc]init];
                cellSwitch.onTintColor = UIColorFromRGB(0x4DAC7D);
                [cell addSubview:cellSwitch];
                [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(cell.mas_right).offset(-18);
                    make.centerY.equalTo(cell.mas_centerY);
                }];
                cellSwitch.tag = 1;
                NSString *GPRSDownload = [USERDEFAULTS objectForKey:@"GPRSDownload"];
                if ([GPRSDownload isEqualToString:@"0"]) {
                    cellSwitch.on = NO;
                }else{
                    cellSwitch.on = YES;
                }
                [cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
                cell.textLabel.text = @"允许移动网络下载";
                return cell;
            }
        }
            break;
        case 2:
        {
            cell.textLabel.text = @"应用消息推送";
            UISwitch *cellSwitch = [[UISwitch alloc]init];
            cellSwitch.onTintColor = UIColorFromRGB(0x4DAC7D);
            [cell addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-18);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            cellSwitch.tag = 2;
            if (![self isUserNotificationEnable]) {
                cellSwitch.on = NO;
            }else{
                cellSwitch.on = YES;
            }
            [cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell *subcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            subcell.textLabel.font = [UIFont systemFontOfSize:16];
            subcell.textLabel.textColor = UIColorFromRGB(0x666666);
            subcell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            subcell.detailTextLabel.textColor = UIColorFromRGB(0xCCCCCC);
            subcell.textLabel.text = @"清除缓存";
            subcell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fM", [self folderSizeAtPath:[self getCachesPath]]];
            subcell.selectionStyle = NO;
            return subcell;
        }
            break;
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ChangePhoneViewController *vc = [[ChangePhoneViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3){
        [self cleanCaches:[self getCachesPath]];
        [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)switchChange:(UISwitch *)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *GPRSPlay;//移动网络播放
    NSString *GPRSDownload;//移动网络下载
    NSString *isPush;//是否推送
    if (sender.tag == 0) {
        GPRSPlay = sender.on ? @"0":@"1";
        [userDefaults setObject:GPRSPlay forKey:@"GPRSPlay"];
    }else if (sender.tag == 1){
        GPRSDownload = sender.on ? @"0" : @"1";
        [userDefaults setObject:GPRSDownload forKey:@"GPRSDownload"];
    }else if (sender.tag == 2){
        isPush = sender.on ? @"0" : @"1";
        [userDefaults setObject:isPush forKey:@"isPush"];
        if (!sender.on) {
            [[UIApplication sharedApplication]unregisterForRemoteNotifications];
        }else{
            if (![self isUserNotificationEnable]) {
                [self goToAppSystemSetting];
            }else{
                [[UIApplication sharedApplication]registerForRemoteNotifications];
            }
        }
    }
    [userDefaults synchronize];
}
- (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
- (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}

// 获取Caches目录路径
- (NSString *)getCachesPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths lastObject];
    return cachesDir;
}

- (CGFloat)folderSizeAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 目录下的文件计算大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        //SDWebImage的缓存计算
        size += [[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        // 将大小转化为M,size单位b,转，KB,MB除以两次1024
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
- (void)cleanCaches:(NSString *)path{
    //SDWebImage的清除功能
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    SVProgressShowStuteText(@"缓存清理成功", YES);
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
