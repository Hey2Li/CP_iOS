//
//  ReadSCQuestionCardCCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadSCQuestionCardCCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *superIndexPath;
@property (nonatomic, copy) void (^cellClick)(NSIndexPath *nextIndexPath);
@property (nonatomic, strong) QuestionsItem *model;
@property (nonatomic, strong) UILabel *passageNoLb;
@end

NS_ASSUME_NONNULL_END
