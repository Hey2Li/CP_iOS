//
//  PaperModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaperModel : NSObject<NSCoding>

/**
 试卷名称
 */
@property (nonatomic, copy) NSString *name;

/**
 试卷编号
 */
@property (nonatomic, copy) NSString *number;

/**
 封面路径
 */
@property (nonatomic, copy) NSString *coverUrl;

/**
 ID
 */
@property (nonatomic, strong) NSNumber *ID;

/**
 图片URL
 */
@property (nonatomic, copy) NSString *pictureUrl;

/**
 试卷详情
 */
@property (nonatomic, copy) NSString *info;

/**
 音频URL
 */
@property (nonatomic, copy) NSString *voiceUrl;

/**
 是否收藏
 */
@property (nonatomic, copy) NSString *collection;

@end
