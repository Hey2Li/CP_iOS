//
//  NotKnowView.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotKnowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextWordBtn;
@property (weak, nonatomic) IBOutlet UILabel *wordMeanLb;
@property (weak, nonatomic) IBOutlet UILabel *exampleLb;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *addNoteLb;
@property (weak, nonatomic) IBOutlet UIImageView *addNoteImg;
@end
