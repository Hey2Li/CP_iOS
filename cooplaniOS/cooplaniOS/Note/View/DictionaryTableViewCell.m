//
//  DictionaryTableViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DictionaryTableViewCell.h"
#import <AVKit/AVKit.h>

@interface DictionaryTableViewCell()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, copy) NSString *allDetailStr;
@property (nonatomic, strong) NSArray *wordExplainArray;
@property (nonatomic, strong) NSDictionary *partsDict;
@end
@implementation DictionaryTableViewCell
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(NSDictionary *)model{
    _model = model;
    self.wordLb.text = model[@"word_name"];
    NSArray *array = model[@"symbols"];
    if ([model[@"state"] isEqualToString:@"0"]) {
        [self.addDictionaryBtn setSelected:NO];
    }else if ([model[@"state"] isEqualToString:@"1"]){
        [self.addDictionaryBtn setSelected:YES];
    }
    NSDictionary *parts = array[0];
    
    self.amLb.text = [NSString stringWithFormat:@"美[%@]",parts[@"ph_am"]];
    self.enLb.text = [NSString stringWithFormat:@"英[%@]",parts[@"ph_en"]];

    _partsDict = parts;
    if ([parts[@"ph_am_mp3"] isEqualToString:@""]) {
        self.sayAmBtn.hidden = YES;
        self.sayEnBtn.hidden = YES;
    }else{
        self.sayAmBtn.hidden = NO;
        self.sayEnBtn.hidden = NO;
    }
    NSArray *childArray = parts[@"parts"];
    _allDetailStr = @"";
    if (childArray.count > 0) {
        [childArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *arr = obj[@"means"];
            NSString *subStr = [NSString stringWithFormat:@"%@  %@",obj[@"part"],[arr componentsJoinedByString:@","]];
            _allDetailStr = [_allDetailStr stringByAppendingString:[NSString stringWithFormat:@"%@ \n\n",subStr]];
            if (idx == 0) {
                self.explainLb.text = subStr;
            }
        }];
        self.allExplainLb.text = _allDetailStr;
    }
    self.wordExplainArray = childArray;
}
#pragma mark 添加生词
- (IBAction)addDictionary:(UIButton *)btn {
    if (IS_USER_ID) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [LTHttpManager addWordsWithUserId:IS_USER_ID Word:_model[@"word_name"] Tranlate:[Tool arrayToJSONString:self.wordExplainArray] Ph_en_mp3:_partsDict[@"ph_en_mp3"] Ph_am_mp3:_partsDict[@"ph_am_mp3"] Ph_am:_partsDict[@"ph_am"] Ph_en:_partsDict[@"ph_en"] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    SVProgressShowStuteText(@"添加成功", YES);
                    [self.addDictionaryBtn setSelected:YES];
                }else{
                    
                }
            }];
        }else{
            [LTHttpManager removeWordsWithUseId:IS_USER_ID Word:_model[@"word_name"] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    SVProgressShowStuteText(@"取消成功", YES);
                    [self.addDictionaryBtn setSelected:NO];
                }
            }];
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
- (IBAction)sayAmBtn:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_partsDict[@"ph_am_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (IBAction)sayEnBtn:(UIButton *)sender {
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_partsDict[@"ph_en_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}

@end
