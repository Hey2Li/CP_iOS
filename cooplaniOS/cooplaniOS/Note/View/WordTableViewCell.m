//
//  WordTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/6/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordTableViewCell.h"
#import <AVKit/AVKit.h>

@interface WordTableViewCell()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *allDetailStr;
@end

@implementation WordTableViewCell

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomView.hidden = YES;
}
- (IBAction)isOpenClick:(UIButton *)sender {
//    sender.selected = !sender.selected;
//    _model.isOpen = sender.selected;
//    if (self.cellIsOpenBlock) {
//        self.cellIsOpenBlock();
//    }
}
- (void)setModel:(collectionWordModel *)model{
    _model = model;
    _wordLb.text = model.word;
    NSData *nsData=[model.translate dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *childArray = [NSJSONSerialization JSONObjectWithData:nsData options:kNilOptions error:nil];
    _allDetailStr = @"";
    _enLb.text = [NSString stringWithFormat:@"英[%@]",model.ph_en];
    _amLb.text = [NSString stringWithFormat:@"美[%@]",model.ph_am];
    if (childArray.count > 0) {
        [childArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSArray *arr = obj[@"means"];
            NSString *subStr = [NSString stringWithFormat:@"%@  %@",obj[@"part"],[arr componentsJoinedByString:@","]];
            _allDetailStr = [_allDetailStr stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n",subStr]];
            if (idx == 0) {
                _detailLb.text = subStr;
            }
        }];
        _allDetailLb.text = _allDetailStr;
    }
    [self layoutIfNeeded];
    if (_model.isOpen) {
        [self layoutIfNeeded];
        self.bottomView.hidden = NO;
        self.amBtnHeight.constant = 20;
        self.amBtnTopHeight.constant = 20;
        self.amSayBtnHeight.constant = 30;
        self.enLbHeight.constant = 20;
        self.enSayHeight.constant = 30;
        self.explainTopHeight.constant = 10;
        self.explainBottomHeight.constant = 5;
    }else{
        [self layoutIfNeeded];
        self.bottomView.hidden = YES;
        self.amBtnHeight.constant = 0;
        self.amBtnTopHeight.constant = 0;
        self.amSayBtnHeight.constant = 0;
        self.enLbHeight.constant = 0;
        self.enSayHeight.constant = 0;
        self.explainTopHeight.constant = 0;
        self.explainBottomHeight.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sayEnBtn:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.ph_en_mp3]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (IBAction)sayAmBtn:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.ph_am_mp3]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
@end
