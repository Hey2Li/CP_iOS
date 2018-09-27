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
@property (nonatomic, strong) SUPlayer *player;
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
    sender.enabled = NO;
    [self playVocieWithUrl:_dataDict[@"ph_am_mp3"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
- (IBAction)playUK:(UIButton *)sender {
    sender.enabled = NO;
    [self playVocieWithUrl:_dataDict[@"ph_en_mp3"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
- (void)playVocieWithUrl:(NSString *)url{
    if (url) {
        [[self.player initWithURL:[NSURL URLWithString:url]]play];
    }
}
- (void)dealloc{
    [self.player stop];
}
- (SUPlayer *)player{
    if (!_player) {
        _player = [[SUPlayer alloc]init];
    }
    return _player;
}
@end
