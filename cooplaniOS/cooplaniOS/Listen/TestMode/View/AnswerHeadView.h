//
//  AnswerHeadView.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerHeadView : UIView
@property (weak, nonatomic) IBOutlet UILabel *correctLb;
@property (weak, nonatomic) IBOutlet UIImageView *correctImagView;
@property (weak, nonatomic) IBOutlet UILabel *paperDateLb;
@property (weak, nonatomic) IBOutlet UILabel *paperNameLb;
@property (nonatomic, copy) NSString *correctStr;
@end
