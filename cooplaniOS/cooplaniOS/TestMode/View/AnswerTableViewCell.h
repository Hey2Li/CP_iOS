//
//  AnswerTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "answerModel.h"

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *yourAnswerBtn;
@property (weak, nonatomic) IBOutlet UIButton *correctAnswerBtn;
@property (weak, nonatomic) IBOutlet UILabel *answerDetailLb;
@property (weak, nonatomic) IBOutlet UILabel *questionNameLb;
@property (weak, nonatomic) IBOutlet UILabel *CorrectLb;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, assign) BOOL isSelected;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet UIImageView *shapeImageView;
@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (nonatomic, strong) answerModel *model;
@end
