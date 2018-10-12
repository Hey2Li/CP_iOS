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

@interface ReadSATableViewCell()
@property (nonatomic, copy) NSMutableAttributedString *readStr;
@property (nonatomic, strong) NSArray *clickAnswerArray;
@property (nonatomic, copy) YYLabel *textLabel;
@property (nonatomic, strong) NSMutableDictionary *rangeDict;
@property (nonatomic, assign) NSRange clickCurrentRange;
@property (nonatomic, assign) NSInteger clickIndex;
@end

@implementation ReadSATableViewCell
@synthesize textLabel;
- (NSMutableDictionary *)rangeDict{
    if (!_rangeDict) {
        _rangeDict = [NSMutableDictionary dictionary];
    }
    return _rangeDict;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor  =UIColorFromRGB(0xF7F7F7);
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        _clickCurrentRange = NSMakeRange(0, 0);
        textLabel = [YYLabel new];
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor  =UIColorFromRGB(0xF7F7F7);
        //给下划线替换成点击答题
        NSString *replaceStr = [passage stringByReplacingOccurrencesOfString:@"_______" withString:@"点击答题"];
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:replaceStr];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        [textStr setYy_color:UIColorFromRGB(0x666666)];
        textStr.yy_lineSpacing = 8;//行间距
        
        CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32, MAXFLOAT);
        //计算文本尺寸
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
        textLabel.textLayout = layout;
        CGFloat introHeight = layout.textBoundingSize.height;
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.width.equalTo(@(maxSize.width));
            make.height.equalTo(@(introHeight));
            make.left.equalTo(self.mas_left).offset(16);
        }];
        WeakSelf
        //获取所有点击答题位置
        NSArray *rangeArray = [self rangeOfSubString:@"点击答题" inString:replaceStr];
        [rangeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *value = obj;
            NSRange subRange = [value rangeValue];
            //添加下划线
            YYTextDecoration* deco=[YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle) width:[NSNumber numberWithInt:1] color:DRGBCOLOR];
            [textStr yy_setTextUnderline:deco range:subRange];
            //为label添加点击事件
            [textStr yy_setTextHighlightRange:subRange color:DRGBCOLOR backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                weakSelf.clickCurrentRange = range;
                weakSelf.clickIndex = idx;
                NSRange questionRange = NSMakeRange(range.location - 4, 4);
                NSLog(@"点击的第%@题 idx:%ld", [text.string substringWithRange:questionRange],idx);
                [[NSNotificationCenter defaultCenter]postNotificationName:kReadOpenQuestion object:nil];
            } longPressAction:nil];
        }];
        textLabel.attributedText = textStr;
        _readStr = textStr;
        _clickAnswerArray = rangeArray;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickAnswer:) name:kClickReadCard object:nil];
    }
    return self;
}
- (void)clickAnswer:(NSNotification *)notifi{
    NSLog(@"%@", notifi.userInfo);
    if (self.clickCurrentRange.location == 0) {
        SVProgressShowStuteText(@"请先选择一题", NO);
        return;
    }
    if ([notifi.userInfo allKeys]) {
//        NSString *index = [NSString stringWithFormat:@"%@", notifi.userInfo[@"index"]];
        NSString *option = notifi.userInfo[@"options"];//获取选项
        NSString *string = [_readStr.string stringByReplacingCharactersInRange:_clickCurrentRange withString:option];//替换文章选项处
        NSValue *value = _clickAnswerArray[self.clickIndex];
        NSRange answerRange = [value rangeValue];
        NSInteger afterLength = option.length - answerRange.length;//获取答案和点击答题的长度差距
        answerRange.length = option.length;
        NSMutableArray *afterRangeArray = [NSMutableArray array];
        for (int i = 0; i < _clickAnswerArray.count; i ++) {
            if (i == self.clickIndex) {
                [afterRangeArray addObject:[NSValue valueWithRange:answerRange]];
            }else{
                NSValue *subValue = _clickAnswerArray[i];
                NSRange subAnswerRange = [subValue rangeValue];
                if (i > self.clickIndex) {
                    subAnswerRange.location = subAnswerRange.location + afterLength;//为每个location添加长度差距
                }
                [afterRangeArray addObject:[NSValue valueWithRange:subAnswerRange]];
            }
        }
      
        NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:string];
        [textStr yy_setFont:[UIFont systemFontOfSize:15] range:textStr.yy_rangeOfAll];
        [textStr setYy_color:UIColorFromRGB(0x666666)];
        textStr.yy_lineSpacing = 8;//行间距
        textLabel.attributedText = textStr;
        WeakSelf
        //获取所有点击答题位置
        [afterRangeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSValue *value = obj;
            NSRange subRange = [value rangeValue];
            //添加下划线
            YYTextDecoration* deco=[YYTextDecoration decorationWithStyle:(YYTextLineStyleSingle) width:[NSNumber numberWithInt:1] color:DRGBCOLOR];
            [textStr yy_setTextUnderline:deco range:subRange];
            //为label添加点击事件
            [textStr yy_setTextHighlightRange:subRange color:DRGBCOLOR backgroundColor:nil userInfo:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                weakSelf.clickCurrentRange = range;
                weakSelf.clickIndex = idx;
                [[NSNotificationCenter defaultCenter]postNotificationName:kReadOpenQuestion object:nil];
            } longPressAction:nil];
        }];
        textLabel.attributedText = textStr;
        _readStr = textStr;
        _clickAnswerArray = afterRangeArray;
        _clickCurrentRange = NSMakeRange(0, 0);
    }
}
//替换文章中的字符串
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
