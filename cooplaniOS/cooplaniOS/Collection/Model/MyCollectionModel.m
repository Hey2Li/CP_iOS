//
//  MyCollectionModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyCollectionModel.h"

@implementation MyCollectionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
