//
//  LessonTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonModel.h"

@interface LessonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (nonatomic, strong) LessonModel *lessonModel;
@property (nonatomic, strong) LessonModel *myLessonModel;
@end
