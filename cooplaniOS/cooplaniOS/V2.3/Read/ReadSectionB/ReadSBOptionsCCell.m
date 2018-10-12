//
//  ReadSBOptionsCCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSBOptionsCCell.h"

@implementation ReadSBOptionsCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.layer setCornerRadius:20];
    [self.layer setBorderWidth:1.0f];
    [self.layer setBorderColor:UIColorFromRGB(0xCCCCCC).CGColor];
}

@end
