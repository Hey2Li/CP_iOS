//
//  FeedbackTypeTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *otherFeedbackBtn;
@property (weak, nonatomic) IBOutlet UIButton *productIdeasBtn;
@property (weak, nonatomic) IBOutlet UIButton *contentErrorBtn;
@property (nonatomic, copy) void (^feedbackTypeClick)(UIButton *btn);
@end
