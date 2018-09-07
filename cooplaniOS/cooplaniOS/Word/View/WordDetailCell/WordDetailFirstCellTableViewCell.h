//
//  WordDetailFirstCellTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciteWordModel.h"

@interface WordDetailFirstCellTableViewCell : UITableViewCell

/**
 单词
 */
@property (weak, nonatomic) IBOutlet UILabel *wordNameLb;

/**
 音标
 */
@property (weak, nonatomic) IBOutlet UILabel *yinBiaoLb;

/**
 释义
 */
@property (weak, nonatomic) IBOutlet UILabel *explainLb;

/**
 次数
 */
@property (weak, nonatomic) IBOutlet UILabel *wordCountLb;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (nonatomic, strong) ReciteWordModel *model;

@end
