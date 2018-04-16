//
//  UISlider+time.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UISlider+time.h"
#import "UIImage+mask.h"

@implementation UISlider (time)
- (void)setValue:(float)value andTime:(NSString *)time animated:(BOOL)animated{
    [self setValue:value animated:animated];
    NSString *text = [NSString stringWithFormat:@"%@",time];
    UIImage *image = [UIImage imageWithText:text fontSize:8 size:CGSizeMake(50, 15) textColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] radius:6];
    [self setThumbImage:image forState:UIControlStateNormal];
}
@end
