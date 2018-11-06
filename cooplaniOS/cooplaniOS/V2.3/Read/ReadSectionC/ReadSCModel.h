//
//  ReadSCModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/16.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptionsItem :NSObject
@property (nonatomic , copy) NSString              * Alphabet;
@property (nonatomic , copy) NSString              * Text;
@property (nonatomic, assign) BOOL isSelecteOption;
@end


@interface QuestionsItem :NSObject
@property (nonatomic , copy) NSString              * Question;
@property (nonatomic , copy) NSString              * QuestionNumber;
@property (nonatomic , strong) NSArray              * Options;
@property (nonatomic , copy) NSString              * Answer;
@property (nonatomic, copy) NSString *yourAnswer;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, assign) BOOL isSelected;
@end

@interface ReadSCModel : NSObject
@property (nonatomic , copy) NSString              * Question;
@property (nonatomic , copy) NSString              * Passage;
@property (nonatomic , copy) NSString              * PassageId;
@property (nonatomic , strong) NSArray               * Questions;
@property (nonatomic , copy) NSString              * testPaperName;
@end
NS_ASSUME_NONNULL_END
