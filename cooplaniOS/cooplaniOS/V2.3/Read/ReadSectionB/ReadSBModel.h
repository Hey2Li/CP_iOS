//
//  ReadSBModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/16.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadSBModel : NSObject
@property (nonatomic, copy) NSString *Question;
@property (nonatomic, strong) NSArray *Options;
@property (nonatomic, strong) NSArray *Passage;
@property (nonatomic, copy) NSString *testPaperName;
@end

@interface ReadSBPassageModel : NSObject
@property (nonatomic , copy) NSString              * Alphabet;
@property (nonatomic , copy) NSString              * Text;
@end

@interface ReadSBOptionsModel : NSObject
@property (nonatomic , copy) NSString              * No;
@property (nonatomic , copy) NSString              * Text;
@property (nonatomic , copy) NSString              * Answer;
@property (nonatomic , copy) NSString              * Explain;
@property (nonatomic , copy) NSString              *yourAnswer;
@property (nonatomic , assign) BOOL              isCorrect;
@property (nonatomic , assign) BOOL              isSelected;
@end
NS_ASSUME_NONNULL_END
