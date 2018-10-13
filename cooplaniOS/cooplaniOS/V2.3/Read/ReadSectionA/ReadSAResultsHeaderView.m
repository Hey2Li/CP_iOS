//
//  ReadSAResultsHeaderView.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/13.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadSAResultsHeaderView.h"

@implementation ReadSAResultsHeaderView

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
        self.correctImageView.image = [UIImage imageNamed:@"成绩圈"];
        self.correctLb.text = [NSString stringWithFormat:@"%@%%",correctStr];
        self.correctLb.textColor = UIColorFromRGB(0xD76F67);
    }else{
        self.correctImageView.image = [UIImage imageNamed:@"成绩圈绿"];
        self.correctLb.text = [NSString stringWithFormat:@"%@%%",correctStr];
        self.correctLb.textColor = UIColorFromRGB(0x4DAC7D);
    }
}
@end
