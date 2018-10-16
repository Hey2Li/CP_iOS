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
@end

@interface ReadSAOptionsModel : NSObject
@property (nonatomic, copy) NSString *Alphabet;
@property (nonatomic, copy) NSString *Text;
@property (nonatomic, assign) BOOL isSelectedOption;
@end

NS_ASSUME_NONNULL_END
