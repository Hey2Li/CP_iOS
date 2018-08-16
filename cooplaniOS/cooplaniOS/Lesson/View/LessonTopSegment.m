//
//  LessonTopSegment.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonTopSegment.h"

@interface LessonTopSegment()
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UIButton *tempBtn;
@end

@implementation LessonTopSegment

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithTitles:(NSArray *)titles AndSelectColor:(UIColor *)color{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        CGFloat segmentWith = SCREEN_WIDTH/titles.count;
        CGFloat segmentHeight = 40;
        for (int i = 0; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [btn setTitleColor:color forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 1000 + i;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(segmentWith * i);
                make.height.mas_equalTo(segmentHeight);
                make.width.mas_equalTo(segmentWith);
                make.top.equalTo(self.mas_top);
            }];
        }
        
        UILabel *bottomLine = [UILabel new];
        bottomLine.backgroundColor = color;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.equalTo(@2);
            make.width.equalTo(@80);
            make.centerX.equalTo(self.mas_left).offset(segmentWith/2);
        }];
        self.bottomLine = bottomLine;
        
        UILabel *line = [UILabel new];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
        [line setBackgroundColor:UIColorFromRGB(0xcccccc)];
//        line.backgroundColor = [UIColor whiteColor];
//        line.layer.shadowColor = [UIColor blackColor].CGColor;
//        line.layer.shadowOffset = CGSizeMake(3, 0);
//        line.layer.shadowOpacity = 0.4;
//        [line.layer setMasksToBounds:NO];
//        line.clipsToBounds = NO;
        UIButton *btn = (UIButton*)[self viewWithTag:1000];
        [self changeSegment:btn];
    }
    return self;
}
- (void)changeSegment:(UIButton *)sender{
    if (_tempBtn == nil){
        sender.selected = YES;
        _tempBtn = sender;
    }else if (_tempBtn !=nil && _tempBtn == sender){
        sender.selected = YES;
    }else if (_tempBtn!= sender && _tempBtn!=nil){
        _tempBtn.selected = NO;
        sender.selected = YES;
        _tempBtn = sender;
    }
    [_delegate segmentIndex:sender.tag - 1000];
}
- (void)SelectSegment:(UIButton *)sender{
    if (_tempBtn == nil){
        sender.selected = YES;
        _tempBtn = sender;
    }else if (_tempBtn !=nil && _tempBtn == sender){
        sender.selected = YES;
    }else if (_tempBtn!= sender && _tempBtn!=nil){
        _tempBtn.selected = NO;
        sender.selected = YES;
        _tempBtn = sender;
    }
    [self.bottomLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@2);
        make.width.equalTo(@80);
        make.centerX.equalTo(sender.mas_centerX);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }];
}
- (void)selectIndex:(NSInteger)index{
    UIButton *btn = (UIButton *)[self viewWithTag:index + 1000];
    [self SelectSegment:btn];
}
@end
