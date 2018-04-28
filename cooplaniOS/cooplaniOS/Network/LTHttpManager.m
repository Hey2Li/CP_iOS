//
//  LTHttpManager.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHttpManager.h"

@implementation LTHttpManager
+ (void)FindAllBannerWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/banner/findAllBanner",BaseURL] parameters:paramters complete:complete];
}
+ (void)FindAllWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/testPaper/findAll",BaseURL]parameters:paramters complete:complete];
}
/**
 用户登录+注册,使用验证码登录
 
 @param phone 登录手机号
 @param code 验证码
 @param complete block
 */
+ (void)UserCodeLoginWithPhone:(NSString *)phone andCode:(NSString *)code Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"phone":phone,
                                @"code":code
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/uesCodeLogin",BaseURL]parameters:paramters complete:complete];
}


/**
 获取注册验证码
 
 @param phone 手机号
 @param complete block
 */
+ (void)UserSMSCodeWithPhone:(NSString *)phone Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"phone":phone,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/smsCode",BaseURL]parameters:paramters complete:complete];
}
/**
 用户意见反馈
 
 @param user_id 用户id
 @param type 类型
 @param info 用户反馈信息
 @param contactInfo 用户联系方式
 @param files 图片流
 @param complete block
 */
+ (void)feedbackWithUserId:(NSNumber *)user_id Type:(NSString *)type Info:(NSString *)info ContactInfo:(NSString *)contactInfo Files:(NSArray *)files Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":user_id,
                                @"type":type,
                                @"info":info,
                                @"contactInfo":contactInfo,
                                };
//    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/feedback/feedback",BaseURL]parameters:paramters complete:complete];
    [manager UPLOADWithParameters:[NSString stringWithFormat:@"%@/client/public/feedback/feedback",BaseURL] parameters:paramters photoArray:files complete:complete];
}
@end
