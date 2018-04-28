//
//  FeedbackContentTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placehodlerLb;
@property (weak, nonatomic) IBOutlet UITextView *problemContentTV;
@property (weak, nonatomic) IBOutlet UILabel *wordNum;
@property (weak, nonatomic) IBOutlet UIButton *leftImageBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightImageBtn;
@property (nonatomic, copy) void (^uploadImageClick)(UIButton *leftBtn, UIButton *rightBtn);
@property (nonatomic, copy) void (^feedbackContent)(NSString *str);
@end
