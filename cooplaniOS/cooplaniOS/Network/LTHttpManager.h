//
//  LTHttpManager.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHTTPSessionManager.h"
#import "PaperJSONKey.h"

#define BaseURL @"http://192.168.0.25:8080/cooplan-app"
//http://192.168.0.101:8080/cooplan-app
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
 @param unionid unionid
 @param complete block
 */
+ (void)thirdPartyLoginWithOpenId:(NSString *)openId IdentityType:(NSString *)identityType Token:(NSString *)token TokenTime:(NSString *)tokenTime HeadPortrait:(NSString *)headPortrait NickName:(NSString *)nickname Sex:(NSString *)sex age:(NSString *)age UnionId:(NSString *)unionid Complete:(completeBlock)complete;


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

/**
 添加订单信息

 @param userId 用户id
 @param addressee 收件人
 @param phone 手机号
 @param address 收件地址
 @param complete block
 */
+ (void)addOrderInfoWIthUserId:(NSString *)userId Addressee:(NSString *)addressee Phone:(NSString *)phone Address:(NSString *)address CommodityId:(NSString *)commodity_id Complete:(completeBlock)complete;

/**
 获得二维码

 @param complete block
 */
+ (void)getQRWithComplete:(completeBlock)complete;


/**
 验证验证码

 @param phone 登录手机号
 @param code 验证码
 @param complete block
 */
+ (void)VerifyCodeWithPhone:(NSString *)phone Code:(NSString *)code Complete:(completeBlock)complete;

/**
 微信支付

 @param complete block
 */
+ (void)wxPayWithCoodsId:(NSString *)commodity_id OrderId:(NSString *)order_id UserId:(NSString *)user_id Complete:(completeBlock)complete;

/**
 查看所有商品

 @param complete block
 */
+ (void)findAllCommodityWithComplete:(completeBlock)complete;


/**
 我购买的商品

 @param user_id 用户ID
 @param complete block
 */
+ (void)findAllMyCommodityWithUserId:(NSString *)user_id Complete:(completeBlock)complete;


/**
 根据类型查看所有课程

 @param user_id 用户ID
 @param curriculumType 课程类型 2方法可 3刷题可
 @param complete block
 */
+ (void)findByCurriculumTypeWithUserId:(NSString *)user_id CurriculumType:(NSString *)curriculumType Complete:(completeBlock)complete;


/**
 查看一个课程

 @param user_id 用户ID
 @param curriculum_id 课程ID
 @param complete block
 */
+ (void)findOneCurriculumWithUserId:(NSString *)user_id CurriculumId:(NSString *)curriculum_id Complete:(completeBlock)complete;


/**
 增加更新用户播放历史记录

 @param user_id 用户ID
 @param curriculum_id 课程ID
 @param lastTime 上次播放时间
 @param complete block
 */
+ (void)addPlayRecordWithUseId:(NSString *)user_id CurriculumId:(NSString *)curriculum_id LastTime:(NSString *)lastTime Complete:(completeBlock)complete;


/**
 查询用户播放历史记录

 @param user_id 用户ID
 @param complete block
 */
+ (void)searchPlayRecordWithUserId:(NSString *)user_id Commodity_id:(NSString *)commodity_id Complete:(completeBlock)complete;


/**
 删除用户播放记录

 @param ID 播放记录ID
 @param complete block
 */
+ (void)deletePlayRecordWithPlayRecordId:(NSString *)ID Complete:(completeBlock)complete;


/**
 修改订单状态 只修改为2状态

 @param ID 订单ID
 @param complete block
 */
+ (void)changeOrderTypeWithOrderId:(NSString *)ID Complete:(completeBlock)complete;

/**
 查看用户的手机号

 @param user_id 用户ID
 @param complete block
 */
+ (void)findPhoneByUserId:(NSString *)user_id Complete:(completeBlock)complete;

/**
 验证验证码修改手机号

 @param user_id 用户ID
 @param complete block
 */
+ (void)verifyCodeUpdatePhoneWithUserId:(NSString *)user_id Phone:(NSString *)phone Code:(NSString *)code Complete:(completeBlock)complete;


/**
 获取用户需要背的单词

 @param user_id 用户id
 @param word_book_id 词书id
 @param num 记忆个数
 @param complete block
 */
+ (void)findAllAppWordWithUser_id:(NSString *)user_id WordbookId:(NSString *)word_book_id Num:(NSString *)num Complete:(completeBlock)complete;


/**
 查看背单词的进度 url: /app/wb/getReciteWordData

 @param user_id 用户ID
 @param word_book_id 词书ID
 @param complete block
 */
+ (void)getReciteWordProgressWithUser_id:(NSString *)user_id WordbookId:(NSString *)word_book_id Complete:(completeBlock)complete;


/**
 获取词书剩余单词的个数 url: /app/wb/getResidueWordNum

 @param user_id 学生ID
 @param word_book_id 词书ID
 @param complete block
 */
+ (void)getResidueWordNumWithUser_id:(NSString *)user_id Wordbookid:(NSString *)word_book_id Complete:(completeBlock)complete;


/**
获得所有词书 url: /app/wb/getAllWordBook

 @param complete block
 */
+ (void)getAllWordbookComplete:(completeBlock)complete;


/**
 保存背单词的数据 /app/oldWord/saveOldWord

 @param data 单词数据
 @param complete block
 */
+ (void)saveOldWordWithwordData:(NSString *)data Complete:(completeBlock)complete;


/**
 查询单词状态 ycj 8/8

 @param user_id 用户ID
 @param word_book_id  词书ID
 @param type 状态
 @param page_num page_num
 @param complete 1（熟练>100) ;2（错误<-100）;3（记忆中(-100~100)）
 */
+ (void)searchOldWordWithUserId:(NSString *)user_id WordBookId:(NSString *)word_book_id Type:(NSNumber *)type PageNum:(NSNumber *)page_num Complete:(completeBlock)complete;


/**
 查询所有词书

 @param user_id 用户ID
 @param complete block
 */
+ (void)findAllWordBookWithUser_id:(NSString *)user_id Complete:(completeBlock)complete;


/**
 查看用户打开的词书

 @param user_id 用户id
 @param complete block
 */
+ (void)findOpenBookWithUser_id:(NSString *)user_id Complete:(completeBlock)complete;


/**
 修改用户打开的词书
url: /client/public/user/modifyOpenBook
 @param user_id 用户ID
 @param open_book 词书ID
 @param complete block
 */
+ (void)changeUserOpenWordbookWithUser_id:(NSString *)user_id BookId:(NSString *)open_book Complete:(completeBlock)complete;


/**
 查询展示的广告, 只查询状态为1的 mlg 9/12

 @param complete block
 */
+ (void)showHomeAdWithComplete:(completeBlock)complete;


/**
 添加一个专项训练 mlg 9/21url: /app/specialized/addSpecialized
 

 @param user_id 用户ID
 @param testpaper_id 试卷ID
 @param type 1:四级听力专项训练
 @param testpaper_type 4-A 4-B 4-C
 @param complete block
 */
+ (void)addOnlyTestWithUserId:(NSString *)user_id TestPaperId:(NSNumber *)testpaper_id Type:(NSString *)type Testpaper_type:(NSString *)testpaper_type Complete:(completeBlock)complete;


/**
 获取一个专项训练 mlg 9/21url: /app/specialized/getOneNewSpecialized

 @param user_id 用户ID
 @param type 4-A:sectionA;4-B:sectionB; 4-C:sectionC 4-D 段落匹配 4-E选词填空 4-F 阅读1 G 阅读2
 @param testpaper_kind 0T:完整的听力试卷;1T:听力专项训练 1Y 专项训练阅读
 2018/9-25mlg 改
 @param testpaper_type  4-A:sectionA;4-B:sectionB; 4-C:sectionC 4-D 段落匹配 4-E选词填空 4-F 阅读1 G 阅读2
 @param complete block
 */
+ (void)getOneNewTestWithUserId:(NSString *)user_id Type:(NSString *)type Testpaper_kind:(NSString *)testpaper_kind Testpaper_type:(NSString *)testpaper_type Complete:(completeBlock)complete;


/**
 查看用户学习的专项训练的个数,及原数据个数 mlg 9/21

 @param user_id 用户ID
 @param type 1:专项训练
 @param testpaper_kind 0T:完整的听力试卷;1T:听力专项训练
 2018/9-25mlg 改
 @param complete block
 2018/9-25mlg 改
 */
+ (void)getCategoryTestNumWithUserId:(NSString *)user_id Type:(NSString *)type Testpaper_kind:(NSString *)testpaper_kind Complete:(completeBlock)complete;

/**
 根据课程类型查询该类型下的所有课程 听读写译 mlg 9/12
 
 @param course_type 课程类型1:听力,2:读,3:写,4.译
 @param complete block
 */
+ (void)getCategoryLessonWithCourse_type:(NSString *)course_type Complete:(completeBlock)complete;
@end
