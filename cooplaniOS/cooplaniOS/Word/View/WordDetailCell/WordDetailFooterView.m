//
//  WordDetailFooterView.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordDetailFooterView.h"

@implementation WordDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WordDetailFooterView class]) owner:self options:nil] lastObject];

    if (self) {
        
    }
    return self;
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    if (model.collection) {
        self.addCollectionImg.image = [UIImage imageNamed:@"已添加-2"];
        [self.addCollectionLb  setTextColor:UIColorFromRGB(0xcccccc)];
        [self.addCollectionLb setText:@"已添加"];
        self.addCollectionBtn.enabled = NO;
    }else{
        self.addCollectionImg.image = [UIImage imageNamed:@"添加笔记"];
        [self.addCollectionLb  setTextColor:UIColorFromRGB(0xFFCE43)];
        [self.addCollectionLb setText:@"添加生词"];
        self.addCollectionBtn.enabled = YES;
    }
}
- (IBAction)addCollectionClick:(UIButton *)sender {
    sender.enabled = NO;
    if (IS_USER_ID) {
        NSArray *array = @[@{@"means":@[self.model.result],@"part":@""}];
        [LTHttpManager addWordsWithUserId:IS_USER_ID Word:self.model.word Tranlate:[Tool arrayToJSONString:array] Ph_en_mp3:self.model.uk_mp3 Ph_am_mp3:self.model.us_mp3 Ph_am:self.model.us_soundmark Ph_en:self.model.uk_soundmark Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                SVProgressShowStuteText(@"添加成功", YES);
                self.addCollectionImg.image = [UIImage imageNamed:@"已添加-2"];
                [self.addCollectionLb  setTextColor:UIColorFromRGB(0xcccccc)];
                [self.addCollectionLb setText:@"已添加"];
            }else{
                SVProgressShowStuteText(message, NO);
                sender.enabled = YES;
            }
        }];
    }else{
        [Tool gotoLogin:self.viewController];
        sender.enabled = YES;
    }
}
@end
