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
}
- (IBAction)palyAm:(UIButton *)sender {
    sender.enabled = NO;
    [self playVocieWithUrl:self.model.us_mp3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
- (IBAction)playEn:(UIButton *)sender {
    sender.enabled = NO;
    [self playVocieWithUrl:self.model.uk_mp3];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
#pragma mark 添加笔记
- (IBAction)addNoteClick:(UIButton *)btn {
    if (IS_USER_ID) {
        btn.selected = !btn.selected;
        if (btn.selected) {
//            [LTHttpManager addWordsWithUserId:IS_USER_ID Word:_word Tranlate:[Tool arrayToJSONString:self.dataArray] Ph_en_mp3:_partsDict[@"ph_en_mp3"] Ph_am_mp3:_partsDict[@"ph_am_mp3"] Ph_am:_partsDict[@"ph_am"] Ph_en:_partsDict[@"ph_en"] Complete:^(LTHttpResult result, NSString *message, id data) {
//                if (LTHttpResultSuccess == result) {
//                    SVProgressShowStuteText(@"添加成功", YES);
//                }else{
//
//                }
//            }];
        }else{
//            [LTHttpManager removeWordsWithUseId:IS_USER_ID Word:_word Complete:^(LTHttpResult result, NSString *message, id data) {
//                if (LTHttpResultSuccess == result) {
//                    SVProgressShowStuteText(@"取消成功", YES);
//                }
//            }];
        }
    }else{
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
        [alertView show];
        alertView.resultIndex = ^(NSInteger index) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        };
    }
}

- (void)setModel:(ReciteWordModel *)model{
    _model = model;

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
