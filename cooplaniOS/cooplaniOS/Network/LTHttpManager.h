//
//  LTHttpManager.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHTTPSessionManager.h"

#define BaseURL @"http://app.cooplan.cn"
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


/**
 用户意见反馈

 @param user_id 用户id
 @param type 类型
 @param info 用户反馈信息
 @param contactInfo 用户联系方式
 @param files 图片流
 @param complete block
 */

+ (void)feedbackWithUserId:(NSNumber *)user_id Type:(NSString *)type Info:(NSString *)info ContactInfo:(NSString *)contactInfo Files:(NSArray *)files Complete:(completeBlock)complete;

/**
 第三方登录

 @param openId 三方ID
 @param identityType 登录方式微信（wx）
 @param token 三方验证令牌
 @param tokenTime token过期时间
 @param headPortrait 头像路径
 @param nickname 昵称
 @param sex 性别
 @param age 年龄
 @param complete block
 */
+ (void)thirdPartyLoginWithOpenId:(NSString *)openId IdentityType:(NSString *)identityType Token:(NSString *)token TokenTime:(NSString *)tokenTime HeadPortrait:(NSString *)headPortrait NickName:(NSString *)nickname Sex:(NSString *)sex age:(NSString *)age Complete:(completeBlock)complete;
@end
