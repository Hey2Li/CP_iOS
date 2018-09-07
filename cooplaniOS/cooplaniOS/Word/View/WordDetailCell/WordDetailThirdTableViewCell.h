//
//  WordDetailThirdTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDetailThirdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitleCell;

/**
 助记 提示
 */
@property (weak, nonatomic) IBOutlet UILabel *helpMemoryLb;

@end
