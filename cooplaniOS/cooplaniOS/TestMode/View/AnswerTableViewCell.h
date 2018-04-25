//
//  AnswerTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *yourAnswerBtn;
@property (weak, nonatomic) IBOutlet UIButton *correctAnswerBtn;
@property (weak, nonatomic) IBOutlet UILabel *answerDetailLb;

@end
