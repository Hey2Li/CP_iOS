//
//  PracticeModeTiKaCCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeModeTiKaCCell : UICollectionViewCell
@property (nonatomic, copy) void (^UpAndDownBtnClick)(UIButton *btn);
@property (nonatomic, copy) void (^questionCellClick)(NSIndexPath *indexPath);
@property (nonatomic, copy) NSString *questionStr;
@property (nonatomic, strong) NSIndexPath *collectionIndexPath;
@end
