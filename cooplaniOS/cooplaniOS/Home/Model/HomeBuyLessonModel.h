//
//  HomeBuyLessonModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeBuyLessonModel : NSObject
@property (nonatomic , assign) NSInteger              advertising_id;
@property (nonatomic , copy) NSString              * course_name;
@property (nonatomic , copy) NSString              * indate;
@property (nonatomic , copy) NSString              * info;
@property (nonatomic , copy) NSString              * img;
@property (nonatomic , copy) NSString              * taobao_id;
@property (nonatomic , strong) NSArray <NSString *>              * arr_selling_point;
@end

NS_ASSUME_NONNULL_END
