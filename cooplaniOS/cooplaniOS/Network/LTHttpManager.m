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
+ (void)FindAllWithUseId:(NSNumber *)userid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userid":userid ? userid : @""
                                };
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
                                @"id":ID
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
                                @"userId":user_id,
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
                                @"testPaperId":ID,
                                @"userId":IS_USER_ID
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/myCollect/private/delete",BaseURL]parameters:paramters complete:complete];
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

/**
 默认登录 用户在关闭app再打开要重新验证
 
 @param userId 用户id
 @param complete block
 */
+(void)UserDefaultLoginWithUserId:(NSNumber *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":[Tool getAppVersion],
                                @"userId":userId
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/defaulLogin",BaseURL]parameters:paramters complete:complete];
}
/**
 *  下载文件
 *
 *  @param downloadURL  下载链接
 *  @param success 请求结果
 *  @param faliure 错误信息
 */
+(void)downloadURL:(NSString *) downloadURL progress:(void (^)(NSProgress *downloadProgress))progress destination:(void (^)(NSURL *targetPath))destination failure:(void(^)(NSError *error))faliure{
    
    
    //1.创建管理者
    AFHTTPSessionManager *manage  = [AFHTTPSessionManager manager];
    
    //2.下载文件
    /*
     第一个参数：请求对象
     第二个参数：下载进度
     第三个参数：block回调，需要返回一个url地址，用来告诉AFN下载文件的目标地址
     targetPath：AFN内部下载文件存储的地址，tmp文件夹下
     response：请求的响应头
     返回值：文件应该剪切到什么地方
     第四个参数：block回调，当文件下载完成之后调用
     response：响应头
     filePath：文件存储在沙盒的地址 == 第三个参数中block的返回值
     error：错误信息
     */
    
    //2.1 创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: downloadURL]];
    
    NSURLSessionDownloadTask *downloadTask = [manage downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {//进度
        
        if (downloadProgress) {
            progress(downloadProgress);
            [SVProgressHUD showProgress:downloadProgress.fractionCompleted];
            if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                    SVProgressShowStuteText(@"下载成功", YES);
                });
            }
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件全路径
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        NSLog(@"%@",filePathUrl);
        return filePathUrl;
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
        
        
        if (error) {
            faliure(error);
        }
        
        
        if(filePath){
            
            destination(filePath);
        }
    }];
    
    //3.启动任务
    [downloadTask resume];
}

@end
