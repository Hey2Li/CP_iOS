//
//  BuyLessonTableHeaderView.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HeaderSelectIndex) {
    HeaderSelectAddress,
    HeaderSelectBuy,
    HeaderSelectLearn
};
@interface BuyLessonTableHeaderView : UIView

- (void)selectIndex:(HeaderSelectIndex)index;

@end
