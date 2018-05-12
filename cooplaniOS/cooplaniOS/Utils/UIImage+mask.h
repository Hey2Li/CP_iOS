//
//  UIImage+mask.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mask)
/*在一张背景图上绘制文字并且居中
 *
 *  @param str       要绘制到图片上的文字
 *  @param image     背景图片
 *  @param fontSize  文字的大小
 *  @param textColor 文字颜色
 *
 *  @return 绘制上文字的图片
 */
+ (UIImage *)createOtherMerchantImage:(NSString *)str withBgImage:(UIImage *)image withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor;
+ (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontsize size:(CGSize)size textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor radius:(CGFloat)radius;

+ (UIImage*)imageWithColor:(UIColor*)color;

@end
