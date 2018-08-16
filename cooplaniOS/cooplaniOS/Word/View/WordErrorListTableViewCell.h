//
//  WordErrorListTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciteWordModel.h"

typedef void(^btnClick)(UIButton *btn);
@interface WordErrorListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *wordErrorTopView;
@property (weak, nonatomic) IBOutlet UIView *wordErrorBottomView;
@property (weak, nonatomic) IBOutlet UILabel *wordNameLb;
@property (weak, nonatomic) IBOutlet UILabel *wordExplainLb;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
@property (weak, nonatomic) IBOutlet UILabel *phonogramLb;
@property (weak, nonatomic) IBOutlet UILabel *bottomWordExplainLb;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) ReciteWordModel *model;
@property (nonatomic, copy) btnClick cellBtnClick;
@end
