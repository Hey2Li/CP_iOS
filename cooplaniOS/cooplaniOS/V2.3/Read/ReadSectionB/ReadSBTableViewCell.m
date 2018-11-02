//
//  ReadSBTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSBTableViewCell.h"
#import "NewCheckWordView.h"

@interface ReadSBTableViewCell()
@property (nonatomic, strong) YYLabel *textLabel;
@property (nonatomic, strong) NewCheckWordView *checkWordView;
@end

@implementation ReadSBTableViewCell
@synthesize textLabel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColorFromRGB(0xF7F7F7);
        textLabel = [YYLabel new];
        textLabel.numberOfLines = 0;
        textLabel.backgroundColor = UIColorFromRGB(0xF7F7F7);
        textLabel.displaysAsynchronously = YES;
    }
    return self;
}
- (void)setPassage:(NSString *)passage{
    _passage = passage;
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:passage];
    [textStr yy_setFont:[UIFont systemFontOfSize:14] range:textStr.yy_rangeOfAll];
    [textStr setYy_color:UIColorFromRGB(0x666666)];
    textStr.yy_lineSpacing = 8;//行间距
    //        textStr.yy_headIndent = 10;
    
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 32 - 25, MAXFLOAT);
    //计算文本尺寸
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
    textLabel.textLayout = layout;
    CGFloat introHeight = layout.textBoundingSize.height;
    [self addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@(maxSize.width));
        make.height.equalTo(@(introHeight));
        make.centerX.equalTo(self.mas_centerX);
    }];
    //为passage添加长按事件
    [[self returnWordRangeArray:passage] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *value = obj;
        NSRange subRange = [value rangeValue];
        [textStr yy_setTextHighlightRange:subRange color:nil backgroundColor:[UIColor blueColor] userInfo:nil tapAction:nil longPressAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [textStr yy_setColor:DRGBCOLOR range:range];
            [[NSNotificationCenter defaultCenter]postNotificationName:kFindWordIsOpen object:nil];
            self.checkWordView = [[NewCheckWordView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 143 - SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - 12)];
            [self.viewController.view addSubview:self.checkWordView];
            self.checkWordView.word = [text attributedSubstringFromRange:range].string;
            WeakSelf
            self.checkWordView.findViewIsOpenBlock = ^(UIButton *btn) {
                if (btn.selected) {
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.checkWordView.frame = CGRectMake(0,  SCREEN_HEIGHT - SafeAreaTopHeight - (SCREEN_HEIGHT - SafeAreaTopHeight - 12), SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - 12);
                    } completion:^(BOOL finished) {
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        weakSelf.checkWordView.frame = CGRectMake(0, SCREEN_HEIGHT - 143 - SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight - 12);
                    } completion:^(BOOL finished) {
                    }];
                }
            };
        }];
    }];
    textLabel.attributedText = textStr;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSMutableArray *)returnWordRangeArray:(NSString *)wordStr{
    NSMutableArray *array = [NSMutableArray array];
    [wordStr enumerateSubstringsInRange:NSMakeRange(0, wordStr.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        NSLog(@"substring:%@",substring);
//        NSLog(@"substringRange:%@",NSStringFromRange(substringRange));
        [array addObject:[NSValue valueWithRange:substringRange]];
    }];
    return array;
}
@end
