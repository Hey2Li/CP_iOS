//
//  LTHttpManager.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHTTPSessionManager.h"

#define BaseURL @"http://192.168.0.46:8080/cooplan-app"
//app.cooplan.cn
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
+ (void)FindAllWithUseId:(NSNumber *)userid Complete:(completeBlock)complete;

/**
 查询一张试卷的信息(首页点击试卷获取试卷)
 
 @param ID 试卷的id
 @param complete block
 */
+ (void)findOneTestPaperWithID:(NSNumber *)ID Complete:(completeBlock)complete;

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


/**
 用户注销

 @param complete block
 */
+ (void)UserLoginOut:(completeBlock)complete;

/**
 我的笔记收藏句子

 @param userId 用户ID
 @param sentenceEN 英文句子
 @param sentenceCN 中文翻译
 @param complete block
 */
+ (void)collectionSectenceWithUserId:(NSString *)userId SectenceEN:(NSString *)sentenceEN SentenceCN:(NSString *)sentenceCN TestPaperName:(NSString *)testPaperName Complete:(completeBlock)complete;


/**
 用户删除收藏句子笔记(用户登录后才可操作)

 @param ID 收藏的句子id
 @param complete block
 */
+ (void)deleteSentenceNoteWithId:(NSNumber *)ID WithComplete:(completeBlock)complete;


/**
 用户以时间降序查询收藏的句子笔记(用户登录后才可操作)

 @param userId 用户id
 @param complete block
 */
+ (void)findSectenceNoteWIthUserId:(NSNumber *)userId Complete:(completeBlock)complete;
/**
 用户收藏试卷(用户登录后才可操作)

 @param user_id 用户id
 @param testPaperId 试卷的id
 @param complete block
 */
+ (void)collectionTestPaperWithUserId:(NSNumber *)user_id TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete;


/**
 用户删除收藏试卷(用户登录后才可操作)

 @param ID 收藏表中的id
 @param complete block
 */
+ (void)deleteCollectionTestPaperWithId:(NSNumber *)ID Complete:(completeBlock)complete;


/**
 用户查看所有收藏试卷(用户登录后才可操作)

 @param userId 用户id
 */
+ (void)findAllCollectionTestPaperWithUserId:(NSNumber *)userId Complete:(completeBlock)complete;

/**
 默认登录 用户在关闭app再打开要重新验证

 @param userId 用户id
 @param complete block
 */
+(void)UserDefaultLoginWithUserId:(NSNumber *)userId Complete:(completeBlock)complete;

/**
 *  下载文件
 *
 *  @param downloadURL  下载链接
 *  @param success 请求结果
 *  @param faliure 错误信息
 */
+(NSURLSessionDownloadTask *)downloadURL:(NSString *) downloadURL progress:(void (^)(NSProgress *downloadProgress))progress destination:(void (^)(NSURL *targetPath))destination failure:(void(^)(NSError *error))faliure;

/**
 获得错题比例

 @param json json字符串
 @param complete block
 */
+(void)questionMistakesWithJsonString:(NSString *)json Complete:(completeBlock)complete;


/**
 展示单张试卷信息

 @param userId 用户ID
 @param testPaperId 试卷ID
 @param complete block
 */
+(void)findOneTestPaperInfoWithUserId:(NSNumber *)userId TestPaperId:(NSNumber *)testPaperId Complete:(completeBlock)complete;


/**
 使用金山查询单词

 @param word 单词
 @param complete block
 */
+ (void)searchWordWithWord:(NSString *)word Complete:(completeBlock)complete;


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
+ (void)addWordsWithUserId:(NSNumber *)userId Word:(NSString *)word Tranlate:(NSString *)translate Ph_en_mp3:(NSString *)ph_en_mp3 Ph_am_mp3:(NSString *)ph_am_mp3 Ph_am:(NSString *)ph_am Ph_en:(NSString *)ph_en Complete:(completeBlock)complete;


/**
 查找所有收藏有单词

 @param userId 用户ID
 @param complete block
 */
+ (void)findWordsWithUserId:(NSNumber *)userId Complete:(completeBlock)complete;


/**
 用户删除收藏的单词
 
 @param userId 用户id
 @param word word
 @param complete block
 */
+ (void)removeWordsWithUseId:(NSNumber *)userId Word:(NSString *)word Complete:(completeBlock)complete;
@end
