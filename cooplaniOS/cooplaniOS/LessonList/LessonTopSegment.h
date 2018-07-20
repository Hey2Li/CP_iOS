//
//  LessonTopSegment.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopSegmentDelegate <NSObject>
- (void)segmentIndex:(NSInteger)index;
@end

@interface LessonTopSegment : UIView
@property (nonatomic, weak) id<TopSegmentDelegate>delegate;
//初始化方法
- (instancetype)initWithTitles:(NSArray *)titles AndSelectColor:(UIColor *)color;
//选中index
- (void)selectIndex:(NSInteger)index;
@end
