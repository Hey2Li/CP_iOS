//
//  TestModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestModeViewController.h"
#import "ListenPaperViewController.h"
#import "TikaCollectionViewCell.h"
#import "ListenPlay.h"
#import "AnswerViewController.h"
#import "TestModeBottomView.h"
#import "QuestionTableViewCell.h"
#import "SUPlayer.h"

@interface TestModeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@property (nonatomic, strong) UITableView *questionTableView;
@property (nonatomic, strong) TestModeBottomView *bottomView;
@property (nonatomic, strong) SUPlayer *player;
@end

@implementation TestModeViewController

- (SUPlayer *)player{
    if (!_player) {
        NSURL *fileUrl = [[NSBundle mainBundle]URLForResource:@"2017年6月四级真题（一）" withExtension:@"MP3"];
        _player = [[SUPlayer alloc]initWithURL:fileUrl];
        [_player addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
        [_player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
        [_player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _player;
}
- (UITableView *)questionTableView{
    if (!_questionTableView) {
        _questionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        [self.view addSubview:_questionTableView];
        [_questionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.tikaCollectionView.mas_top);
        }];
        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
        _questionTableView.estimatedRowHeight = 50;
        _questionTableView.rowHeight = UITableViewAutomaticDimension;
        _questionTableView.separatorStyle = NO;
        [_questionTableView registerNib:[UINib nibWithNibName:@"QuestionTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([QuestionTableViewCell class])];
    }
    return _questionTableView;
}
- (TestModeBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[TestModeBottomView alloc]init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.view);
        }];
    }
    return _bottomView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self.view setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.player stop];
}
#pragma mark 播放完成
- (void)playFinished:(NSNotification *)notifi{
    [self.player seekToTime:0];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"progress"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *time = [NSString stringWithFormat:@"%@",[self convertStringWithTime:self.player.progress * self.player.duration]];
            self.bottomView.leftTimeLb.text = time;
        });
    }
    if ([keyPath isEqualToString:@"cacheProgress"]) {
        //
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
- (void)initWithView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-10);
        make.height.equalTo(@(SCREEN_HEIGHT/2 - 25));
    }];

    collectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TikaCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    
    [self questionTableView];
    [self.bottomView.donePapersBtn addTarget:self action:@selector(donePaperClick:) forControlEvents:UIControlEventTouchUpInside];
    [self scrollViewDidScroll:collectionView];
 
}
- (void)donePaperClick:(UIButton *)btn{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定交卷" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[AnswerViewController alloc]init] animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT/2 - 25);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TikaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([TikaCollectionViewCell class]) forIndexPath:indexPath];
  
    cell.questionStr = [NSString stringWithFormat:@"这是第%ld题",indexPath.row + 1];
    cell.collectionIndexPath = indexPath;
    WeakSelf
    cell.questionCellClick = ^(NSIndexPath *cellIndexPath) {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:cellIndexPath.item + 1 inSection:0];
        NSLog(@"indexPathrow+1%ld---indexPath.row%ld",cellIndexPath.row + 1, cellIndexPath.row);
        if (cellIndexPath.row + 1 < 4) {
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tikaCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        }else if (indexPath.row == 3){
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    //    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tikaCollectionView) {
        int index = scrollView.contentOffset.x/SCREEN_WIDTH;
        self.bottomView.questionIndexLb.text = [NSString stringWithFormat:@"%d/%@",index+1, @4];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}
#pragma mark TableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuestionTableViewCell class])];
    return cell;
}
-(void)viewDidAppear:(BOOL)animated{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定考试" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.player play];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:sureAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
