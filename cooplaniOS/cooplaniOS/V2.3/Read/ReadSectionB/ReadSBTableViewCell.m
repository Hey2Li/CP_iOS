//
//  ReadSBTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSBTableViewCell.h"
NSString* passages =  @"[A] I have always been a poor test-taker. So it may seem rather strange that I have returned to college to finish the degree I left undone some four decades ago. I am making my way through Columbia University, surrounded by students who quickly supply the verbal answer while I am still processing the question.";

@implementation ReadSBTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        YYLabel *textLabel = [YYLabel new];
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor = UIColorFromRGB(0xF7F7F7);
        textLabel.displaysAsynchronously = YES;

        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:passages];
        [textStr yy_setFont:[UIFont systemFontOfSize:14] range:textStr.yy_rangeOfAll];
        [textStr setYy_color:UIColorFromRGB(0x666666)];
        textStr.yy_lineSpacing = 8;//行间距
//        textStr.yy_headIndent = 10;
        
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        textLabel.textLayout = layout;
        CGFloat introHeight = layout.textBoundingSize.height;
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(@(maxSize.width - 25));
            make.height.equalTo(@(introHeight));
            make.centerX.equalTo(self.mas_centerX);
        }];
        [[self returnWordRangeArray:passages] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *value = obj;
            NSRange subRange = [value rangeValue];
            [textStr yy_setTextHighlightRange:subRange color:nil backgroundColor:[UIColor blueColor] userInfo:nil tapAction:nil longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"%@", [text attributedSubstringFromRange:range].string);
                [textStr yy_setColor:DRGBCOLOR range:range];
            }];
        }];
        textLabel.attributedText = textStr;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSMutableArray *)returnWordRangeArray:(NSString *)wordStr{
    NSMutableArray *array = [NSMutableArray array];
    [wordStr enumerateSubstringsInRange:NSMakeRange(0, wordStr.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        NSLog(@"substring:%@",substring);
        NSLog(@"substringRange:%@",NSStringFromRange(substringRange));
        [array addObject:[NSValue valueWithRange:substringRange]];
    }];
    return array;
}
@end
