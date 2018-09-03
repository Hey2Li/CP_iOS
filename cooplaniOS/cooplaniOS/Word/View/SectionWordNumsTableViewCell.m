//
//  SectionWordNumsTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SectionWordNumsTableViewCell.h"

@interface SectionWordNumsTableViewCell()
@property (nonatomic, strong) UIImageView *FAQImageView;
@end

@implementation SectionWordNumsTableViewCell
- (UIImageView *)FAQImageView{
    if (!_FAQImageView) {
        _FAQImageView = [[UIImageView alloc]init];
        _FAQImageView.image = [UIImage imageNamed:@"疑问解释框"];
        _FAQImageView.hidden = YES;
    }
    return _FAQImageView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)FAQ:(UIButton *)sender {
    [self.viewController.view addSubview:self.FAQImageView];
    [self.FAQImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sender.mas_right);
        make.top.equalTo(sender.mas_bottom).offset(-10);
        make.width.mas_equalTo(142);
        make.height.mas_equalTo(76);
    }];
    self.FAQImageView.hidden = !self.FAQImageView.hidden;
}

@end
