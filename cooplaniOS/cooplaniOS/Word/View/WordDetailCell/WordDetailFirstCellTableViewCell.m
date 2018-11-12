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
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL isFindWord;
@end
@implementation WordDetailFirstCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
//        NSArray<UIImage*> *imageArray=[NSArray arrayWithObjects:
//                                       [UIImage imageNamed:@"播放2根线"],
//                                       [UIImage imageNamed:@"播放一根线"]
//                                       ,nil];
//        self.playImageView.image = [UIImage imageNamed:@"播放2根线"];
//        //赋值
//        self.playImageView.animationImages = imageArray;
//        //周期时间
//        self.playImageView.animationDuration = 1;
//        //重复次数，0为无限制
//        self.playImageView.animationRepeatCount = 1;
    self.addNoteBtn.hidden = YES;
}
- (IBAction)palyAm:(UIButton *)sender {
    sender.enabled = NO;
    if (_isFindWord) {
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDict[@"ph_am_mp3"]]]];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }else{
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.model.us_mp3]]];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
- (IBAction)playEn:(UIButton *)sender {
    if (_isFindWord) {
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_dataDict[@"ph_en_mp3"]]]];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }else{
        AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.uk_mp3]]];
        [self.player replaceCurrentItemWithPlayerItem:item];
        [self.player play];
    }
}
#pragma mark 添加笔记
- (IBAction)addNoteClick:(UIButton *)btn {
    btn.userInteractionEnabled = NO;
    if (_isFindWord) {
        if (IS_USER_ID) {
            [MobClick endEvent:@"doingpracticeApage_addnote"];
            if (!btn.selected) {
                NSArray *array = _dataDict[@"parts"];
                [LTHttpManager addWordsWithUserId:IS_USER_ID Word:self.wordNameLb.text Tranlate:[Tool arrayToJSONString:array] Ph_en_mp3:_dataDict[@"ph_en_mp3"] Ph_am_mp3:_dataDict[@"ph_am_mp3"] Ph_am:_dataDict[@"ph_am"] Ph_en:_dataDict[@"ph_en"] Complete:^(LTHttpResult result, NSString *message, id data) {
                    if (LTHttpResultSuccess == result) {
                        btn.selected = !btn.selected;
                        btn.userInteractionEnabled = YES;
                        SVProgressShowStuteText(@"添加成功", YES);
                    }else{
                        btn.userInteractionEnabled = YES;
                    }
                }];
            }else{
                [LTHttpManager removeWordsWithUseId:IS_USER_ID Word:self.wordNameLb.text Complete:^(LTHttpResult result, NSString *message, id data) {
                    if (LTHttpResultSuccess == result) {
                        btn.selected = !btn.selected;
                        btn.userInteractionEnabled = YES;
                        SVProgressShowStuteText(@"取消成功", YES);
                    }
                }];
            }
        }else{
            btn.userInteractionEnabled = YES;
            LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
            [alertView show];
            alertView.resultIndex = ^(NSInteger index) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.viewController.navigationController pushViewController:vc animated:YES];
            };
        }
    }
}
- (void)setDataDict:(NSDictionary *)dataDict{
    _isFindWord = YES;
    self.addNoteBtn.hidden = NO;
    _dataDict = dataDict;
    NSString *enStr = dataDict[@"ph_en"];
    enStr = [enStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *amStr = dataDict[@"ph_am"];
    amStr = [amStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.AmYinBiaoLb.text = [NSString stringWithFormat:@"美[%@]",amStr];
    self.enYinBiaoLb.text = [NSString stringWithFormat:@"英[%@]",enStr];
    if ([dataDict[@"ph_am_mp3"] isEqualToString:@""]) {
        self.playEn.hidden = YES;
        self.playAm.hidden = YES;
    }else{
        self.playAm.hidden = NO;
        self.playEn.hidden = NO;
    }
    
    NSArray * dataArray = dataDict[@"parts"];
    NSMutableString *str = [[NSMutableString alloc]init];
    for (NSDictionary *dict in dataArray) {
        NSArray *arr = dict[@"means"];
        [str appendString:[NSString stringWithFormat:@"\n%@%@",dict[@"part"],[arr componentsJoinedByString:@","]]];
    }
    self.explainLb.text = str;
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    _isFindWord = NO;
    self.wordNameLb.text = model.word;
    self.AmYinBiaoLb.text = [NSString stringWithFormat:@"美[%@]",model.us_soundmark];
    self.enYinBiaoLb.text = [NSString stringWithFormat:@"英[%@]",model.uk_soundmark];
    self.explainLb.text = model.ex;
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
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
