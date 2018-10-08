//
//  HomeCategoryTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeCategoryTableViewCell.h"
#import "ListenTrainingViewController.h"
#import "ReadTrainingViewController.h"

@implementation HomeCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
 
    [self topImageBottomWord:self.listenBtn];
    [self topImageBottomWord:self.readBtn];
    [self topImageBottomWord:self.writeBtn];
    [self topImageBottomWord:self.fanyiBtn];
    [self layerCornerRadius:self.listenBtn];
    [self layerCornerRadius:self.readBtn];
    [self layerCornerRadius:self.writeBtn];
    [self layerCornerRadius:self.fanyiBtn];

}
- (void)layerCornerRadius:(UIButton *)btn{
    [btn.layer setCornerRadius:6.0f];
    [btn.layer setMasksToBounds:YES];
    
}
- (void)topImageBottomWord:(UIButton *)btn{
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height + 7 ,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(-18.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)listenClick:(UIButton *)sender {
    ListenTrainingViewController *vc = [[ListenTrainingViewController alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [MobClick event:@"homepage_listening"];
}
- (IBAction)readClick:(UIButton *)sender {
    [MobClick event:@"homepage_reading"];
    [self.viewController.navigationController pushViewController:ReadTrainingViewController.new animated:YES];
}
- (IBAction)writeClick:(UIButton *)sender {
    [MobClick event:@"homepage_writing"];
    SVProgressShowStuteText(@"暂未开放", NO);
}
- (IBAction)fanyiClick:(UIButton *)sender {
    [MobClick event:@"homepage_translation"];
    SVProgressShowStuteText(@"暂未开放", NO);
}

@end
