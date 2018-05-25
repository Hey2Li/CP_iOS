//
//  PMAnswerViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMAnswerViewController : UIViewController
@property (nonatomic, copy) NSString *correct;//正确率
@property (nonatomic, strong) NSArray *questionsArray;
@property (nonatomic, copy) NSString *paperName;//试卷题目
@property (nonatomic, copy) NSString *paperSection;//试卷Section
@property (nonatomic, assign) NSInteger mode;//刷题类型
@property (nonatomic, copy) NSString *testPaperId;
@end
