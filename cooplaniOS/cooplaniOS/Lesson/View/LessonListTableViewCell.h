//
//  LessonListTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoLessonModel.h"
#import "learnLessonModel.h"

@interface LessonListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (nonatomic, strong) VideoLessonModel *model;
@property (nonatomic, strong) learnLessonModel *learnedModel;
@end
