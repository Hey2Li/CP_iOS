//
//  Tool.h
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject
typedef NS_ENUM(NSInteger, IPhoneType) {
    iPhone4Type = 0,
    iPhone5Type,
    iPhone6Type,
    iPhone6PlusType
};

void SVProgressShow(void);
void SVProgressShowText(NSString *text);
void SVProgressShowStuteText(NSString *text, BOOL isSucceed);//成功或失败用 0->失败
void SVProgressHiden(void);

+ (NSArray *)dateArray;
NSAttributedString *returnNumAttr(NSString *str,NSInteger fontSize);
+ (NSDictionary *)MD5Dictionary:(NSMutableDictionary *)dic;
+ (NSString *)MD5:(NSString *)str;
+ (BOOL)judgePhoneNumber:(NSString *)phoneNum;
+ (BOOL)checkPassword:(NSString *) password;
- (UIViewController *)topViewController;
/**
 *  基于UI设计的iPhone6设计图的全机型高度适配
 *
 *  @param height View高度
 *
 *  @return 适配后的高度
 */

+ (CGFloat)layoutForAlliPhoneHeight:(CGFloat)height;
/**
 *  基于UI设计的iPhone6设计图的全机型宽度适配
 *
 *  @param width 宽度
 *
 *  @return 适配后的宽度
 */
+ (CGFloat)layoutForAlliPhoneWidth:(CGFloat)width;

+ (NSString *)getAppVersion;
+ (NSString *)arrayToJSONString:(NSArray *)array;

@end
