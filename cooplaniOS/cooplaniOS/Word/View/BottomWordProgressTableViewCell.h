//
//  BottomWordProgressTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomWordProgressTableViewCell : UITableViewCell

/**
 常错词
 */
@property (weak, nonatomic) IBOutlet UILabel *alwaysErrorLb;

/**
 记忆中
 */
@property (weak, nonatomic) IBOutlet UILabel *inMemoryLb;

/**
 熟练词
 */
@property (weak, nonatomic) IBOutlet UILabel *skilledWordLb;
@property (weak, nonatomic) IBOutlet UIButton *alwaysErrorBtn;
@property (weak, nonatomic) IBOutlet UIButton *inMemoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *skilledWordBtn;

/**
 进度label
 */
@property (weak, nonatomic) IBOutlet UILabel *progressLb;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
