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
    NSDictionary *paramters = @{@"version":kVersion_1};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/banner/findAllBanner",BaseURL] parameters:paramters complete:complete];
}
/**
 首页查看所有试卷
 
 @param complete block
 */
+ (void)FindAllWithUseId:(NSNumber *)userid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
+ (void)thirdPartyLoginWithOpenId:(NSString *)openId IdentityType:(NSString *)identityType Token:(NSString *)token TokenTime:(NSString *)tokenTime HeadPortrait:(NSString *)headPortrait NickName:(NSString *)nickname Sex:(NSString *)sex age:(NSString *)age UnionId:(NSString *)unionid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"openId":openId,
                                @"identityType":identityType,
                                @"token":token,
                                @"tokenTime":tokenTime,
                                @"headPortrait":headPortrait,
                                @"nickname":nickname,
                                @"sex":sex,
                                @"age":age,
                                @"unionid":unionid,
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/thirdPartyLogin",BaseURL]parameters:paramters complete:complete];
}
/**
 用户注销
 
 @param complete block
 */
+ (void)UserLoginOut:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1};
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
    NSDictionary *paramters = @{@"version":kVersion_1,
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
+(NSURLSessionDownloadTask *)downloadURL:(NSString *) downloadURL progress:(void (^)(NSProgress *downloadProgress))progress destination:(void (^)(NSURL *targetPath))destination failure:(void(^)(NSError *error))faliure{
    
    //1.创建管理者
    LTHTTPSessionManager *manage  = [LTHTTPSessionManager manager];
    
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
    return downloadTask;
}
/**
 获得错题比例
 
 @param json json字符串
 @param complete block
 */
+(void)questionMistakesWithJsonString:(NSString *)json Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"mistakes":json
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/ios/mistakes/private/find",BaseURL]parameters:paramters complete:complete];
}

/**
 展示单张试卷信息
 
 @param userId 用户ID
 @param testPaperId 试卷ID
 @param complete block
 */
+(void)findOneTestPaperInfoWithUserId:(NSNumber *)userId TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"userId":userId ? userId : @"",
                                @"testPaperId":testPaperId
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/testPaper/findOneInfo",BaseURL]parameters:paramters complete:complete];
}

/**
 使用金山查询单词
 
 @param word 单词
 @param complete block
 */
+ (void)searchWordWithWord:(NSString *)word Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"word":word,
                                @"userId":IS_USER_ID ? IS_USER_ID : @""
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/ios/word/public/search",BaseURL]parameters:paramters complete:complete];
}

/**
 用户收藏单词
 
 @param userId 用户ID
 @param word 单词
 @param translate 解释
 @param ph_en_mp3 英式音标mp3音频地址
 @param ph_am_mp3 美式音标mp3音频地址
 @param ph_en     英式音标
 @param ph_am     美式音标
 @param complete block
 */
+ (void)addWordsWithUserId:(NSNumber *)userId Word:(NSString *)word Tranlate:(NSString *)translate Ph_en_mp3:(NSString *)ph_en_mp3 Ph_am_mp3:(NSString *)ph_am_mp3 Ph_am:(NSString *)ph_am Ph_en:(NSString *)ph_en Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"userId":userId,
                                @"word":word,
                                @"translate":translate,
                                @"ph_en_mp3":ph_en_mp3,
                                @"ph_am_mp3":ph_am_mp3,
                                @"ph_en":ph_en,
                                @"ph_am":ph_am
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/ios/words/private/add",BaseURL]parameters:paramters complete:complete];
}


/**
 查找所有收藏有单词
 
 @param userId 用户ID
 @param complete block
 */
+ (void)findWordsWithUserId:(NSNumber *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"userId":userId
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/ios/words/private/find",BaseURL]parameters:paramters complete:complete];
}


/**
 用户删除收藏的单词
 
 @param userId 用户id
 @param word word
 @param complete block
 */
+ (void)removeWordsWithUseId:(NSNumber *)userId Word:(NSString *)word Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters = @{@"version":kVersion_1,
                                @"userId":userId,
                                @"word":word
                                };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/ios/words/private/remove",BaseURL]parameters:paramters complete:complete];
}

/**
 用户打开APP次数
 
 @param userId 用户ID
 @param logintime 登录时间
 @param exittime 登出时间
 @param complete block
 */
+(void)searchLoginCountWithUserId:(NSString *)userId LoginTime:(NSString *)logintime ExitTime:(NSString *)exittime Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 @"logintime":logintime ? logintime : @"",
                                 @"exittime":exittime ? exittime : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchLoginCount",BaseURL]parameters:paramters complete:complete];
}

/**
 统计用户点击事件
 
 @param userId 用户ID
 @param complete block
 */
+ (void)searchClicktimeWithUserId:(NSString *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchOvertime",BaseURL]parameters:paramters complete:complete];
}


/**
 统计用户交卷时间
 
 @param userId 用户ID
 @param complete block
 */
+ (void)searchOvertimeWithUserId:(NSString *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchClicktime",BaseURL]parameters:paramters complete:complete];
}

/**
 统计学习模式访问量
 
 @param userId 用户ID
 @param complete block
 */
+ (void)searchStudyCountWithUserId:(NSString *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchStudyCount",BaseURL]parameters:paramters complete:complete];
}


/**
 统计模拟考试访问量
 
 @param userId 用户ID
 @param complete block
 */
+ (void)searchSimulationCountWithUserId:(NSString *)userId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchSimulationCount",BaseURL]parameters:paramters complete:complete];
}


/**
 统计刷题模式访问量
 
 @param userId 用户ID
 @param complete block
 */
+ (void)searchExerciseCountWithUserId:(NSString *)userId Compelte:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchExerciseCount",BaseURL]parameters:paramters complete:complete];
}

/**
 统计用户试卷收藏量
 
 @param userId 用户ID
 @param testPaperId 试卷ID
 @param complete block
 */
+ (void)searchCollectionCountWithUserId:(NSString *)userId TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 @"testPaperId":testPaperId
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchCollectionCount",BaseURL]parameters:paramters complete:complete];
}

/**
 统计单篇听力用户点击量
 
 @param userId 用户ID
 @param testPaperId 试卷ID
 @param complete block
 */
+ (void)searchListeningCountWithUserId:(NSString *)userId TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 @"testPaperId":testPaperId
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchListeningCount",BaseURL]parameters:paramters complete:complete];
}

/**
 统计用户下载量
 
 @param userId 用户ID
 @param testPaperId 试卷ID
 @param complete block
 */
+ (void)searchDownloadCountWithUserId:(NSString *)userId TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 @"testPaperId":testPaperId
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchDownloadCount",BaseURL]parameters:paramters complete:complete];
}

/**
 统计banner点击量
 
 @param userId 用户ID
 @param bannerId bannerID
 @param complete block
 */
+ (void)searchBannerCountWithUserId:(NSString *)userId BannerId:(NSString *)bannerId Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version":kVersion_1,
                                 @"userId":userId ? userId : @"",
                                 @"bannerId":bannerId
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/searchBannerCount",BaseURL]parameters:paramters complete:complete];
}
/**
 添加订单信息
 
 @param userId 用户id
 @param addressee 收件人
 @param phone 手机号
 @param address 收件地址
 @param complete block
 */
+ (void)addOrderInfoWIthUserId:(NSString *)userId Addressee:(NSString *)addressee Phone:(NSString *)phone Address:(NSString *)address Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"userId":userId,
                                 @"recipient":addressee,
                                 @"phone":phone,
                                 @"address":address,
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/info/addInfo",BaseURL]parameters:paramters complete:complete];
}

/**
 获得二维码
 
 @param complete block
 */
+ (void)getQRWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/qr/getQR",BaseURL]parameters:paramters complete:complete];
}

/**
 验证验证码
 
 @param phone 登录手机号
 @param code 验证码
 @param complete block
 */
+ (void)VerifyCodeWithPhone:(NSString *)phone Code:(NSString *)code Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"phone":phone,
                                 @"code":code,
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/client/public/user/verifyCode",BaseURL]parameters:paramters complete:complete];
}
/**
 微信支付
 
 @param complete block
 */
+ (void)wxPayWithCoodsId:(NSString *)commodity_id UserId:(NSString *)user_id Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"commodity_id":commodity_id,
                                 @"user_id":user_id,
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/weixin/app/wxPay",BaseURL]parameters:paramters complete:complete];
}

/**
 查看所有商品
 
 @param complete block
 */
+ (void)findAllCommodityWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/commodity/findAll",BaseURL]parameters:paramters complete:complete];
}


/**
 我购买的商品
 
 @param user_id 用户ID
 @param complete block
 */
+ (void)findAllMyCommodityWithUserId:(NSString *)user_id Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"user_id":user_id
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/mycommodity/findAll",BaseURL]parameters:paramters complete:complete];
}


/**
 根据类型查看所有课程
 
 @param user_id 用户ID
 @param curriculumType 课程类型 2方法可 3刷题可
 @param complete block
 */
+ (void)findByCurriculumTypeWithUserId:(NSString *)user_id CurriculumType:(NSString *)curriculumType Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"user_id":user_id,
                                 @"curriculumType":curriculumType
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/curriculum/findByCurriculumType",BaseURL]parameters:paramters complete:complete];
}


/**
 查看一个课程
 
 @param user_id 用户ID
 @param curriculum_id 课程ID
 @param complete block
 */
+ (void)findOneCurriculumWithUserId:(NSString *)user_id CurriculumId:(NSString *)curriculum_id Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"user_id":user_id,
                                 @"curriculum_id":curriculum_id
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/curriculum/findOneCurriculum",BaseURL]parameters:paramters complete:complete];
}


/**
 增加更新用户播放历史记录
 
 @param user_id 用户ID
 @param curriculum_id 课程ID
 @param lastTime 上次播放时间
 @param complete block
 */
+ (void)addPlayRecordWithUseId:(NSString *)user_id CurriculumId:(NSString *)curriculum_id LastTime:(NSString *)lastTime Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"user_id":user_id,
                                 @"curriculum_id":curriculum_id,
                                 @"laseTime":lastTime
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/playRecord/private/addPlayRecord",BaseURL]parameters:paramters complete:complete];
}


/**
 查询用户播放历史记录
 
 @param user_id 用户ID
 @param complete block
 */
+ (void)searchPlayRecordWithUserId:(NSString *)user_id Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"user_id":user_id
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/playRecord/private/searchPlayRecord",BaseURL]parameters:paramters complete:complete];
}


/**
 删除用户播放记录
 
 @param ID 播放记录ID
 @param complete block
 */
+ (void)deletePlayRecordWithPlayRecordId:(NSString *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [[LTHTTPSessionManager alloc]init];
    NSDictionary *paramters =  @{@"version_2":kVersion_2,
                                 @"id":ID
                                 };
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@/app/playRecord/private/delectPlayRecord",BaseURL]parameters:paramters complete:complete];
}
@end
