//
//  WordDetailFirstCellTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordDetailFirstCellTableViewCell.h"
#import "SUPlayer.h"

@interface WordDetailFirstCellTableViewCell ()
@property (nonatomic, strong) SUPlayer *player;
@end
@implementation WordDetailFirstCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
        NSArray<UIImage*> *imageArray=[NSArray arrayWithObjects:
                                       [UIImage imageNamed:@"播放2根线"],
                                       [UIImage imageNamed:@"播放一根线"]
                                       ,nil];
        self.playImageView.image = [UIImage imageNamed:@"播放2根线"];
        //赋值
        self.playImageView.animationImages = imageArray;
        //周期时间
        self.playImageView.animationDuration = 1;
        //重复次数，0为无限制
        self.playImageView.animationRepeatCount = 1;
}
- (IBAction)playAnimation:(UIButton *)sender {
        sender.enabled = NO;
        [self.playImageView startAnimating];
        [self playVocieWithUrl:self.model.us_mp3];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    self.wordNameLb.text = [NSString stringWithFormat:@"%@", model.word];
    self.yinBiaoLb.text = [NSString stringWithFormat:@"%@", model.us_soundmark];
    self.explainLb.text = [NSString stringWithFormat:@"%@", model.ex];
    self.wordCountLb.text = [NSString stringWithFormat:@"%ld次", (long)model.count];
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
