//
//  LTHttpManager.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHttpManager.h"

@implementation LTHttpManager
/**
 查看所有banner跳转页面
 
 @param complete block
 */
+ (void)FindAllBannerWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/banner/findAllBanner",BaseURL] parameters:paramters complete:complete];
}
/**
 首页查看所有试卷
 
 @param complete block
 */
+ (void)FindAllWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/testPaper/findAll",BaseURL]parameters:paramters complete:complete];
}

/**
 查询一张试卷的信息(首页点击试卷获取试卷)
 
 @param ID 试卷的id
 @param complete block
 */
+ (void)findOneTestPaperWithID:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"id":ID,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/testPaper/findOne",BaseURL]parameters:paramters complete:complete];
}

/**
 用户登录+注册,使用验证码登录
 
 @param phone 登录手机号
 @param code 验证码
 @param complete block
 */
+ (void)UserCodeLoginWithPhone:(NSString *)phone andCode:(NSString *)code Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
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
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
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
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
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
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
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
 用户注销
 
 @param complete block
 */
+ (void)UserLoginOut:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/logout",BaseURL]parameters:paramters complete:complete];
}

/**
 我的笔记收藏句子
 
 @param userId 用户ID
 @param sentenceEN 英文句子
 @param sentenceCN 中文翻译
 @param complete block
 */
+ (void)collectionSectenceWithUserId:(NSString *)userId SectenceEN:(NSString *)sentenceEN SentenceCN:(NSString *)sentenceCN TestPaperName:(NSString *)testPaperName Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":userId,
                                @"sentenceEN":sentenceEN,
                                @"sentenceCN":sentenceCN,
                                @"testPaperName":testPaperName
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/SentenceNote/private/add",BaseURL]parameters:paramters complete:complete];
}
/**
 用户删除收藏句子笔记(用户登录后才可操作)
 
 @param ID 收藏的句子id
 @param complete block
 */
+ (void)deleteSentenceNoteWithId:(NSNumber *)ID WithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"id":ID,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/SentenceNote/private/delete",BaseURL]parameters:paramters complete:complete];
}

/**
 用户以时间降序查询收藏的句子笔记(用户登录后才可操作)
 
 @param userId 用户id
 @param complete block
 */
+ (void)findSectenceNoteWIthUserId:(NSNumber *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":userId,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/SentenceNote/private/find",BaseURL]parameters:paramters complete:complete];
}

/**
 用户收藏试卷(用户登录后才可操作)
 
 @param user_id 用户id
 @param testPaperId 试卷的id
 @param complete block
 */
+ (void)collectionTestPaperWithUserId:(NSNumber *)user_id TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"user_id":user_id,
                                @"testPaperId":testPaperId
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/myCollect/private/add",BaseURL]parameters:paramters complete:complete];
}

/**
 用户删除收藏试卷(用户登录后才可操作)
 
 @param ID 收藏表中的id
 @param complete block
 */
+ (void)deleteCollectionTestPaperWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"id":ID,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/myCollect/private/add",BaseURL]parameters:paramters complete:complete];
}

/**
 用户查看所有收藏试卷(用户登录后才可操作)
 
 @param userId 用户id
 */
+ (void)findAllCollectionTestPaperWithUserId:(NSNumber *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":userId
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/myCollect/private/find",BaseURL]parameters:paramters complete:complete];
}
@end
