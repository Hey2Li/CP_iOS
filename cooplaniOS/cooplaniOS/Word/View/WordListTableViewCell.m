//
//  WordListTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordListTableViewCell.h"

@implementation WordListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    self.wordNameLb.text = model.word;
    self.wordExplainLb.text = model.result;
}
@end
