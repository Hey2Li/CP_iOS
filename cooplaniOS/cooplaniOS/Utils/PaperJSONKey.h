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
extern NSString *const kVersion_1;
extern NSString *const kVersion_2;
extern NSString *const kWordAutoPlay;//单词自动发音
extern NSString *const kQuestionVoice;//答题音效
extern NSString *const kLoadWordHomePageData;//加载单词首页数据
extern NSString *const kLoadLearnedList;//加载已学列表
@end
