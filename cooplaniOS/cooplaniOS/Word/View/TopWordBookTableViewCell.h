//
//  TopWordBookTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopWordBookTableViewCell : UITableViewCell

/**
 词汇书封面
 */
@property (weak, nonatomic) IBOutlet UIImageView *wordBookImg;

/**
 词书名称
 */
@property (weak, nonatomic) IBOutlet UILabel *wordBookNameLb;

/**
 词书介绍
 */
@property (weak, nonatomic) IBOutlet UILabel *wordBookDetailLb;

/**
 词书剩余个数
 */
@property (weak, nonatomic) IBOutlet UILabel *wordBookNumLb;

/**
 词书设置
 */
@property (weak, nonatomic) IBOutlet UIButton *wordBookSettingBtn;

@end
