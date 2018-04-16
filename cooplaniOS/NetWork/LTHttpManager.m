//
//  LTHttpManager.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTHttpManager.h"

@implementation LTHttpManager
+ (void)FindAllBannerWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"versions":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@banner/findAllBanner",BaseURL] parameters:paramters complete:complete];
}
+ (void)FindAllWithComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSDictionary *paramters = @{@"versions":[Tool getAppVersion]};
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@testPaper/findAll",BaseURL]parameters:paramters complete:complete];
}

@end
