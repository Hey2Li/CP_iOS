//
//  AnswerHeadView.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "AnswerHeadView.h"

@implementation AnswerHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setCorrectStr:(NSString *)correctStr{
    _correctStr = correctStr;
    if ([correctStr integerValue] < 60) {
        self.correctImagView.image = [UIImage imageNamed:@"成绩圈"];
        self.correctLb.text = [NSString stringWithFormat:@"%@%%",correctStr];
        self.correctLb.textColor = UIColorFromRGB(0xD76F67);
    }else{
        self.correctImagView.image = [UIImage imageNamed:@"成绩圈绿"];
        self.correctLb.text = [NSString stringWithFormat:@"%@%%",correctStr];
        self.correctLb.textColor = UIColorFromRGB(0x4DAC7D);
    }
}
@end
