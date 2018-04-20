//
//  LTHttpManager.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHTTPSessionManager.h"

#define BaseURL @"http:192.168.0.104:8080/cooplan-rest"
@interface LTHttpManager : LTHTTPSessionManager


/**
 查看所有banner跳转页面

 @param complete block
 */
+ (void)FindAllBannerWithComplete:(completeBlock)complete;

/**
 首页查看所有试卷

 @param complete block
 */
+ (void)FindAllWithComplete:(completeBlock)complete;

/**
 用户登录+注册,使用验证码登录

 @param phone 登录手机号
 @param code 验证码
 @param complete block
 */
+ (void)UserCodeLoginWithPhone:(NSString *)phone andCode:(NSString *)code Complete:(completeBlock)complete;


/**
 获取注册验证码

 @param phone 手机号
 @param complete block
 */
+ (void)UserSMSCodeWithPhone:(NSString *)phone Complete:(completeBlock)complete;
@end
