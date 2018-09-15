//
//  ListenTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/19.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenTableViewCell.h"

@implementation ListenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:_listenLb.text attributes:@{NSBackgroundColorAttributeName:WORDCOLOR(0xFFCE43)}];
        _listenLb.attributedText = attrString;
    }else{
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:_listenLb.text attributes:@{NSBackgroundColorAttributeName:UIColorFromRGB(0xf7f7f7)}];
        _listenLb.attributedText = attrString;
    }
    // Configure the view for the selected state
}
- (void)setListenLb:(UILabel *)listenLb{
    _listenLb = listenLb;
    _listenLb.attributedText = [self changeSpaceForLabel:listenLb.text withLineSpace:15 WordSpace:50];
    [_listenLb sizeToFit];
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}
/**
 *  改变行间距和字间距
 */
- (NSAttributedString *)changeSpaceForLabel:(NSString *)labelText withLineSpace:(float)lineSpace WordSpace:(float)wordSpace{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    return attributedString;
}
@end
