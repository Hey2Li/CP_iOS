//
//  MyCollectionPaperTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyCollectionPaperTableViewCell.h"

@implementation MyCollectionPaperTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(MyCollectionModel *)model{
    _model = model;
    _paperName.text = model.name;
    
}
- (void)setDownloadModel:(DownloadFileModel *)downloadModel{
    _downloadModel = downloadModel;
    _paperName.text = downloadModel.name;
}
@end
