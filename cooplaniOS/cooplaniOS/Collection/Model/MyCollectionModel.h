//
//  MyCollectionModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCollectionModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString * info;
@property (nonatomic, strong) NSString * lic;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * number;
@property (nonatomic, assign) NSInteger testPaperId;
@property (nonatomic, strong) NSString * testPaperUrl;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * voiceUrl;
@end
