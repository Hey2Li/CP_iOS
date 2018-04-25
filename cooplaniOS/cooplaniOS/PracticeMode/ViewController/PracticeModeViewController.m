//
//  PracticeModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PracticeModeViewController.h"

@interface PracticeModeViewController ()
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDownGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUpGR;
@property (nonatomic, assign) BOOL isOpen;
@end

@implementation PracticeModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.swipeDownGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    //    [self.swipeDownGR setDirection:UISwipeGestureRecognizerDirectionDown];
    //    [self.tikaCollectionView addGestureRecognizer:self.swipeDownGR];
    //
    //    [self.swipeUpGR setDirection:UISwipeGestureRecognizerDirectionUp];
    //    self.swipeUpGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeGR:)];
    //    [self.tikaCollectionView addGestureRecognizer:self.swipeUpGR];
    
    //    self.panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGr:)];
    //    [self.tikaCollectionView addGestureRecognizer:_panGr];
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
//cell.UpAndDownBtnClick = ^(UIButton *btn) {
//    if (_isOpen) {
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tikaCollectionView.transform = CGAffineTransformMakeTranslation(0, SCREEN_HEIGHT/3 + 50);
//        }];
//        _isOpen = NO;
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            self.tikaCollectionView.transform = CGAffineTransformIdentity;
//        }];
//        _isOpen = YES;
//    }
//};
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
