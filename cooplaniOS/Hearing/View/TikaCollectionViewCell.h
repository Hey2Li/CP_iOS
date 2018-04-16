//
//  TikaCollectionViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TikaCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) void (^UpAndDownBtnClick)(UIButton *btn);
@end
