//
//  CheckWordView.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckWordView : UIView
@property (nonatomic, copy) NSString *word;
@property (nonatomic, copy) void (^closeBlock)(void);
@end
