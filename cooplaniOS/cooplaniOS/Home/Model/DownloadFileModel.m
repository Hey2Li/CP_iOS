//
//  DownloadFileModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DownloadFileModel.h"

@implementation DownloadFileModel
- (instancetype)init{
    if (self = [super init]) {
        [[JRDBMgr shareInstance]registerClazz:[self class]];
    }
    return self;
}
/// 自定义主键的对应的属性 （需要是属性的全名）
+ (NSString *)jr_customPrimarykey {
    return @"testPaperId"; // 对应property的属性名
}
/// 自定义主键属性值
- (id)jr_customPrimarykeyValue {
    return self.testPaperId;
}
@end
