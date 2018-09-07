//
//  NotKnowView.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReciteWordModel.h"

@interface NotKnowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *addNoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextWordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UILabel *addNoteLb;
@property (weak, nonatomic) IBOutlet UIImageView *addNoteImg;
@property (weak, nonatomic) IBOutlet UIPageControl *examplePageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *exampleCollection;
@property (nonatomic, strong) ReciteWordModel *model;
@end
