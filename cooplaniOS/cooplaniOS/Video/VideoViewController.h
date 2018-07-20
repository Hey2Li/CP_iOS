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
@property (nonatomic, strong) NSArray *lessonListArray;
@property (nonatomic, strong) VideoLessonModel *videoModel;
@property (nonatomic, strong) NSArray *learnedListArray;
@property (nonatomic, strong) learnLessonModel *learnVideoModel;

@end

