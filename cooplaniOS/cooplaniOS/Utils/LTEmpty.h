//
//  LTEmpty.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LYEmptyView.h"

typedef void(^reloadDataBlock)(void);

@interface LTEmpty : LYEmptyView

/**
 没有网络状态

 @return @”“
 */
+ (instancetype)NoNetworkEmpty:(reloadDataBlock)reload;

/**
 没有数据

 @return @""
 */
+ (instancetype)NoDataEmpty;

/**
 没有数据

 @param message 提示语
 @return @“”
 */
+ (instancetype)NoDataEmptyWithMessage:(NSString *)message;
@end
