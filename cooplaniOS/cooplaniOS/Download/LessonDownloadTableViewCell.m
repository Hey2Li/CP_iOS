//
//  LessonDownloadTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonDownloadTableViewCell.h"

@implementation LessonDownloadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(DownloadVideoModel *)model{
    _model = model;
    self.videoName.text = model.name;
    self.videoSize.text = [NSString stringWithFormat:@"%dM",[model.videoSize intValue]/(1024 * 1024)];
    self.time.text = model.time;
}
@end
