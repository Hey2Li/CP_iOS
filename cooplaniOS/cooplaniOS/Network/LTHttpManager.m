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
    [manager UPLOADWithParameters:[NSString stringWithFormat:@"%@/client/feedback/private/feedback",BaseURL] parameters:paramters photoArray:files complete:complete];
}
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
+ (void)thirdPartyLoginWithOpenId:(NSString *)openId IdentityType:(NSString *)identityType Token:(NSString *)token TokenTime:(NSString *)tokenTime HeadPortrait:(NSString *)headPortrait NickName:(NSString *)nickname Sex:(NSString *)sex age:(NSString *)age Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"openId":openId,
                                @"identityType":identityType,
                                @"token":token,
                                @"tokenTime":tokenTime,
                                @"headPortrait":headPortrait,
                                @"nickname":nickname,
                                @"sex":sex,
                                @"age":age,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/thirdPartyLogin",BaseURL]parameters:paramters complete:complete];
}
/**
 我的笔记收藏句子
 
 @param userId 用户ID
 @param sentenceEN 英文句子
 @param sentenceCN 中文翻译
 @param complete block
 */
+ (void)collectionSectenceWithUserId:(NSString *)userId SectenceEN:(NSString *)sentenceEN SentenceCN:(NSString *)sentenceCN Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":userId,
                                @"sentenceEN":sentenceEN,
                                @"sentenceCN":sentenceCN,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/SentenceNote/private/add",BaseURL]parameters:paramters complete:complete];
}
@end
