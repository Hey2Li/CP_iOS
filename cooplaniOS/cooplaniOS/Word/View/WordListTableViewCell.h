//
//  WordListTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciteWordModel.h"

@interface WordListTableViewCell : UITableViewCell
@property (nonatomic, strong) ReciteWordModel *model;
@property (weak, nonatomic) IBOutlet UILabel *wordNameLb;
@property (weak, nonatomic) IBOutlet UILabel *wordExplainLb;

@end
