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
#import "FeedbackViewController.h"
#import "CollectionSentenceModel.h"
#import "CheckWordView.h"
#import "CHMagnifierView.h"

@interface ListenPaperViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) CADisplayLink *timer;//界面刷新定时器
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, assign) NSInteger songIndex;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;
@property (nonatomic, strong) NSMutableArray *lyricArray;
@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *lengthArray;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIPanGestureRecognizer *panGr;
@property (nonatomic, assign) int CNTag;//判断中英文
@property (nonatomic, assign) int RateTag;//判断播放器速率
@property (nonatomic, strong) UIView *wordView;
@property (nonatomic, copy)NSString *currentWord;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherVIewBottom;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) BOOL lastPlaying;
@property (nonatomic, strong) CheckWordView *checkWordView;
@property (nonatomic, strong) UILabel *wordLabel;
@property (strong, nonatomic) CHMagnifierView *magnifierView;

@end

@implementation ListenPaperViewController
@synthesize lyricArray;
@synthesize lengthArray;
@synthesize timeArray;
#pragma mark -lazy
- (UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc]init];
        _wordLabel.backgroundColor = UIColorFromRGB(0x688FD2);
        _wordLabel.font = [UIFont fontWithName:@".System-Light " size:17.0];
    }
    return _wordLabel;
}
- (CHMagnifierView *)magnifierView
{
    if (!_magnifierView) {
        _magnifierView = [[CHMagnifierView alloc] init];
        _magnifierView.viewToMagnify = self.lyricTableView.window;
    }
    return _magnifierView;
}
- (CheckWordView *)checkWordView{
    if (!_checkWordView) {
        _checkWordView = [[CheckWordView alloc]initWithFrame:CGRectMake(0, 0, 214, SCREEN_WIDTH)];
    }
    return _checkWordView;
}
- (SUPlayer *)player{
    if (!_player) {
        //网络
        //    NSURL *url = [NSURL URLWithString:[self songURLList][self.songIndex]];
        //本地
        DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *urlString = [model.paperVoiceName stringByRemovingPercentEncoding];
        if ([urlString hasPrefix:@"http"]) {
            _player = [[SUPlayer alloc]initWithURL:[NSURL URLWithString:model.paperVoiceName]];
            [_player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
            [_player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
            [_player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
            [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
            [self.progressSlider setValue:self.player.progress andTime:@"00:00/00:00" animated:YES];
        }else{
            NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
            NSURL *fileUrl = [NSURL fileURLWithPath:fullPath];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:fullPath]) {
                _player = [[SUPlayer alloc]initWithURL:fileUrl];
                [_player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
                [_player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
                [_player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
                [self.progressSlider addTarget:self action:@selector(changeProgress:) forControlEvents:UIControlEventTouchUpInside];
                [self.progressSlider setValue:self.player.progress andTime:@"00:00/00:00" animated:YES];
                self.timeLb.hidden = YES;
            }else{
                SVProgressShowStuteText(@"请先下载资源", NO);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    return _player;
}
- (void)cacheSuccess{
    SVProgressHiden();
    SVProgressShowStuteText(@"缓存完成", YES);

    self.timeLb.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _CNTag = 0;
    _RateTag = 0;
    [self initWithView];
    [self loadLongPress];
    [self.player play];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cacheSuccess) name:@"cacheSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playFinished:) name:@"playFinished" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPause) name:@"listenBackground" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(listenPlay) name:@"listenForeground" object:nil];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    //添加手势
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(event:)];
    //将手势添加到需要相应的view中去
    [_lyricTableView addGestureRecognizer:tapGesture];
    //选择触发事件的方式（默认单机触发）
    [tapGesture setNumberOfTapsRequired:1];
}
- (void)event:(UITapGestureRecognizer *)tap{
    self.wordLabel.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated{
    [self.player pause];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSArray *gestureArray = self.navigationController.view.gestureRecognizers;//获取所有的手势
    
    //当是侧滑手势的时候设置panGestureRecognizer需要UIScreenEdgePanGestureRecognizer失效才生效即可
    for (UIGestureRecognizer *gesture in gestureArray) {
        if ([gesture isKindOfClass:[UISlider class]]) {
        }else{
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopRoll];
    [self.player pause];
    [self.playSongBtn setSelected:NO];
}
- (void)listenPause{
    NSLog(@"---%d",_lastPlaying ? 1:0);
    _lastPlaying = [self.player isPlaying];
    [self stopRoll];
    [self.player pause];
    [self.playSongBtn setSelected:NO];
}
- (void)listenPlay{
    NSLog(@"---%d",_lastPlaying ? 1:0);
    if (_lastPlaying) {
        [self.playSongBtn setSelected:YES];
        [self.player play];
        [self startRoll];
    }else{
        [self stopRoll];
        [self.player pause];
        [self.playSongBtn setSelected:NO];
    }
}
- (void)initWithView{
    self.lyricTableView.delegate = self;
    self.lyricTableView.dataSource = self;
    self.lyricTableView.separatorStyle = NO;
    self.lyricTableView.estimatedRowHeight = 30.0f;
    self.lyricTableView.rowHeight = UITableViewAutomaticDimension;
    self.lyricTableView.showsVerticalScrollIndicator = NO;
    [self.lyricTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListenTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTableViewCell class])];
    self.lyricTableView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.otherView];

    [self parseLrc];
    self.backImageView.hidden = YES;
    [self.view bringSubviewToFront:self.backImageView];
}

#pragma mark 查词
- (void)loadLongPress{
    //添加长按手势
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = .2;
    [self.lyricTableView addGestureRecognizer:longPressGr];
}
//长按的方法
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];
            //设置放大镜位置
            [self magnifierPosition:point];
            //显示放大镜
//            [self.magnifierView makeKeyAndVisible];
//            获取cell 及其label上的单词
            [self wordsOnCell:point];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];
            //设置放大镜位置
            [self magnifierPosition:point];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint point = [gesture locationInView:self.lyricTableView];
            //长按结束取消放大镜
            [self.magnifierView setHidden:YES];
            //获取cell 及其label上的单词
            [self wordsOnCell:point];
            if (self.wordLabel.isHidden == NO) {
                [self.view addSubview:self.checkWordView];
                self.checkWordView.word = self.currentWord;
                [self.checkWordView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.width.equalTo(self.view.mas_width);
                    make.height.equalTo(@214);
                }];
                WeakSelf
                self.checkWordView.closeBlock = ^{
                    weakSelf.wordLabel.hidden = YES;
                };
                //调用查词方法
                NSLog(@"%@",self.currentWord);
            }
            break;
        }
        default:
            break;
    }
}
//设置放大镜位置
-(void)magnifierPosition:(CGPoint)point
{
    //设置放大镜的位置
    CGPoint magnifierPoint = point;
    int y = magnifierPoint.y + 20;
    magnifierPoint.y = y;
    self.magnifierView.pointToMagnify = magnifierPoint;
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
        frame.origin.x += cell.frame.origin.x + 14;
        frame.origin.y += cell.frame.origin.y + 3;
        frame.size.height += 4;
        //        frame.size.height += 2;
        frame.size.width += 4;
        if ([self pointInRectangle:frame point:point]) {
            self.wordLabel.hidden = NO;
            self.wordLabel.frame = frame;
            [self.wordLabel setTextColor:[UIColor whiteColor]];
            self.wordLabel.text = hyword.wordString;
            [self.wordLabel.layer setCornerRadius:2];
            [self.wordLabel.layer setMasksToBounds:YES];
            self.currentWord = hyword.wordString;
            [self.lyricTableView addSubview:self.wordLabel];
            return;
        }
    }
    self.wordLabel.hidden = YES;
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
    if ([gestureRecognizer.view isKindOfClass:[UISlider class]]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    return NO;
}
#pragma mark 解析歌词
- (void)parseLrc{
    DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *urlString = [model.paperLrcName stringByRemovingPercentEncoding];
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSString *lrcString = [[NSString alloc]initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
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
#pragma mark 单句收藏
- (IBAction)collectionOneSentence:(UIButton *)sender {
    ListenTableViewCell *cell = [self.lyricTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if (IS_USER_ID) {
        NSArray *array = [cell.listenLb.text componentsSeparatedByString:@"\n"];
        [LTHttpManager collectionSectenceWithUserId:IS_USER_ID SectenceEN:array.count ? array[0]:@"" SentenceCN:array.count > 1 ? array[1]:@"" TestPaperName:self.title Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
//                collectionSentenceModel *model = [[collectionSentenceModel alloc]init];
//                model.sentenceEN = array.count ? array[0]:@"";
//                model.sentenceCN = array.count > 1 ? array[1]:@"";
//                model.paperName = self.title;
//                [model jr_save];
                SVProgressShowStuteText(@"收藏成功", YES);
            }else{
                SVProgressShowStuteText(message, NO);
            }
        }];
    }else{
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
        [alertView show];
        alertView.resultIndex = ^(NSInteger index) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}
#pragma mark 内容纠错
- (IBAction)ContentError:(UIButton *)sender {
    FeedbackViewController *vc = [[FeedbackViewController alloc]init];
    vc.errorType = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 中英文切换
- (IBAction)ENCNSwitch:(UIButton *)sender {
    _CNTag++;
    switch (_CNTag % 4) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"双语"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 1:
            [sender setImage:[UIImage imageNamed:@"英文"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 2:
            [sender setImage:[UIImage imageNamed:@"中文"] forState:UIControlStateNormal];
            self.backImageView.hidden = YES;
            break;
        case 3:
            [sender setImage:[UIImage imageNamed:@"都没有"] forState:UIControlStateNormal];
            self.backImageView.hidden = NO;
        default:
            break;
    }
    [self.lyricTableView reloadData];
    [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
}
#pragma mark 变速播放
- (IBAction)RateWithPlay:(UIButton *)sender {
    _RateTag++;
    switch (_RateTag % 6) {
        case 0:
            [sender setImage:[UIImage imageNamed:@"1.2"] forState:UIControlStateNormal];
            [self.player setRate:1.2];
        case 1:
            [sender setImage:[UIImage imageNamed:@"0.5"] forState:UIControlStateNormal];
            [self.player setRate:0.5];
            break;
        case 2:
            [sender setImage:[UIImage imageNamed:@"1.0"] forState:UIControlStateNormal];
            [self.player setRate:1.0];
            break;
        case 3:
            [sender setImage:[UIImage imageNamed:@"1.5"] forState:UIControlStateNormal];
            [self.player setRate:1.5];
            break;
        case 4:
            [sender setImage:[UIImage imageNamed:@"0.8"] forState:UIControlStateNormal];
            [self.player setRate:0.8];
            break;
        case 5:
            [sender setImage:[UIImage imageNamed:@"1.0"] forState:UIControlStateNormal];
            [self.player setRate:1.0];
            break;
        default:
            break;
    }
}

#pragma mark 播放器相关
- (void)changeProgress:(UISlider *)slider {
//    DownloadFileModel *model = [DownloadFileModel  jr_findByPrimaryKey:self.testPaperId];
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *urlString = [model.paperVoiceName stringByRemovingPercentEncoding];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
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
                [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
                [self.lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                NSLog(@"scrollLyric/currentIndex%ld",(long)_currentIndex);
            });
        });
        
    }
    _lastPlaying = [self.player isPlaying];
//    if (![self.player currentItemCacheState] || [fileManager fileExistsAtPath:fullPath]) {
//        
//    }else{
//        if (![fileManager fileExistsAtPath:fullPath]) {
//            SVProgressShowStuteText(@"滑动播放需要先下载哟~", NO);
//            return;
//        }
//    }
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
        [_lyricTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
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
            self.otherVIewBottom.constant = - 50;
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
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.listenLb.textAlignment = NSTextAlignmentLeft;
    cell.listenLb.lineBreakMode = NSLineBreakByWordWrapping;
    cell.listenLb.preferredMaxLayoutWidth = cell.listenLb.width;
    cell.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1/1.0];
    NSString *lrc = lyricArray[indexPath.row];
    NSLog(@"%d",_CNTag);
    if ([lrc containsString:@"\r"]) {
        lrc = [lrc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        lrc = [lrc stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        lrc = [lrc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
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
    NSString *str = lyricArray[indexPath.row];
    NSString *str1 = timeArray[indexPath.row];
    NSLog(@"%@%@",str,str1);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [self.player removeObserver:self forKeyPath:@"progress" context:nil];
    [self.player removeObserver:self forKeyPath:@"duration" context:nil];
    [self.player removeObserver:self forKeyPath:@"cacheProgress" context:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player stop];
    [self stopRoll];
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
