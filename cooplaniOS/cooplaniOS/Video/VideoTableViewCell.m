//
//  VideoTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "VideoTableViewCell.h"
#import <WMPlayer.h>

@implementation VideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.playBtn addTarget:self action:@selector(startPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
    self.backgroundImageView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)startPlayVideo:(UIButton *)sender{
    sender.hidden = YES;
    if (self.playStartClickBlock) {
        self.playStartClickBlock(self.backgroundImageView);
    }
    
}
@end
