//
//  BuyLessonTableHeaderView.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "BuyLessonTableHeaderView.h"

@interface BuyLessonTableHeaderView()
@property (nonatomic, strong) UILabel *leftPointLb;
@property (nonatomic, strong) UILabel *centerPointLb;
@property (nonatomic, strong) UILabel *rightPointLb;
@property (nonatomic, strong) UIImageView *leftLineImg;
@property (nonatomic, strong) UIImageView *rightLineImg;
@end

@implementation BuyLessonTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xD76F67);
        UILabel *leftLb = [UILabel new];
        [leftLb setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:leftLb];
        [leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_centerX).offset(-120);
            make.height.equalTo(@10);
            make.width.equalTo(@10);
            make.top.equalTo(self.mas_top).offset(30);
        }];
        [leftLb.layer setCornerRadius:5];
        [leftLb.layer setMasksToBounds:YES];
        
        UILabel *centerLb = [UILabel new];
        [centerLb setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [self addSubview:centerLb];
        [centerLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(leftLb);
            make.height.equalTo(leftLb);
            make.width.equalTo(leftLb);
        }];
        [centerLb.layer setCornerRadius:5];
        [centerLb.layer setMasksToBounds:YES];

        UILabel *rightLb = [UILabel new];
        [rightLb setBackgroundColor:UIColorFromRGB(0xcccccc)];
        [self addSubview:rightLb];
        [rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_centerX).offset(120);
            make.centerY.equalTo(leftLb);
            make.height.equalTo(leftLb);
            make.width.equalTo(leftLb);
        }];
        [rightLb.layer setCornerRadius:5];
        [rightLb.layer setMasksToBounds:YES];
        
        UILabel *addressLb = [UILabel new];
        addressLb.text = @"收货地址";
        addressLb.font = [UIFont systemFontOfSize:12];
        [addressLb setTextColor:UIColorFromRGB(0xffffff)];
        [self addSubview:addressLb];
        [addressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(leftLb);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
            make.top.equalTo(centerLb.mas_bottom).offset(19);
        }];
        
        UILabel *buyLb = [UILabel new];
        buyLb.text = @"付款购买";
        buyLb.font = [UIFont systemFontOfSize:12];
        [buyLb setTextColor:UIColorFromRGB(0xffffff)];
        [self addSubview:buyLb];
        [buyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
            make.top.equalTo(centerLb.mas_bottom).offset(19);
        }];
        
        UILabel *learnLessonLb = [UILabel new];
        learnLessonLb.text = @"学习课程";
        learnLessonLb.font = [UIFont systemFontOfSize:12];
        [learnLessonLb setTextColor:UIColorFromRGB(0xffffff)];
        [self addSubview:learnLessonLb];
        [learnLessonLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(rightLb);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
            make.top.equalTo(rightLb.mas_bottom).offset(19);
        }];
        
        UIImageView *leftLineImageView = [UIImageView new];
        [self addSubview:leftLineImageView];
        [leftLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLb.mas_right).offset(20);
            make.right.equalTo(centerLb.mas_left).offset(-20);
            make.height.equalTo(@2);
            make.centerY.equalTo(leftLb.mas_centerY);
        }];
        leftLineImageView.image = [UIImage imageNamed:@"LineG"];
        
        UIImageView *rightLineImageView = [UIImageView new];
        [self addSubview:rightLineImageView];
        [rightLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(centerLb.mas_right).offset(20);
            make.right.equalTo(rightLb.mas_left).offset(-20);
            make.height.equalTo(@2);
            make.centerY.equalTo(leftLb.mas_centerY);
        }];
        rightLineImageView.image = [UIImage imageNamed:@"LineG"];

        
        self.leftPointLb = leftLb;
        self.centerPointLb = centerLb;
        self.rightPointLb = rightLb;
        self.leftLineImg = leftLineImageView;
        self.rightLineImg = rightLineImageView;
    }
    return self;
}
- (void)selectIndex:(HeaderSelectIndex)index{
    if (index == HeaderSelectAddress) {
        self.leftPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.centerPointLb.backgroundColor = UIColorFromRGB(0xcccccc);
        self.rightPointLb.backgroundColor = UIColorFromRGB(0xcccccc);
        self.leftLineImg.image = [UIImage imageNamed:@"LineG"];
        self.rightLineImg.image = [UIImage imageNamed:@"LineG"];
    }else if (index == HeaderSelectBuy){
        self.leftPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.centerPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.rightPointLb.backgroundColor = UIColorFromRGB(0xcccccc);
        self.leftLineImg.image = [UIImage imageNamed:@"LineW"];
        self.rightLineImg.image = [UIImage imageNamed:@"LineG"];
    }else if (index == HeaderSelectLearn){
        self.leftPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.centerPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.rightPointLb.backgroundColor = UIColorFromRGB(0xffffff);
        self.leftLineImg.image = [UIImage imageNamed:@"LineW"];
        self.rightLineImg.image = [UIImage imageNamed:@"LineW"];
    }
}
@end
