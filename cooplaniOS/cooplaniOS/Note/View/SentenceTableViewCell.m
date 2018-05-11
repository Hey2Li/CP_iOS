//
//  SentenceTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SentenceTableViewCell.h"

@implementation SentenceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(collectionSentenceModel *)model{
    _model = model;
    _englishSentenceLb.text = model.sentenceEN;
    _chineseSentenceLb.text = model.sentenceCN;
    _paperNameLb.text = model.paperName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
