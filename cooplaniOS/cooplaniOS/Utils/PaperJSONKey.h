//
//  PaperJSONKey.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaperJSONKey : NSObject
extern NSString *const kJSONSerialNumber;
extern NSString *const kJSONFullName;
extern NSString *const kJSONAudioName;
extern NSString *const kJSONTimeLimit;
extern NSString *const kJSONVersion;
extern NSString *const kJSONParts;
extern NSString *const kJSONPartTitle;
extern NSString *const kJSONPartType;
extern NSString *const kJSONPartDuration;
extern NSString *const kJSONSections;
extern NSString *const kJSONSectionTitle;
extern NSString *const kJSONSectionType;
extern NSString *const kJSONSectionDirection;
extern NSString *const kJSONSectionDirectionAudioStartTime;
extern NSString *const kJSONSectionDirectionAudioEndTime;
extern NSString *const kJSONPassage;
extern NSString *const kJSONPassageId;
extern NSString *const kJSONPassageAudioStartTime;
extern NSString *const kJSONPassageAudioEndTime;
extern NSString *const kJSONPassageDirection;
extern NSString *const kJSONPassageDirectionAudioStartTime;
extern NSString *const kJSONPassageDirectionAudioEndTime;
extern NSString *const kJSONQuestions;
extern NSString *const kJSONQuestionNo;
extern NSString *const kJSONQuestionAudioStartTime;
extern NSString *const kJSONQuestionAudioEndTime;
extern NSString *const kJSONOptions;
extern NSString *const kJSONAlphabet;
extern NSString *const kJSONText;
extern NSString *const kJSONAnswer;
extern NSString *const kJSONExplanation;
extern NSString *const kVersion_1;//版本号1.0
extern NSString *const kVersion_2;//版本号2.0
extern NSString *const kVersion_2_2;//版本号2.2
extern NSString *const kWordAutoPlay;//单词自动发音
extern NSString *const kQuestionVoice;//答题音效
extern NSString *const kLoadWordHomePageData;//加载单词首页数据
extern NSString *const kLoadLearnedList;//加载已学列表
extern NSString *const kWordNum;//加载单词的个数
extern NSString *const kWordBookId;//词书IDkey
extern NSString *const kHomeReloadData;//刷新home数据
extern NSString *const kOpenTBUser;//打开音词联动的tableview用户交互
extern NSString *const kCloseTBUser;//关掉音词联动的tableview用户交互
extern NSString *const kFindWordIsOpen;//查词页面打开了
extern NSString *const kFindWordIsClose;//查词页面关闭了
extern NSString *const kLoadListenTraining;//加载听力训练页
extern NSString *const kReadOpenQuestion;//选词填空打开题卡
extern NSString *const kClickReadCard;//点击选词填空题卡
@end
