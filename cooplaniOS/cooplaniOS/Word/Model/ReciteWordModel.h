//
//  ReciteWordModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReciteWordModel : NSObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * word;
@property (nonatomic , copy) NSString              * ex;
@property (nonatomic , copy) NSString              * uk_soundmark;
@property (nonatomic , copy) NSString              * uk_mp3;
@property (nonatomic , copy) NSString              * us_soundmark;
@property (nonatomic , copy) NSString              * us_mp3;
@property (nonatomic , copy) NSString              * result;
@property (nonatomic , copy) NSString              * state;
@property (nonatomic , strong) NSMutableArray <NSString *>              * arr_options;
@property (nonatomic , assign) NSInteger              word_book_id;
@property (nonatomic , assign) NSInteger              score;

/**
 单词出现次数
 */
@property (nonatomic , assign) NSInteger              count;

/**
 例句 中文
 */
@property (nonatomic , copy) NSString              * eg_cn;

/**
 例句 英文
 */
@property (nonatomic , copy) NSString              * eg_en;

/**
 助记
 */
@property (nonatomic , copy) NSString              * mnemonic;

/**
 提示
 */
@property (nonatomic , copy) NSString              * prompt;

/**
 是否收藏
 */
@property (nonatomic , copy) NSString              * collection;

/**
 是否认识
 */
@property (nonatomic , assign) BOOL isKnow;
@property (nonatomic, assign) BOOL isOpen;
@end
