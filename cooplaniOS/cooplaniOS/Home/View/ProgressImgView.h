//
//  ProgressImgView.h
//  cooplaniOS
//
//  Created by Lee on 2018/6/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressImgView : UIView
- (void)drawProgress:(CGFloat )progress;
@property(assign,nonatomic)CGFloat startValue;
@property(assign,nonatomic)CGFloat lineWidth;
@property(assign,nonatomic)CGFloat value;
@property(strong,nonatomic)UIColor *lineColr; 
@end
