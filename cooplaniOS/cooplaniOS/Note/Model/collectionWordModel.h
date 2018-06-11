//
//  collectionWordModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface collectionWordModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *translate;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) NSString *ph_am_mp3;
@property (nonatomic, copy) NSString *ph_en_mp3;
@property (nonatomic, copy) NSString *ph_am;
@property (nonatomic, copy) NSString *ph_en;
@property (nonatomic, assign) BOOL isOpen;
@end
