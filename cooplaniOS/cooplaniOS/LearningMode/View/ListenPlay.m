//
//  ListenPlay.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenPlay.h"
#import "SUPlayer.h"
#import "UIImage+mask.h"
#import "UISlider+time.h"
#import "UILabel+HYLabel.h"
#import "HYWord.h"
#import "TikaCollectionViewCell.h"
#import "ListenTableViewCell.h"

@interface ListenPlay ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CADisplayLink *timer;//界面刷新定时器
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, assign) NSInteger songIndex;
@property (nonatomic, strong) NSMutableArray *lyricArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *lengthArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGR;
@property (nonatomic, strong) UIPanGestureRecognizer *panGr;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) int CNTag;//判断中英文
@property (nonatomic, assign) int RateTag;//判断播放器速率
@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, copy)NSString *currentWord;
@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation ListenPlay
@synthesize lyricArray;
@synthesize lengthArray;
@synthesize timeArray;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initView];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)initView{
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"2017年6月四级真题（一）" withExtension:@"MP3"];
    self.player = [[SUPlayer alloc]initWithURL:fileUrl];
    
    [self.player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider setValue:self.player.progress andTime:@"00:00/00:00" animated:YES];
    _isOpen = YES;
    _CNTag = 0;
    _RateTag = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:@"playFinished" object:nil];
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.separatorStyle = NO;
    self.lyricTableView.estimatedRowHeight = 50.0f;
    self.lyricTableView.rowHeight = UITableViewAutomaticDimension;
    self.lyricTableView.showsVerticalScrollIndicator = NO;
    [self.lyricTableView registerNib:[UINib nibWithNibName:@"ListenTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTableViewCell class])];
    self.lyricTableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    
    
    [self bringSubviewToFront:self.bottomView];
    [self bringSubviewToFront:self.otherView];
    
    [self parseLrc];
    self.backImageView.hidden = YES;
    [self bringSubviewToFront:self.backImageView];
}
#pragma mark 播放器相关
- (void)changeProgress:(UISlider *)slider {
    if ([self.player isPlaying]) {
        [self.player pause];
        float seekTime = self.player.duration * slider.value;
        [self.player seekToTime:seekTime];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CGFloat minTime = 100;
            for (NSInteger i = 0; i < timeArray.count; i++) {
                NSString *time = [timeArray[i] substringWithRange:NSMakeRange(0, 5)];
                NSArray *timeArray = [time componentsSeparatedByString:@":"];
                CGFloat allTime = [timeArray[0] floatValue] * 60 + [timeArray[1] floatValue];
                CGFloat otherTime = fabs(allTime - seekTime);
                if (minTime > otherTime) {
                    minTime = otherTime;
                    _currentIndex = i;
                    NSLog(@"--------------------------------------mintime:%f,i:%ld,seekTime:%f",minTime,(long)i,seekTime);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                NSLog(@"scrollLyric/currentIndex%ld",(long)_currentIndex);
            });
        });
        [self.player play];
        self.playSongBtn.selected = YES;
    }else{
        [self.player pause];
        float seekTime = self.player.duration * slider.value;
        NSString *time = [NSString stringWithFormat:@"%@/%@ ",[self convertStringWithTime:seekTime], [self convertStringWithTime:self.player.duration]];
        [self.progressSlider setValue:self.player.progress andTime:time animated:YES];
        [self.player seekToTime:seekTime];
        self.playSongBtn.selected = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CGFloat minTime = 100;
            for (NSInteger i = 0; i < timeArray.count; i++) {
                NSString *time = [timeArray[i] substringWithRange:NSMakeRange(0, 5)];
                NSArray *timeArray = [time componentsSeparatedByString:@":"];
                CGFloat allTime = [timeArray[0] floatValue] * 60 + [timeArray[1] floatValue];
                CGFloat otherTime = fabs(allTime - seekTime);
                if (minTime > otherTime) {
                    minTime = otherTime;
                    _currentIndex = i;
                    NSLog(@"--------------------------------------mintime:%f,i:%ld,seekTime:%f",minTime,(long)i,seekTime);
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                NSLog(@"scrollLyric/currentIndex%ld",(long)_currentIndex);
            });
        });
        
    }
}
#pragma mark 解析歌词
- (void)parseLrc{
    NSURL *lyicUrl = [[NSBundle mainBundle]URLForResource:@"2017年6月四级真题（一）" withExtension:@"lrc"];
    
    NSString *lrcString = [[NSString alloc]initWithContentsOfURL:lyicUrl encoding:NSUTF8StringEncoding error:nil];
    
    lyricArray = [NSMutableArray array];
    timeArray = [NSMutableArray array];
    lengthArray = [NSMutableArray array];
    
    NSArray *lycArray = [lrcString componentsSeparatedByString:@"\n"];
    [lycArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:@"["]) {
            NSRange starRange = [obj rangeOfString:@"["];
            NSRange stopRange = [obj rangeOfString:@"]"];
            NSString *timeString = [obj substringWithRange:NSMakeRange(starRange.location + 1, stopRange.location - starRange.location - 1)];
            [timeArray addObject:timeString];
            
            NSString *minString = [timeString substringWithRange:NSMakeRange(0, 2)];
            NSString *secString = [timeString substringWithRange:NSMakeRange(3, 2)];
            NSString *mseString = [timeString substringWithRange:NSMakeRange(6, 2)];
            
            float timeLength = [minString floatValue] * 60 + [secString floatValue] + [mseString floatValue] / 1000;
            [lengthArray  addObject:[NSString stringWithFormat:@"%.3f",timeLength]];
            
            NSString *lyricString  =[obj substringFromIndex:10];
            [lyricArray addObject:lyricString];
        }else{
            NSString *lyricString = [NSString stringWithFormat:@"%@\n%@",lyricArray[lyricArray.count-1], obj];
            [lyricArray replaceObjectAtIndex:lyricArray.count-1 withObject:lyricString];
        }
    }];
}
- (void)startRoll{
    if (_timer) return;
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(scrollLyric)];
    _timer.frameInterval = 3;
    [_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)stopRoll {
    [_timer invalidate];
    _timer = nil;
}
- (IBAction)playSong:(UIButton *)sender {
    if (sender.selected) {
        [self.player pause];
        [self stopRoll];
    }else{
        [self.player play];
        [self startRoll];
//        [self.lyricTableView reloadData];
    }
    sender.selected = !sender.selected;
}
- (IBAction)upSong:(UIButton *)sender {
    _lastIndex = _currentIndex;
    _currentIndex--;
    [self.player pause];
    if (_currentIndex <= -1) {
        _currentIndex = -1;
        [self.player play];
        [self startRoll];
        return;
    }else{
        [self stopRoll];
        NSString *timeStr = self.timeArray[_currentIndex];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        CGFloat min = [timeArray[0] floatValue] * 60;
        CGFloat sec = [timeArray[1] floatValue];
        [self.player seekToTime:min + sec];
        [self.player play];
        [self startRoll];
        [_lyricTableView reloadData];
        [_lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}
- (IBAction)downSong:(UIButton *)sender {
    _lastIndex = _currentIndex;
    _currentIndex++;
    [self.player pause];
    [self stopRoll];
    if (_currentIndex+1 > self.timeArray.count) {
        [self.player play];
        [self startRoll];
        return;
    }else{
        NSString *timeStr = self.timeArray[_currentIndex];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        CGFloat min = [timeArray[0] floatValue] * 60;
        CGFloat sec = [timeArray[1] floatValue];
        [self.player seekToTime:min + sec];
        [self.player play];
        self.playSongBtn.selected = YES;
        [self.playSongBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
        [self startRoll];
        
        [_lyricTableView reloadData];
        [_lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        NSLog(@"currentIndex%ld",(long)_currentIndex);
    }
}
- (IBAction)moreBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self layoutIfNeeded];
    if (sender.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.otherViewBottom.constant = 0;
            [self layoutIfNeeded];
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.otherViewBottom.constant = -50;
            [self layoutIfNeeded];
        }];
    }
}
#pragma mark 变速播放
- (IBAction)roteWithPlay:(UIButton *)sender {
    _RateTag++;
    switch (_RateTag % 5) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"Oval 5"] forState:UIControlStateNormal];
            [self.player setRate:1.0];
            break;
        case 1:
            [sender setImage:[UIImage imageNamed:@"times_0.5x"] forState:UIControlStateNormal];
            [self.player setRate:0.5];
            break;
        case 2:
            [sender setImage:[UIImage imageNamed:@"times_0.8x"] forState:UIControlStateNormal];
            [self.player setRate:0.8];
            break;
        case 3:
            [sender setImage:[UIImage imageNamed:@"times_1.2x"] forState:UIControlStateNormal];
            [self.player setRate:1.2];
            break;
        case 4:
            [sender setImage:[UIImage imageNamed:@"times_1.5x"] forState:UIControlStateNormal];
            [self.player setRate:1.5];
            break;
        default:
            break;
    }
}
#pragma mark 中英文切换
- (IBAction)ENAndCN:(UIButton *)sender {
    _CNTag++;
    switch (_CNTag % 4) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"Group 13 Copy"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 1:
            [sender setImage:[UIImage imageNamed:@"switch_En"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 2:
            [sender setImage:[UIImage imageNamed:@"switch_Ch"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 3:
            [sender setImage:[UIImage imageNamed:@"switch_no"] forState:UIControlStateNormal];
            self.backImageView.hidden = NO;
        default:
            break;
    }
    [self.lyricTableView reloadData];
    [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}
#pragma mark 播放完成
- (void)playFinished:(NSNotification *)notifi{
    [self.player seekToTime:0];
    _currentIndex = 0;
    [self.player pause];
    if (self.playSongBtn.selected) {
        [self playSong:self.playSongBtn];
    }
    [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        if (self.progressSlider.state != UIControlStateHighlighted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *time = [NSString stringWithFormat:@"%@/%@ ",[self convertStringWithTime:self.player.progress * self.player.duration], [self convertStringWithTime:self.player.duration]];
                [self.progressSlider setValue:self.player.progress andTime:time animated:YES];
            });
        }
    }
    //    if ([keyPath isEqualToString:@"duration"]) {
    //        if (self.player.duration > 0) {
    //            self.timeLb.text = [self convertStringWithTime:self.player.duration];
    //            self.timeLb.hidden = NO;
    //        }else {
    //            self.timeLb.hidden = YES;
    //        }
    //    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        //
    }
}
#pragma mark 歌词滚动
- (void)scrollLyric{
    NSString *secNow = [self convertStringWithTime:self.player.progress * self.player.duration];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSInteger i =  _currentIndex + 1; i < timeArray.count; i++) {
            NSString *time = [timeArray[i] substringWithRange:NSMakeRange(0, 5)];
            if ([time isEqualToString:secNow]) {
                _currentIndex = i;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    NSLog(@"scrollLyric/currentIndex%ld",(long)_currentIndex);
                });
                break;
            }
        }
    });
}
- (NSString *)convertStringWithTime:(float)time {
    if (isnan(time)) time = 0.2f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}
#pragma mark UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return timeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListenTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listenLb.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    NSString *lrc = lyricArray[indexPath.row];
    NSLog(@"%d",_CNTag);
    if ([lrc containsString:@"/"]) {
        NSArray *array = [lrc componentsSeparatedByString:@"/"];
        switch (_CNTag % 4) {
            case 0:
                cell.listenLb.text = [NSString stringWithFormat:@"%@\n%@", array[0],array[1]];
                break;
            case 1:
                cell.listenLb.text = array[0];
                break;
            case 2:
                cell.listenLb.text = array[1];
                break;
            case 3:
                cell.listenLb.text = @"";
                break;
            default:
                break;
        }
    }else{
        if (_CNTag % 4 == 2 || _CNTag % 4 == 3 ) {
            cell.listenLb.text = @"";
        }else{
            cell.listenLb.text = lrc;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentIndex = (int)indexPath.row;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didMoveToWindow{
    [self stopRoll];
}
@end
