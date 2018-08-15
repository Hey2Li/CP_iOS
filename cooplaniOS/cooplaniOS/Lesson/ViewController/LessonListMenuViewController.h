//
//  LessonListMenuViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonListMenuViewController : UIViewController
@property (nonatomic, copy) NSString *lessonType;
@property (nonatomic, copy) NSString *qr_code;
@property (nonatomic, copy) NSString *commodity_id;
/**
 二维码引导语
 */
@property (nonatomic, copy) NSString *guide;

/**
 二维码名称
 */
@property (nonatomic, copy) NSString *qr_code_name;

@end
