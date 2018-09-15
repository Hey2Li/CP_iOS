//
//  TestModeBottomView.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestModeBottomView.h"

@implementation TestModeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *donePaperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [donePaperBtn setTitle:@"交卷" forState:UIControlStateNormal];
        [donePaperBtn setTitleColor:UIColorFromRGB(0xCCCCCC) forState:UIControlStateNormal];
        [donePaperBtn setBackgroundColor:UIColorFromRGB(0xFFFFFF)];
        [donePaperBtn.layer setCornerRadius:10 ];
        [donePaperBtn.layer setBorderWidth:1.0f];
        [donePaperBtn.layer setBorderColor:UIColorFromRGB(0xCCCCCC).CGColor];
        [self addSubview:donePaperBtn];
        [donePaperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@102);
            make.height.equalTo(@26);
        }];
        
        UILabel *leftTimeLb = [[UILabel alloc]init];
        leftTimeLb.text = @"00:00";
        leftTimeLb.font = [UIFont systemFontOfSize:12];
        leftTimeLb.textColor = UIColorFromRGB(0xCCCCCC);
        leftTimeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:leftTimeLb];
        [leftTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(30);
            make.centerY.equalTo(donePaperBtn);
            make.height.equalTo(@20);
        }];
        
        UILabel *questionIndexLb = [[UILabel alloc]init];
        questionIndexLb.textColor = UIColorFromRGB(0xCCCCCC);
        questionIndexLb.font = [UIFont systemFontOfSize:12];
        questionIndexLb.text = @"";
        questionIndexLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:questionIndexLb];
        [questionIndexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(donePaperBtn);
            make.height.equalTo(@20);
            make.right.equalTo(self.mas_right).offset(-30);
        }];
        
        UILabel *topLb = [[UILabel alloc]init];
        [topLb setBackgroundColor:UIColorFromRGB(0xCCCCCC)];
        [self addSubview:topLb];
        [topLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@0.1);
        }];
        [self.layer setShadowOffset:CGSizeMake(-1, -1)];
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.2];
        [self.layer setMasksToBounds:NO];
        
        self.questionIndexLb = questionIndexLb;
        self.donePapersBtn = donePaperBtn;
        self.leftTimeLb = leftTimeLb;
    }
    return self;
}
@end
