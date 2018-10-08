//
//  ReadSATableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSATableViewCell.h"
#import <YYText.h>
NSString* passage=  @"The method for making beer has changed over time. Hops (啤酒花)，for example, which give many amodern beer its bitter flavor, are a (26)_______ recent addition to the beverage. This was first mentioned in reference to brewing in the ninth century. Now, researchers have found a (27)_______ ingredient in residue (残留物) from 5,000-year-old beer brewing equipment. While digging two pits at a site in the central plains of China, scientists discovered fragments from pots and vessels. The different shapes of the containers (28)_______    they were used to brew, filter, and store beer. They may be ancient “beer-making tools,” and the earliest (29)_______ evidence of beer brewing in China, the researchers reported in the Proceedings of the National Academy of Sciences. To (30)_______    that theory, the team examined the yellowish, dried (31)_______    inside the vessels. The majority of the grains, about 80%, were from cereal crops like barley(大麦), and about 10% were bits of roots, (32)_______ lily, which would have made the beer sweeter, the scientists say. Barley was an unexpected find: the crop was domesticated in Western Eurasia and didn't become a (33)_______ food in central China until about 2,000 years ago, according to the researchers. Based on that timing, they indicate barley may have (34)_______ in the region not as food, but as (35)_______ material for beer brewing.";
@implementation ReadSATableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        YYLabel *textLabel = [YYLabel new];
        textLabel.numberOfLines = 0;
        NSString *replaceStr = [passage stringByReplacingOccurrencesOfString:@"_______" withString:@"点击答题"];
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:replaceStr];
        [textStr yy_setFont:[UIFont systemFontOfSize:20] range:textStr.yy_rangeOfAll];
        [textStr setYy_color:[UIColor blackColor]];
        
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT);
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        textLabel.textLayout = layout;
        CGFloat introHeight = layout.textBoundingSize.height;
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(@(maxSize.width));
            make.height.equalTo(@(introHeight));
            make.left.equalTo(self.mas_left).offset(15);
        }];
        
        NSArray *rangeArray = [self rangeOfSubString:@"点击答题" inString:replaceStr];
        
        [rangeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *value = obj;
            NSRange subRange = [value rangeValue];
            //添加下划线
            YYTextDecoration* deco=[YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle) width:[NSNumber numberWithInt:1] color:UIColorFromRGB(0x3F3F3F)];
            [textStr yy_setTextUnderline:deco range:subRange];
            //为label添加点击事件
            [textStr yy_setTextHighlightRange:subRange color:UIColorFromRGB(0x3F3F3F) backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [text.string stringByReplacingCharactersInRange:range withString:@"答案"];
                NSRange questionRange = NSMakeRange(range.location - 4, 4);
                NSLog(@"点击的第%@题 idx:%ld", [text.string substringWithRange:questionRange],idx);
                [[NSNotificationCenter defaultCenter]postNotificationName:kReadOpenQuestion object:nil];
            } longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                NSLog(@"长按的第%lu个%@",(unsigned long)idx, [text.string substringWithRange:range]);
            }];
        }];
        textLabel.attributedText = textStr;
    }
    return self;
}
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString *string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for (int i = 0; i < (string.length - subStr.length + 1); i++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = NSMakeRange(i, subStr.length);
            [rangeArray addObject:[NSValue valueWithRange:range]];
        }
    }
    return rangeArray;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
