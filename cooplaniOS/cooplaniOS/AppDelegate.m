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
#import "BaseHomeViewController.h"
#import "DownloadVideoModel.h"
#import <KeyboardManager.h>
#import <UMShare/UMShare.h>
#import <AVFoundation/AVFoundation.h>
#import "WXApi.h"
#import "WXApiManager.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>

#define USHARE_DEMO_APPKEY @"5861e5daf5ade41326001eab"

@interface AppDelegate ()<JPUSHRegisterDelegate>
@property(nonatomic,strong) MMDrawerController * drawerController;
@property (nonatomic, copy) NSString *loginTime;
@property (nonatomic, copy) NSString *exitTime;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //设置初始侧滑栏
    [self setMMDrawViewController];
    //设置键盘弹出
    [self setKeyboardManager];
    //设置友盟
    [self setUMManager];
    //设置
    [self setSetting];
    //埋点接口
    [self setAPI];
    //极光推送
    [self JSPush:application :launchOptions];
    //阿里电商SDK
    [self setAliSDK];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    if (![[AlibcTradeSDK sharedInstance] application:app
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
    }
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
       
    }
    return result;
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
    [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^(){
    }];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"回到前台");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"listenForeground" object:nil];
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [USERDEFAULTS setObject:[self getCurrentTimes] forKey:@"exittime"];
    NSString *exitTime = [USERDEFAULTS objectForKey:@"exittime"];
    
    NSLog(@"APP被关闭,%@",exitTime);
}


- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
- (void)setMMDrawViewController{
    //初始化控制器
    UIViewController *centerVC = [[BaseHomeViewController alloc]init];
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
    //把阴影关闭
    //    self.drawerController.showsShadow = YES;
    [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    
    //初始化窗口、设置根控制器、显示窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:self.drawerController];
    self.window.backgroundColor = [UIColor whiteColor];
    self.drawerController.view.backgroundColor = [UIColor whiteColor];
    self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
- (void)setKeyboardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
}
- (void)setUMManager{
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:USHARE_DEMO_APPKEY];
    // U-Share 平台设置
    [self configUSharePlatforms];
    [self confitUShareSettings];
}
- (void)setSetting{
    //增加静音模式下也能播放声音
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    [avSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [avSession setActive:YES error:nil];
    //JRDB数据库注册
    [[JRDBMgr shareInstance] registerClazzes:@[
                                               [DownloadFileModel class],
                                               [DownloadVideoModel class],
                                               ]];
    J_CreateTable(DownloadFileModel);
    J_CreateTable(DownloadVideoModel);
    [self monitorNetworking];
}
- (void)setAPI{
    self.loginTime = [self getCurrentTimes];
    NSString *loginTime  = [USERDEFAULTS objectForKey:@"logintime"];
    if (loginTime.length > 0) {
        [LTHttpManager searchLoginCountWithUserId:IS_USER_ID LoginTime:loginTime ExitTime:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSLog(@"用户打开次数");
                NSString *exitTime = [USERDEFAULTS objectForKey:@"exittime"];
                if (exitTime.length > 0) {
                    [LTHttpManager searchLoginCountWithUserId:IS_USER_ID LoginTime:[USERDEFAULTS objectForKey:@"logintime"] ExitTime:exitTime Complete:^(LTHttpResult result, NSString *message, id data) {
                        if (LTHttpResultSuccess == result) {
                            NSLog(@"用户打开次数");
                            [USERDEFAULTS setObject:self.loginTime forKey:@"logintime"];
                        }else{
                            NSLog(@"%@",data[@"msg"]);
                        }
                    }];
                }else{
                    [LTHttpManager searchLoginCountWithUserId:IS_USER_ID LoginTime:self.loginTime ExitTime:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
                        if (LTHttpResultSuccess == result) {
                            NSLog(@"用户打开次数");
                            
                        }else{
                            NSLog(@"%@",data[@"msg"]);
                        }
                    }];
                }
            }else{
                NSLog(@"%@",data[@"msg"]);
            }
        }];
    }else{
        [LTHttpManager searchLoginCountWithUserId:IS_USER_ID LoginTime:loginTime ExitTime:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSLog(@"用户打开次数");
            }else{
                NSLog(@"%@",data[@"msg"]);
            }
        }];
        [USERDEFAULTS setObject:self.loginTime forKey:@"logintime"];
    }
}
#pragma mark 极光推送
- (void)JSPush:(UIApplication *)application :(NSDictionary *)launchOptions{
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"0f5416a3ab0db79b426a8e70"
                          channel:@"App Store"
                 apsForProduction:false
            advertisingIdentifier:advertisingId];
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
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
    [WXApi registerApp:@"wx0e4cba8a7ddfc51c" enableMTA:YES];
}
- (void)monitorNetworking{
    NSString *loginTime = [USERDEFAULTS objectForKey:@"logintime"];
    if (loginTime.length == 0) {
        NSString *GPRSPlay;//移动网络播放
        NSString *GPRSDownload;//移动网络下载
        GPRSPlay = @"0";
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:GPRSPlay forKey:@"GPRSPlay"];
        GPRSDownload = @"0";
        [userDefaults setObject:GPRSDownload forKey:@"GPRSDownload"];
    }
   
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
                [[NSUserDefaults standardUserDefaults]setObject:@"GPRS" forKey:@"networkState"];
            }
                break;
            case 2:
            {
                NSLog(@"wifi网络");
                //发通知，搞事情
                //                [[NSNotificationCenter defaultCenter] postNotificationName:@"monitorNetworking" object:@"2" userInfo:nil];
                [[NSUserDefaults standardUserDefaults]setObject:@"WIFI" forKey:@"networkState"];
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
- (void)setAliSDK{
    [[AlibcTradeSDK sharedInstance]asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        NSLog(@"alisdk 初始化失败： %@",error.description);
    }];
    [[AlibcTradeSDK sharedInstance]setDebugLogOpen:YES];
    
    
    [[AlibcTradeSDK sharedInstance]setIsForceH5:NO];
}
@end
