//
//  ReadRfreshBackGifFooter.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/15.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadRfreshBackGifFooter.h"

@implementation ReadRfreshBackGifFooter

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepare{
    [super prepare];
    NSMutableArray *LoadingArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"加载%d",i + 1]];
        [LoadingArray addObject:image];
    }
        NSArray *topArray = @[[UIImage imageNamed:@"向上拉1"], [UIImage imageNamed:@"向上拉2"]];
//    NSArray *bottomArray = @[[UIImage imageNamed:@"向下拉1"], [UIImage imageNamed:@"向下拉2"]];
    [self setImages:LoadingArray duration:.6 forState:MJRefreshStateRefreshing];
    [self setImages:topArray duration:.1 forState:MJRefreshStateIdle];
    [self setImages:@[[UIImage imageNamed:@"加载1"]] forState:MJRefreshStatePulling];
    
    self.stateLabel.font = [UIFont systemFontOfSize:14];
    [self setTitle:@"松开阅读下一篇题目" forState:MJRefreshStatePulling];
    [self setTitle:@"上拉作答下一篇阅读" forState:MJRefreshStateIdle];
}
@end
