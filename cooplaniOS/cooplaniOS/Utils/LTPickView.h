//
//  LTPickView.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^stringResultBlock)(NSString *str);
@interface LTPickView : UIView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *resultStr;
@property (nonatomic, copy) stringResultBlock block;

+ (void)initWithPickView:(NSArray *)array InView:(UIView *)view ResultStr:(stringResultBlock)block;
@end
