//
//  PaperJSONKey.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaperJSONKey.h"

@implementation PaperJSONKey
NSString *const kJSONSerialNumber = @"PaperSerialNumber";
NSString *const kJSONFullName = @"PaperFullName";
NSString *const kJSONAudioName = @"PaperAudioName";
NSString *const kJSONTimeLimit = @"TimeLimit";
NSString *const kJSONVersion = @"Version";
NSString *const kJSONParts = @"Parts";
NSString *const kJSONPartTitle = @"PartTitle";
NSString *const kJSONPartType = @"PartType";
NSString *const kJSONPartDuration = @"PartDuration";
NSString *const kJSONSections = @"Sections";
NSString *const kJSONSectionTitle = @"SectionTitle";
NSString *const kJSONSectionType = @"SectionType";
NSString *const kJSONSectionDirection = @"SectionDirection";
NSString *const kJSONSectionDirectionAudioStartTime = @"SectionDirectionAudioStartTime";
NSString *const kJSONSectionDirectionAudioEndTime = @"SectionDirectionAudioEndTime";
NSString *const kJSONPassage = @"Passage";
NSString *const kJSONPassageId = @"PassageId";
NSString *const kJSONPassageAudioStartTime = @"PassageAudioStartTime";
NSString *const kJSONPassageAudioEndTime = @"PassageAudioEndTime";
NSString *const kJSONPassageDirection = @"PassageDirection";
NSString *const kJSONPassageDirectionAudioStartTime = @"PassageDirectionAudioStartTime";
NSString *const kJSONPassageDirectionAudioEndTime = @"PassageDirectionAudioEndTime";
NSString *const kJSONQuestions = @"Questions";
NSString *const kJSONQuestionNo = @"QuestionNo";
NSString *const kJSONQuestionAudioStartTime = @"QuestionAudioStartTime";
NSString *const kJSONQuestionAudioEndTime = @"QuestionAudioEndTime";
NSString *const kJSONOptions = @"Options";
NSString *const kJSONAlphabet = @"Alphabet";
NSString *const kJSONText = @"Text";
NSString *const kJSONAnswer = @"Answer";
NSString *const kJSONExplanation = @"Explanation";
NSString *const kVersion_1 = @"1.0.0";
NSString *const kVersion_2 = @"2.0";
NSString *const kVersion_2_2 = @"2.2.0";
NSString *const kWordAutoPlay = @"wordAutoPlay";
NSString *const kQuestionVoice = @"questionVoice";//答题音效
NSString *const kLoadWordHomePageData = @"loadWordHomepageData";//加载单词首页数据
NSString *const kLoadLearnedList = @"loadLearnedList";//加载已学列表
NSString *const kWordNum = @"beiwordnum";//加载单词的个数
NSString *const kWordBookId = @"wordbookId";//词书IDkey
NSString *const kHomeReloadData = @"homereloaddata";//刷新home数据
NSString *const kOpenTBUser = @"kOpenTBUser";//打开音词联动的tableview用户交互
NSString *const kCloseTBUser = @"kCloseTBUser";//关掉音词联动的tableview用户交互
NSString *const kFindWordIsOpen = @"kFindWordIsOpen";//查词页面打开了
NSString *const kFindWordIsClose = @"kFindWordIsClose";//查词页面关闭了
NSString *const kLoadListenTraining = @"kLoadListenTraining";//加载听力训练页
NSString *const kReadOpenQuestion = @"kReadOpenQuestion";//选词填空打开题卡
NSString *const kClickReadCard = @"kClickReadCard";//点击选词填空题卡
@end
