//
//  LessonDownloadTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadVideoModel.h"

@interface LessonDownloadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *videoSize;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (nonatomic, strong) DownloadVideoModel *model;
@end
