//
//  FindWordTopTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "FindWordTopTableViewCell.h"
#import "SUPlayer.h"

@interface FindWordTopTableViewCell ()
@property (nonatomic, strong) AVPlayer *player;
@end

@implementation FindWordTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.lookForDetailBtn.layer setBorderWidth:1.0f];
    [self.lookForDetailBtn.layer setBorderColor:UIColorFromRGB(0xFFCE43).CGColor];
    [self.lookForDetailBtn.layer setCornerRadius:11.0f];
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    NSString *enStr = dataDict[@"ph_en"];
    enStr = [enStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *amStr = dataDict[@"ph_am"];
    amStr = [amStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.yinbiao_US.text = [NSString stringWithFormat:@"美[%@]",amStr];
    self.yinbiao_UK.text = [NSString stringWithFormat:@"英[%@]",enStr];
    if ([dataDict[@"ph_am_mp3"] isEqualToString:@""]) {
        self.playUS.hidden = YES;
        self.playUK.hidden = YES;
    }else{
        self.playUS.hidden = NO;
        self.playUK.hidden = NO;
    }
    NSArray * dataArray = dataDict[@"parts"];
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSDictionary *dict in dataArray) {
        NSArray *arr = dict[@"means"];
         [str appendString:[NSString stringWithFormat:@"%@%@",dict[@"part"],[arr componentsJoinedByString:@","]]];
    }
    self.explainLb.text = str;

}
- (IBAction)playUS:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDict[@"ph_am_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (IBAction)playUK:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDict[@"ph_en_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (void)playVocieWithUrl:(NSString *)url{
    if (url) {
        [[self.player initWithURL:[NSURL URLWithString:url]]play];
    }
}
- (void)dealloc{
//    [self.player stop];
}
- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}
@end
