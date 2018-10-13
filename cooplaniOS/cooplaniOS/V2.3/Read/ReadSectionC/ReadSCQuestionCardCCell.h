//
//  ReadSCQuestionCardCCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadSCQuestionCardCCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *superIndexPath;
@property (nonatomic, copy) void (^cellClick)(NSIndexPath *nextIndexPath);
@end

NS_ASSUME_NONNULL_END
