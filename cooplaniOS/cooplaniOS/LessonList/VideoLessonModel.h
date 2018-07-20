//
//  VideoLessonModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoLessonModel : NSObject
@property (nonatomic, strong) NSString * curriculumType;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * permissions;
@property (nonatomic, strong) NSString * time;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * burl;
@property (nonatomic, strong) NSString * curl;
@property (nonatomic, strong) NSString * gurl;
@property (nonatomic, strong) NSString * handouts;
@property (nonatomic, strong) NSString * vocabulary;

@end
