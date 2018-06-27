//
//  WordTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/6/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionWordModel.h"

@interface WordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UIButton *enSayBtn;
@property (weak, nonatomic) IBOutlet UIButton *amSayBtn;
@property (weak, nonatomic) IBOutlet UILabel *enLb;
@property (weak, nonatomic) IBOutlet UILabel *amLb;
@property (weak, nonatomic) IBOutlet UILabel *allDetailLb;
@property (nonatomic, strong) collectionWordModel *model;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *arrowsBtn;
@property (nonatomic, copy) void (^cellIsOpenBlock)(void);

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amBtnTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *amSayBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enLbHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enSayHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainTopHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *explainBottomHeight;

@end
