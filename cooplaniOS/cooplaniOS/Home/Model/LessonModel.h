//
//  LessonModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonModel : NSObject
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *qr_code;
@property (nonatomic, copy) NSString *guide;
@property (nonatomic, copy) NSString *qr_code_name;
@property (nonatomic, copy) NSString *cover;
@end
