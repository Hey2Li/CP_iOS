//
//  LTAlertView.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertResult)(NSInteger index);

@interface LTAlertView : UIView
@property (nonatomic, copy) AlertResult resultIndex;
- (instancetype)initWithTitle:(NSString *)title sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle;
- (void)show;
- (void)dismiss;
@end
