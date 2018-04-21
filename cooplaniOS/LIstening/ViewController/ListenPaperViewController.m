//
//  ListenPaperViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenPaperViewController.h"
#import "SUPlayer.h"
#import "UIImage+mask.h"
#import "UISlider+time.h"
#import "UILabel+HYLabel.h"
#import "HYWord.h"
#import "TikaCollectionViewCell.h"
#import "ListenTableViewCell.h"

@interface ListenPaperViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CADisplayLink *timer;//界面刷新定时器
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, assign) NSInteger songIndex;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherVIewBottom;
@property (nonatomic, assign) NSInteger lastIndex;
@end

@implementation ListenPaperViewController
@synthesize lyricArray;
@synthesize lengthArray;
@synthesize timeArray;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //网络
//    NSURL *url = [NSURL URLWithString:[self songURLList][self.songIndex]];
    //本地
    NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"2017年6月四级真题（一）" withExtension:@"MP3"];
    self.player = [[SUPlayer alloc]initWithURL:fileUrl];
    
    [self.player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressSlider setValue:self.player.progress andTime:@"00:00/00:00" animated:YES];
    self.timeLb.hidden = YES;
    _isOpen = YES;
    _CNTag = 0;
    _RateTag = 0;
    [self initWithView];
    [self loadLongPress];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:@"playFinished" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopRoll];
}

- (void)initWithView{
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.separatorStyle = NO;
    self.lyricTableView.estimatedRowHeight = 50.0f;
    self.lyricTableView.rowHeight = UITableViewAutomaticDimension;
    self.lyricTableView.showsVerticalScrollIndicator = NO;
    [self.lyricTableView registerNib:[UINib nibWithNibName:@"ListenTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTableViewCell class])];
    self.lyricTableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
//    [self.view addSubview:collectionView];
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.center.equalTo(self.view);
//        make.height.equalTo(@300);
//    }];
//
//    [self.view bringSubviewToFront:collectionView];
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.otherView];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TikaCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    self.swipeDownGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.swipeDownGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.tikaCollectionView addGestureRecognizer:self.swipeDownGR];

    [self.swipeUpGR setDirection:UISwipeGestureRecognizerDirectionUp];
    self.swipeUpGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.tikaCollectionView addGestureRecognizer:self.swipeUpGR];
    
//    self.panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGr:)];
//    [self.tikaCollectionView addGestureRecognizer:_panGr];

    [self parseLrc];
    self.backImageView.hidden = YES;
    [self.view bringSubviewToFront:self.backImageView];
}
#pragma mark 手势操作
- (void)SwipeGR:(UISwipeGestureRecognizer *)gr{
    NSLog(@"%lu",gr.direction);
    if (gr.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tikaCollectionView.transform = CGAffineTransformIdentity;
        }];
        _isOpen = YES;
    }
    if (gr.direction == UISwipeGestureRecognizerDirectionDown) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/3 + 50);
        }];
        _isOpen = NO;
    }
}
- (void)panGr:(UIPanGestureRecognizer *)pan{
    if (_isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2);
            _isOpen = !_isOpen;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.tikaCollectionView.transform = CGAffineTransformIdentity;
            _isOpen = !_isOpen;
        }];
    }
}
#pragma mark 查词
- (void)loadLongPress{
    //添加长按手势
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = .5;
    [self.lyricTableView addGestureRecognizer:longPressGr];
}
//长按的方法
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];

            //获取cell 及其label上的单词
            [self wordsOnCell:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
            if (self.wordView.isHidden == NO) {
                //调用查词方法
                NSLog(@"%@",self.currentWord);
            }
            break;
        }
        default:
            break;
    }
}
- (UIView *)wordView
{
    if (!_wordView) {
        _wordView = [[UIView alloc] init];
    }
    return _wordView;
}
- (void)wordsOnCell:(CGPoint)point
{
    NSIndexPath * indexPath = [self.lyricTableView indexPathForRowAtPoint:point];
    if(indexPath == nil)
        return ;
    ListenTableViewCell *cell = [self.lyricTableView cellForRowAtIndexPath:indexPath];
    //这个方法会提供 单词的 相对父视图的位置
    NSArray *strArray = [UILabel cuttingStringInLabel:cell.listenLb];
    for (HYWord *hyword in strArray) {
        CGRect frame = hyword.frame;
        frame.origin.x += cell.frame.origin.x + 15;
        frame.origin.y += cell.frame.origin.y + 12;
            if ([self pointInRectangle:frame point:point]) {
            self.wordView.hidden = NO;
            self.wordView.frame = frame;
            self.wordView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:.8 alpha:.5];;
            [self.lyricTableView addSubview:self.wordView];
            self.currentWord = hyword.wordString;
            return;
        }
    }
    self.wordView.hidden = YES;
}
//判断点在矩形内
- (BOOL) pointInRectangle:(CGRect )rech point:(CGPoint)clickPoint
{
    if (clickPoint.x > rech.origin.x && clickPoint.x < (rech.origin.x + rech.size.width) && clickPoint.y > rech.origin.y  &&  clickPoint.y < (rech.origin.y + rech.size.height)) {
        return YES;
    }
    return NO;
}

#pragma mark GestureRecgnizerdelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]] && [touch.view isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
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
#pragma mark 中英文切换
- (IBAction)ENCNSwitch:(UIButton *)sender {
    _CNTag++;
    switch (_CNTag % 4) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"switch_EnCh"] forState:UIControlStateNormal];
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
    [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
#pragma mark 变速播放
- (IBAction)RateWithPlay:(UIButton *)sender {
    _RateTag++;
    switch (_RateTag % 5) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"times_1x"] forState:UIControlStateNormal];
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

#pragma mark 播放器相关
- (void)changeProgress:(UISlider *)slider {
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
}
#pragma mark 播放完成
- (void)playFinished:(NSNotification *)notifi{
    [self.player seekToTime:0];
    _currentIndex = 0;
    [self.player pause];
    if (self.playSongBtn.selected) {
        [self paly:self.playSongBtn];
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

- (IBAction)paly:(UIButton *)sender {
    if (sender.selected) {
        [self.player pause];
        [self stopRoll];
    }else{
        [self.player play];
        [self startRoll];
        [self.lyricTableView reloadData];
    }
    sender.selected = !sender.selected;
}
- (IBAction)upSong:(id)sender {
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
        [_lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
//        NSArray *reloadRows = @[[NSIndexPath indexPathForRow:_currentIndex inSection:0],[NSIndexPath indexPathForRow:_lastIndex inSection:0]];
//        [self.lyricTableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
//        [self.lyricTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        //        [self scrollLyric];
        NSLog(@"%ld",(long)_currentIndex);
    }
}
- (IBAction)downSong:(id)sender {
    _lastIndex = _currentIndex;
    _currentIndex++;
    [self.player pause];
    [self stopRoll];
    if (_currentIndex > self.timeArray.count) {
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
        [_lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        NSLog(@"currentIndex%ld",(long)_currentIndex);
    }
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
#pragma mark 更多按钮
- (IBAction)moreBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.view layoutIfNeeded];
    if (sender.selected) {
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.otherVIewBottom.constant = 0;
            [self.view layoutIfNeeded];
        } completion:nil];
    }else{
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.otherVIewBottom.constant = - 45;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
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
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, 290);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TikaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class]) forIndexPath:indexPath];
    cell.UpAndDownBtnClick = ^(UIButton *btn) {
        if (_isOpen) {
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/3 + 50);
            }];
            _isOpen = NO;
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.transform = CGAffineTransformIdentity;
            }];
            _isOpen = YES;
        }
    };
    //    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
