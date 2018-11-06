//
//  ReadSAModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/15.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadSAModel : NSObject
@property (nonatomic, copy) NSString *Direction;
@property (nonatomic, copy) NSString *Question;
@property (nonatomic, copy) NSString *Passage;
@property (nonatomic, strong) NSArray *Options;
@property (nonatomic, strong) NSArray *Answer;
@property (nonatomic, copy) NSString *testPaperName;

@end

@interface ReadSAOptionsModel : NSObject
@property (nonatomic, copy) NSString *Alphabet;
@property (nonatomic, copy) NSString *Text;
@property (nonatomic, assign) BOOL isSelectedOption;
@end

@interface ReadSAAnswerModel : NSObject
@property (nonatomic , copy) NSString              * Alphabet;
@property (nonatomic , copy) NSString              * Explain;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *yourAnswer;
@end


NS_ASSUME_NONNULL_END
