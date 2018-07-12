//
//  HomeTopTitleView.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^topTitleSwitch)(NSInteger index);

@interface HomeTopTitleView : UIView
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, copy) topTitleSwitch topTitleSwitchBlock;

- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle;

- (void)selectLeft;
- (void)selectRight;
@end
