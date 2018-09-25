//
//  HomeBuyLessonTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeBuyLessonModel.h"

@interface HomeBuyLessonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lessonNameLb;
@property (weak, nonatomic) IBOutlet UILabel *lessonTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *lessonDetailLb;
@property (weak, nonatomic) IBOutlet UIImageView *lessonImg;

@property (nonatomic, strong) HomeBuyLessonModel *model;
@end
