//
//  ReadSBQuestionCardCCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadSBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadSBQuestionCardCCell : UICollectionViewCell
@property (nonatomic, copy) void (^collectionScroll)(NSIndexPath *indexPath);
@property (nonatomic, strong) NSIndexPath *superIndexPath;
@property (nonatomic, strong) ReadSBOptionsModel *optionsModel;
@property (nonatomic, strong) NSArray  *questionsArray;
@property (nonatomic, copy) NSString *question;
@end

NS_ASSUME_NONNULL_END
