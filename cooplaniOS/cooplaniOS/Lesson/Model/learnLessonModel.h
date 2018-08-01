//
//  learnLessonModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/19.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface learnLessonModel : NSObject
@property (nonatomic, assign) NSInteger course_id;
@property (nonatomic, strong) NSString * course_info;
@property (nonatomic, strong) NSString * course_name;
@property (nonatomic, strong) NSString * course_time;
@property (nonatomic, strong) NSString * last_time;
@property (nonatomic, strong) NSString * burl;
@property (nonatomic, strong) NSString * curl;
@property (nonatomic, strong) NSString * gurl;
@property (nonatomic, assign) NSInteger record_id;
@end
