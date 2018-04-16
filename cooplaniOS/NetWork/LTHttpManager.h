//
//  LTHttpManager.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHTTPSessionManager.h"

#define BaseURL @"http://192.168.1.118:8080/cooplan-rest/client/public/"
@interface LTHttpManager : LTHTTPSessionManager


/**
 查看所有banner跳转页面

 @param complete block
 */
+ (void)FindAllBannerWithComplete:(completeBlock)complete;

/**
 首页查看所有试卷

 @param complete block
 */
+ (void)FindAllWithComplete:(completeBlock)complete;
@end
