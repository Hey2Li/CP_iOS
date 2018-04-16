//
//  BannerCollectionViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (nonatomic, copy) NSString *imageUrl;
@end
