//
//  answerModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "answerModel.h"

@implementation answerModel
- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if (_isSelected) {
        CGSize sizeFileName = [_answerDetail boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat height = sizeFileName.height;
        _cellHeight = 50 + 40 + 10 + 10 + 5 + height;
    }else{
        _cellHeight = 50;
    }
}
- (CGFloat)cellHeight{
    if (_cellHeight) {
        return _cellHeight;
    }else{
        return 50;
    }
}
@end
