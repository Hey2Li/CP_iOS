//
//  PracticeModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PracticeModeViewController.h"
#import "ListenPlay.h"
#import "PracticeModeHeaderView.h"
#import "AnswerViewController.h"
#import "PracticeModeTiKaCCell.h"

@interface PracticeModeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGR;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) ListenPlay *player;
@property (nonatomic, strong) PracticeModeHeaderView *headerView;
@property (nonatomic, strong) UICollectionView *tikaCollectionView;
@end

@implementation PracticeModeViewController
- (ListenPlay *)player{
    if (!_player) {
        NSString *className = NSStringFromClass([ListenPlay class]);
        _player = [[UINib nibWithNibName:className bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    }
    return _player;
}
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UINib nibWithNibName:NSStringFromClass([PracticeModeHeaderView class]) bundle:nil]instantiateWithOwner:nil options:nil].firstObject;
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
}
- (void)initWithView{
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@86);
    }];
    
    [self.view addSubview:self.player];
    [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    self.swipeDownGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.swipeDownGR setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.tikaCollectionView addGestureRecognizer:self.swipeDownGR];
    
    [self.swipeUpGR setDirection:UISwipeGestureRecognizerDirectionUp];
    self.swipeUpGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    [self.tikaCollectionView addGestureRecognizer:self.swipeUpGR];
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 0;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowlayout];
    [self.player addSubview:collectionView];
    [self.player insertSubview:collectionView atIndex:1];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-175);
        make.top.equalTo(self.headerView.mas_bottom).offset(10);
    }];
    
    collectionView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[PracticeModeTiKaCCell class] forCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    self.tikaCollectionView = collectionView;
    [self scrollViewDidScroll:collectionView];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  4;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH, collectionView.bounds.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PracticeModeTiKaCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([PracticeModeTiKaCCell class]) forIndexPath:indexPath];
    
    cell.questionStr = [NSString stringWithFormat:@"这是第%ld题",indexPath.row + 1];
    cell.UpAndDownBtnClick = ^(UIButton *btn) {
        if (_isOpen) {
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2);
            }];
            _isOpen = NO;
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.tikaCollectionView.transform = CGAffineTransformIdentity;
            }];
            _isOpen = YES;
        }
    };
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
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark 手势操作
- (void)SwipeGR:(UISwipeGestureRecognizer *)gr{
    NSLog(@"%lu",gr.direction);
    [self.view layoutIfNeeded];
    if (gr.direction == UISwipeGestureRecognizerDirectionUp) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformIdentity;
        }];
        _isOpen = YES;
    }
    if (gr.direction == UISwipeGestureRecognizerDirectionDown) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/3 + 50);
        }];
        _isOpen = NO;
    }
}
- (void)panGr:(UIPanGestureRecognizer *)pan{
    [self.view layoutIfNeeded];
    if (_isOpen) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/2);
            _isOpen = !_isOpen;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
//            self.tikaCollectionView.transform = CGAffineTransformIdentity;
            _isOpen = !_isOpen;
        }];
    }
}
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.backgroundColor = [UIColor blackColor];
//        [self addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(tableView.mas_left);
//            make.right.equalTo(tableView.mas_right);
//            make.top.equalTo(self.mas_top);
//            make.bottom.equalTo(tableView.mas_top).offset(2);
//        }];
//        [btn setTitle:@"click" forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
