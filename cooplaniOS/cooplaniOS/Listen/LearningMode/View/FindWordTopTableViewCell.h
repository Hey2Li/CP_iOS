//
//  FindWordTopTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FindWordTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordName;
@property (weak, nonatomic) IBOutlet UIButton *lookForDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *yinbiao_US;
@property (weak, nonatomic) IBOutlet UILabel *yinbiao_UK;
@property (weak, nonatomic) IBOutlet UIButton *playUS;
@property (weak, nonatomic) IBOutlet UIButton *playUK;
@property (weak, nonatomic) IBOutlet UILabel *explainLb;
@property (nonatomic, strong) NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
