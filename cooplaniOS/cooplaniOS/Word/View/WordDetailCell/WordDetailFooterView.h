//
//  WordDetailFooterView.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciteWordModel.h"
@interface WordDetailFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addCollectionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *addCollectionImg;
@property (weak, nonatomic) IBOutlet UILabel *addCollectionLb;
@property (nonatomic, strong) ReciteWordModel *model;

@end
