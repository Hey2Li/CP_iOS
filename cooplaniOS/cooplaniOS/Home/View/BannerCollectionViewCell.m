//
//  BannerCollectionViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@implementation BannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 15.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.2f;
    self.layer.shadowRadius = 6.0f;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.masksToBounds = NO;
 
    self.bannerImageView.layer.cornerRadius = 15.0f;
    self.bannerImageView.layer.masksToBounds = YES;
}
- (void)setImageUrl:(NSString *)imageUrl{
    _imageUrl = imageUrl;
    NSString *str = [NSString stringWithFormat:@"%@",imageUrl];
    [self.bannerImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"LOADING"]];
}
@end
