//
//  VideoBottomView.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/19.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VideoBottomClick)(UIButton *btn);

@interface VideoBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *clarityBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UILabel *downloadLb;
@property (weak, nonatomic) IBOutlet UIImageView *downloadImg;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (nonatomic, copy) VideoBottomClick selectionClickBlock;
@property (nonatomic, copy) VideoBottomClick clarityClickBlock;
@property (nonatomic, copy) VideoBottomClick downloadClickBlcok;
@property (nonatomic, copy) VideoBottomClick shareClickBlock;
@end
