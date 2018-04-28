//
//  FeedbackPhoneTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackPhoneTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *QQOrPhoneTF;
@property (nonatomic ,copy) void (^userContact)(NSString *contact);
@end
