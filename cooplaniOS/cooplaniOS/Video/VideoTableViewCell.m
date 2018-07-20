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
    self.backgroundImageView.image = [UIImage imageNamed:@"缩略图"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)startPlayVideo:(UIButton *)sender{
    if (self.playStartClickBlock) {
        self.playStartClickBlock(self.backgroundImageView, sender);
    }
    
}
@end
