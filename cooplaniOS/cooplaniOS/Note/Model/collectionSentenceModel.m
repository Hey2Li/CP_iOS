//
//  collectionSentenceModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "collectionSentenceModel.h"

@implementation collectionSentenceModel
- (instancetype)init{
    if (self = [super init]) {
        [[JRDBMgr shareInstance]registerClazz:[self class]];
    }
    return self;
}
@end
