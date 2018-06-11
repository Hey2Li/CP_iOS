//
//  CheckWordView.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "CheckWordView.h"
#import <AVKit/AVKit.h>
#import "DictionaryViewController.h"

@interface CheckWordView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *wordLabel;
@property (nonatomic, strong) UIButton *addWordBtn;
@property (nonatomic, strong) UILabel *enVoiceLb;
@property (nonatomic, strong) UILabel *anVoiceLb;
@property (nonatomic, strong) UIButton *sayEnBtn;
@property (nonatomic, strong) UIButton *sayAnBtn;
@property (nonatomic, strong) UILabel *explainLb;
@property (nonatomic, strong) UIButton *detailBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) NSDictionary *partsDict;
@end
@implementation CheckWordView

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _wordLabel = [[UILabel alloc]init];
        [self addSubview:_wordLabel];
        [_wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(17);
            make.height.equalTo(@27);
            make.top.equalTo(self.mas_top).offset(17);
        }];
        _wordLabel.text = @"brother";
        _wordLabel.textColor = UIColorFromRGB(0xffce43);
        _wordLabel.font = [UIFont systemFontOfSize:22];
        
        _addWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addWordBtn setTitle:@"添加生词" forState:UIControlStateNormal];
        [_addWordBtn setTitle:@"已添加" forState:UIControlStateSelected];
        [_addWordBtn setTitleColor:UIColorFromRGB(0xffce43) forState:UIControlStateNormal];
        [_addWordBtn setTitleColor:UIColorFromRGB(0xCCCCCC) forState:UIControlStateSelected];
        _addWordBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_addWordBtn];
        [_addWordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-17);
            make.height.equalTo(@30);
            make.width.equalTo(@81);
            make.centerY.equalTo(_wordLabel.mas_centerY);
        }];
        [_addWordBtn.layer setCornerRadius:5.0f];
        [_addWordBtn.layer setBorderWidth:1.0f];
        [_addWordBtn.layer setMasksToBounds:YES];
        [_addWordBtn.layer setBorderColor:UIColorFromRGB(0xffce43).CGColor];
        
        UILabel *lineLabel = [[UILabel alloc]init];
        lineLabel.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [self addSubview:lineLabel];
        [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(self).offset(60);
        }];
        
        _enVoiceLb = [[UILabel alloc]init];
        _enVoiceLb.text = @"英 [ˈbrʌðə(r)]";
        [self addSubview:_enVoiceLb];
        [_enVoiceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lineLabel.mas_bottom).offset(9);
            make.height.equalTo(@20);
            make.left.equalTo(_wordLabel);
        }];
        _enVoiceLb.textColor = UIColorFromRGB(0xa4a4a4);
        _enVoiceLb.font = [UIFont systemFontOfSize:14];
        
        _sayEnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_sayEnBtn];
        [_sayEnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_enVoiceLb.mas_right).offset(5);
            make.height.equalTo(_enVoiceLb);
            make.width.equalTo(@30);
            make.centerY.equalTo(_enVoiceLb.mas_centerY);
        }];
        [_sayEnBtn setImage:[UIImage imageNamed:@"播放-橙色"] forState:UIControlStateNormal];
        
        _anVoiceLb = [[UILabel alloc]init];
        _anVoiceLb.text = @"美 [ˈbrʌðɚ]";
        [self addSubview:_anVoiceLb];
        [_anVoiceLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_enVoiceLb);
            make.height.equalTo(_enVoiceLb);
            make.left.equalTo(self.mas_centerX);
            make.width.equalTo(_enVoiceLb);
        }];
        _anVoiceLb.textColor = UIColorFromRGB(0xa4a4a4);
        _anVoiceLb.font = [UIFont systemFontOfSize:14];
        
        _sayAnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_sayAnBtn];
        [_sayAnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_anVoiceLb.mas_right).offset(5);
            make.height.equalTo(_anVoiceLb);
            make.width.equalTo(@30);
            make.centerY.equalTo(_anVoiceLb.mas_centerY);
        }];
        [_sayAnBtn setImage:[UIImage imageNamed:@"播放-橙色"] forState:UIControlStateNormal];
        
        _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_detailBtn];
        [_detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wordLabel);
            make.height.equalTo(@20);
            make.width.equalTo(@100);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        [_detailBtn setTitle:@"查看详细释义" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_detailBtn setImage:[UIImage imageNamed:@"详细释义"] forState:UIControlStateNormal];
        
//        _explainLb = [[UILabel alloc]init];
//        _explainLb.font = [UIFont systemFontOfSize:14];
//        _explainLb.text = @"n.兄弟;同事，同胞;同志\nint.（表示生气或吃惊）我的老兄！\nint.（表示生气或吃惊）我的老兄！";
//        _explainLb.textColor = UIColorFromRGB(0xa4a4a4);
//        [self addSubview:_explainLb];
//        [_explainLb mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_wordLabel);
//            make.right.equalTo(self.mas_right).offset(-17);
//            make.top.equalTo(_anVoiceLb.mas_bottom).offset(10);
//            make.bottom.equalTo(_detailBtn.mas_top).offset(-10);
//        }];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 30;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = NO;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_wordLabel);
            make.right.equalTo(self.mas_right).offset(-17);
            make.top.equalTo(_anVoiceLb.mas_bottom).offset(2);
            make.bottom.equalTo(_detailBtn.mas_top).offset(-2);
        }];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.height.equalTo(@18);
            make.width.equalTo(@50);
        }];
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_addWordBtn addTarget:self action:@selector(addWordClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_detailBtn addTarget:self action:@selector(toViewDetail:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sayAnBtn addTarget:self action:@selector(sayAnBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_sayEnBtn addTarget:self action:@selector(sayEnBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)sayAnBtn:(UIButton *)btn{
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_partsDict[@"ph_am_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (void)sayEnBtn:(UIButton *)btn{
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_partsDict[@"ph_en_mp3"]]]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    [self.player play];
}
- (void)setWord:(NSString *)word{
    _word = word;
    self.wordLabel.text = word;
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [LTHttpManager searchWordWithWord:word Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"][@"symbols"];
                if ([data[@"responseData"][@"state"] isEqualToString:@"0"]) {
                    [_addWordBtn.layer setBorderColor:UIColorFromRGB(0xffce43).CGColor];
                    [_addWordBtn setSelected:NO];
                }else if ([data[@"responseData"][@"state"] isEqualToString:@"1"]){
                    [_addWordBtn.layer setBorderColor:UIColorFromRGB(0xCCCCCC).CGColor];
                    [_addWordBtn setSelected:YES];
                }
                NSDictionary *parts = array[0];
                _partsDict = parts;
                _anVoiceLb.text = [NSString stringWithFormat:@"美[%@]",parts[@"ph_am"]];
                _enVoiceLb.text = [NSString stringWithFormat:@"英[%@]",parts[@"ph_en"]];
                if ([parts[@"ph_am_mp3"] isEqualToString:@""]) {
                    _sayEnBtn.hidden = YES;
                    _sayAnBtn.hidden = YES;
                }else{
                    _sayEnBtn.hidden = NO;
                    _sayAnBtn.hidden = NO;
                }
                self.dataArray = parts[@"parts"];
                [_tableView reloadData];
            }else{
                //
            }
        }];
    }];
}
#pragma mark 添加生词
- (void)addWordClick:(UIButton *)btn{
    if (IS_USER_ID) {
        btn.selected = !btn.selected;
        if (btn.selected) {
            [LTHttpManager addWordsWithUserId:IS_USER_ID Word:_word Tranlate:[Tool arrayToJSONString:self.dataArray] Ph_en_mp3:_partsDict[@"ph_en_mp3"] Ph_am_mp3:_partsDict[@"ph_am_mp3"] Ph_am:_partsDict[@"ph_am"] Ph_en:_partsDict[@"ph_en"] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [_addWordBtn.layer setBorderColor:UIColorFromRGB(0xCCCCCC).CGColor];
                    SVProgressShowStuteText(@"添加成功", YES);
                }else{
                    
                }
            }];
        }else{
            [LTHttpManager removeWordsWithUseId:IS_USER_ID Word:_word Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [_addWordBtn.layer setBorderColor:UIColorFromRGB(0xffce43).CGColor];
                    SVProgressShowStuteText(@"取消成功", YES);
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
- (void)closeClick:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 214);
    } completion:^(BOOL finished) {
        if (self.closeBlock) {
            self.closeBlock();
        }
        [self removeFromSuperview];
    }];
}
- (void)toViewDetail:(UIButton *)btn{
    DictionaryViewController *vc = [[DictionaryViewController alloc]init];
    vc.word = _word;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSDictionary *dict = self.dataArray[indexPath.row];
    NSArray *arr = dict[@"means"];
    cell.selectionStyle = NO;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = UIColorFromRGB(0xa4a4a4);
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"part"],[arr componentsJoinedByString:@","]];
    return cell;
}
//- (void)setWordLabel:(UILabel *)wordLabel{
//    _wordLabel = wordLabel;
//}
@end
