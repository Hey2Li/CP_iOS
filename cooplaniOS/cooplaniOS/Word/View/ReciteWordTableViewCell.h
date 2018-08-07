//
//  ReciteWordTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReciteWordTableViewCell : UITableViewCell

/**
 选项ABCD
 */
@property (weak, nonatomic) IBOutlet UILabel *optionsTitle;

/**
 选项内容
 */
@property (weak, nonatomic) IBOutlet UILabel *optionsLb;
@property (weak, nonatomic) IBOutlet UIView *selectedView;

@end
