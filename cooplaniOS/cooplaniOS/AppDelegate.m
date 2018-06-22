//
//  AppDelegate.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "LoginViewController.h"
#import <KeyboardManager.h>
#import <UMShare/UMShare.h>
#import <AVFoundation/AVFoundation.h>

#define USHARE_DEMO_APPKEY @"5861e5daf5ade41326001eab"

@interface AppDelegate ()
@property(nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化控制器
    UIViewController *centerVC = [[HomeViewController alloc]init];
    UIViewController *leftVC = [[LeftViewController alloc]init];
    
    //初始化导航控制器
    BaseViewController *centerNvaVC = [[BaseViewController alloc]initWithRootViewController:centerVC];
    
    //使用MMDrawerController
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftVC];
    //设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //设置左右两边抽屉显示的多少
    self.drawerController.maximumLeftDrawerWidth = 160.0;
    self.drawerController.shouldStretchDrawer = YES;
   
    [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //把阴影关闭
//    self.drawerController.showsShadow = YES;
    UIViewController *loginVC = [[LoginViewController alloc]init];
    BaseViewController *centerNvaVC1 = [[BaseViewController alloc]initWithRootViewController:loginVC];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    [NSThread sleepForTimeInterval:1];

    //初始化窗口、设置根控制器、显示窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:self.drawerController];
    self.window.backgroundColor = [UIColor whiteColor];
    self.drawerController.view.backgroundColor = [UIColor whiteColor];
    self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [avSession setActive:YES error:nil];
    [[JRDBMgr shareInstance] registerClazzes:@[
                                               [DownloadFileModel class],
                                               ]];
    J_CreateTable(DownloadFileModel);
    [self monitorNetworking];
    return YES;
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx0e4cba8a7ddfc51c" appSecret:@"1540440ad4b9f96f8031bde0a47c48cb" redirectURL:@"http://mobile.umeng.com/social"];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)monitorNetworking{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
            {
                NSLog(@"GPRS网络");
                //发通知，带头搞事
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"1" userInfo:nil];
            }
                break;
            case 2:
            {
                NSLog(@"wifi网络");
                //发通知，搞事情
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"2" userInfo:nil];
            }
                break;
            default:
                break;
        }
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"有网");
            [USERDEFAULTS setObject:@"1" forKey:@"isHaveNet"];
        }else{
            NSLog(@"没网");
            [USERDEFAULTS setObject:@"0" forKey:@"isHaveNet"];
        }
    }];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"listenBackground" object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"回到前台");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"listenForeground" object:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
