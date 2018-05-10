//
//  TestPaperModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestPaperModel : NSObject
@property (nonatomic, copy) NSString *PaperSerialNumber;
@property (nonatomic, copy) NSString *PaperFullName;
@property (nonatomic, copy) NSString *PaperAudioName;
@property (nonatomic, copy) NSString *TimeLimit;
@property (nonatomic, copy) NSString *Version;
@property (nonatomic, strong) NSArray *Parts;
@end

@interface PartsModel: NSObject
@property (nonatomic, copy) NSString *PartTitle;
@property (nonatomic, copy) NSString *PartType;
@property (nonatomic, copy) NSString *PartDuration;
@property (nonatomic, strong) NSArray *Sections;
@end

@interface SectionsModel: NSObject
@property (nonatomic, copy) NSString *SectionTitle;
@property (nonatomic, copy) NSString *SectionType;
@property (nonatomic, copy) NSString *SectionDirection;
@property (nonatomic, copy) NSString *SectionDirectionAudioStartTime;
@property (nonatomic, copy) NSString *SectionDirectionAudioEndTime;
@property (nonatomic, strong) NSMutableArray *Passage;
@end

@interface PassageModel: NSObject
@property (nonatomic, copy) NSString *PassageId;
@property (nonatomic, copy) NSString *PassageAudioStartTime;
@property (nonatomic, copy) NSString *PassageAudioEndTime;
@property (nonatomic, copy) NSString *PassageDirection;
@property (nonatomic, copy) NSString *PassageDirectionAudioStartTime;
@property (nonatomic, copy) NSString *PassageDirectionAudioEndTime;
@property (nonatomic, strong) NSMutableArray *Questions;
@end

@interface QuestionsModel: NSObject
@property (nonatomic, copy) NSString *PassageId;
@property (nonatomic, copy) NSString *PassageAudioStartTime;
@property (nonatomic, copy) NSString *PassageAudioEndTime;
@property (nonatomic, copy) NSString *PassageDirection;
@property (nonatomic, copy) NSString *PassageDirectionAudioStartTime;
@property (nonatomic, copy) NSString *PassageDirectionAudioEndTime;
@property (nonatomic, copy) NSString *QuestionNo;
@property (nonatomic, copy) NSString *QuestionAudioStartTime;
@property (nonatomic, copy) NSString *QuestionAudioEndTime;
@property (nonatomic, strong) NSArray *Options;
@property (nonatomic, copy) NSString *Answer;
@property (nonatomic, copy) NSString *Explanation;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *youAnswer;
@end

@interface OptionsModel: NSObject
@property (nonatomic, copy) NSString *Alphabet;
@property (nonatomic, copy) NSString *Text;
@end

