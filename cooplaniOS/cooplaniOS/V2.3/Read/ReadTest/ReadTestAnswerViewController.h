//
//  ReadTestAnswerViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/19.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSCModel.h"
#import "ReadSBModel.h"
#import "ReadSAModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadTestAnswerViewController : UIViewController
@property (nonatomic, copy) NSString *correct;//正确率
@property (nonatomic, strong) NSArray *questionsArray;
@property (nonatomic, copy) NSString *paperName;//试卷题目
@property (nonatomic, copy) NSString *paperSection;//试卷Section
@property (nonatomic, assign) NSInteger mode;//刷题类型
@property (nonatomic, copy) NSString *testPaperId;
@property (nonatomic, copy) NSString *userTime;
@property (nonatomic, strong) ReadSAModel *rsaModel;
@property (nonatomic, strong) ReadSBModel *rsbModel;
@property (nonatomic, strong) ReadSCModel *rscModel;
@end

NS_ASSUME_NONNULL_END
