//
//  SubTestAnswerViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubTestAnswerViewController : UIViewController
@property (nonatomic, copy) NSString *correct;//正确率
@property (nonatomic, strong) NSArray *questionsArray;
@property (nonatomic, copy) NSString *paperName;//试卷题目
@property (nonatomic, copy) NSString *paperSection;//试卷Section
@property (nonatomic, assign) NSInteger mode;//刷题类型
@property (nonatomic, copy) NSString *testPaperId;
@property (nonatomic, copy) NSString *sectionType;

@end

NS_ASSUME_NONNULL_END
