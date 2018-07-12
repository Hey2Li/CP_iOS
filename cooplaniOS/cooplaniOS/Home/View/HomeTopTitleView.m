//
//  HomeTopTitleView.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeTopTitleView.h"
#import "WZSwitch.h"

@interface HomeTopTitleView()
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@end

@implementation HomeTopTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        UILabel *listenLb = [UILabel new];
//        [self addSubview:listenLb];
//        [listenLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_centerX).offset(-7.5);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
//        listenLb.text = @"听力";
//        listenLb.textAlignment = NSTextAlignmentCenter;
//        listenLb.textColor = UIColorFromRGB(0x444444);
//        listenLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
//        
//        UILabel *lessonLb = [UILabel new];
//        [self addSubview:lessonLb];
//        [lessonLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_centerX).offset(7.5);
//            make.centerY.equalTo(self.mas_centerY);
//        }];
//        lessonLb.text = @"课程";
//        lessonLb.textAlignment = NSTextAlignmentCenter;
//        lessonLb.textColor = UIColorFromRGB(0x444444);
//        lessonLb.font = [UIFont systemFontOfSize:18];
//        
//        self.leftLabel = listenLb;
//        self.rightLabel = lessonLb;
//    }
//    return self;
//}
- (instancetype)initWithLeftTitle:(NSString *)leftTitle RightTitle:(NSString *)rightTitle{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 200, 44);
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
        [self addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX).offset(-7.5);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@25);
            make.width.equalTo(@40);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitle:rightTitle forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0x444444) forState:UIControlStateNormal];
        [self addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(7.5);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@25);
            make.width.equalTo(@40);
        }];
        
        [leftBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.tag = 10001;
        rightBtn.tag = 10002;
        self.leftBtn = leftBtn;
        self.rightBtn = rightBtn;
    }
    return self;
}
- (void)BtnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        if (_tempBtn == nil){
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            _tempBtn = sender;
        }else if (_tempBtn !=nil && _tempBtn == sender){
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        }else if (_tempBtn!= sender && _tempBtn!=nil){
            _tempBtn.selected = NO;
            _tempBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            _tempBtn = sender;
        }
    }];
    if (self.topTitleSwitchBlock) {
        self.topTitleSwitchBlock(sender.tag);
    }
}
- (void)btnClick:(UIButton *)sender{
    [UIView animateWithDuration:0.2 animations:^{
        if (_tempBtn == nil){
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            _tempBtn = sender;
        }else if (_tempBtn !=nil && _tempBtn == sender){
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        }else if (_tempBtn!= sender && _tempBtn!=nil){
            _tempBtn.selected = NO;
            _tempBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            sender.selected = YES;
            sender.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            _tempBtn = sender;
        }
    }];
}
- (CGSize)intrinsicContentSize{
    return CGSizeMake(200, 44);
}
- (void)selectLeft{
    [self btnClick:self.leftBtn];
}
- (void)selectRight{
    [self btnClick:self.rightBtn];
}
@end
