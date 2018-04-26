//
//  answerModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface answerModel : NSObject
@property (nonatomic, copy) NSString *yourAnswer;
@property (nonatomic, copy) NSString *correctAnswer;
@property (nonatomic, copy) NSString *answerDetail;
@property (nonatomic, copy) NSString *questionNum;
@property (nonatomic, copy) NSString *correct;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, assign) BOOL isSelected;
@end
