//
//  UIImage+mask.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIImage+mask.h"

@implementation UIImage (mask)

+ (UIImage *)createOtherMerchantImage:(NSString *)str withBgImage:(UIImage *)image withFont:(CGFloat)fontSize withTextColor:(UIColor *)textColor

{
    //    UIImage *image = [ UIImage imageNamed:@"otherMerchantHeaderBg" ];
    CGSize size= CGSizeMake (image. size . width , image. size . height ); // 画布大小
    
    UIGraphicsBeginImageContextWithOptions (size, NO , 0.0 );
    
    [image drawAtPoint : CGPointMake ( 0 , 0 )];
    
    // 获得一个位图图形上下文
    
    CGContextRef context= UIGraphicsGetCurrentContext ();
    
    CGContextDrawPath (context, kCGPathStroke );
    
    //画自己想画的内容。。。。。
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //    [str drawAtPoint : CGPointMake ( image. size . width * 0.4 , image. size . height * 0.4 ) withAttributes : @{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : 50 ], NSForegroundColorAttributeName :[ UIColor blackColor ],NSParagraphStyleAttributeName:paragraphStyle} ];
    
    UIFont  *font = [UIFont boldSystemFontOfSize:fontSize];//定义默认字体
    //计算文字的宽度和高度：支持多行显示
    CGSize sizeText = [str boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:font,//设置文字的字体
                                                  NSKernAttributeName:@10,//文字之间的字距
                                                  }
                                        context:nil].size;
    
    //为了能够垂直居中，需要计算显示起点坐标x,y
    CGRect rect = CGRectMake((size.width-sizeText.width)/2, (size.height-sizeText.height)/2, sizeText.width, sizeText.height);
    
    
    [str drawInRect:rect withAttributes:@{ NSFontAttributeName :[ UIFont fontWithName : @"Arial-BoldMT" size : fontSize ], NSForegroundColorAttributeName :textColor,NSParagraphStyleAttributeName:paragraphStyle} ];
    
    //画自己想画的内容。。。。。
    
    // 返回绘制的新图形
    
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    
    UIGraphicsEndImageContext ();
    
    return newImage;
    
}
+ (UIImage *)imageWithText:(NSString *)text fontSize:(CGFloat)fontsize size:(CGSize)size textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor radius:(CGFloat)radius{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius]addClip];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, 0.8);
    CGContextSetStrokeColorWithColor(context, textColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    UIFont *font = [UIFont systemFontOfSize:fontsize];
    CGFloat yOffset = (rect.size.height - font.pointSize) / 2.0 - 1.25;
    CGRect textRect = CGRectMake(0, yOffset, rect.size.width, rect.size.height - yOffset);
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle]mutableCopy];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [text drawInRect:textRect withAttributes:@{NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *image  =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage*)imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}

@end

