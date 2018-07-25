//
//  DownloadVideoModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DownloadVideoModel.h"

@implementation DownloadVideoModel
- (instancetype)init{
    if (self = [super init]) {
        [[JRDBMgr shareInstance]registerClazz:[self class]];
    }
    return self;
}
/// 自定义主键的对应的属性 （需要是属性的全名）
+ (NSString *)jr_customPrimarykey {
    return @"videoId"; // 对应property的属性名
}
/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.videoId;
}
@end
