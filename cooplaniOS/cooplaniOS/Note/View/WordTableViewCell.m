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
        self.bottomView.hidden = NO;
        [self layoutIfNeeded];
    }else{
        self.bottomView.hidden = YES;
        [self layoutIfNeeded];
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
