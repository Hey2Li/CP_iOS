//
//  SAOptionsCollectionViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SAOptionsCollectionViewCell.h"

@implementation SAOptionsCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.optionLb setBackgroundColor:[UIColor clearColor]];
}
- (void)setSelected:(BOOL)selected{
   
}
- (void)setModel:(ReadSAOptionsModel *)model{
    _model = model;
    self.optionLb.text = [NSString stringWithFormat:@"%@  %@", model.Alphabet, model.Text];
    if (model.isSelectedOption) {
        YYTextDecoration* deco =[YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle) width:[NSNumber numberWithInt:1] color:UIColorFromRGB(0xFFCE43)];
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.optionLb.text];
        [textStr yy_setTextStrikethrough:deco range:NSMakeRange(0, textStr.length)];
        [textStr setYy_font:[UIFont systemFontOfSize:14]];
        [textStr setYy_color:UIColorFromRGB(0x666666)];
        self.optionLb.attributedText = textStr;
    }else{
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:self.optionLb.text];
        [textStr setYy_font:[UIFont systemFontOfSize:14]];
        [textStr setYy_color:UIColorFromRGB(0x666666)];
        self.optionLb.attributedText = textStr;
    }
}
@end
