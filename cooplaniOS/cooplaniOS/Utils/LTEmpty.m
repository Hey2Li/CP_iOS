//
//  LTEmpty.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTEmpty.h"

@implementation LTEmpty

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)prepare{
    
}
+ (instancetype)NoNetworkEmpty:(reloadDataBlock)reload{
    return [LTEmpty emptyActionViewWithImageStr:@"空"
                                       titleStr:@"您的网络开小差了~"
                                      detailStr:@"请稍后再试!"
                                    btnTitleStr:@"重新加载"
                                  btnClickBlock:reload];
}
+ (instancetype)NoDataEmpty{
    return [LTEmpty emptyViewWithImageStr:@"空" titleStr:@"暂无数据" detailStr:@""];
}
/**
 没有数据
 
 @param message 提示语
 @return @“”
 */
+ (instancetype)NoDataEmptyWithMessage:(NSString *)message{
    return [LTEmpty emptyViewWithImageStr:@"空" titleStr:message detailStr:@""];
}
@end
