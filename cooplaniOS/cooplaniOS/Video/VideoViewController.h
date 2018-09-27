//
//  VideoViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPlayer.h"
#import "VideoLessonModel.h"
#import "learnLessonModel.h"

@interface VideoViewController : UIViewController
//@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, copy) NSString *lessonType;
@end

