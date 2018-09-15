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
@property (weak, nonatomic) IBOutlet UILabel *youAnswerLb;
@property (weak, nonatomic) IBOutlet UILabel *correctAnswerLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *youAnswertBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *youAnswerBtnTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *correctAnswerBtnTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerDetailTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerDetailBottomHeight;
@property (nonatomic, strong) QuestionsModel *model;
@end
