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
@end
