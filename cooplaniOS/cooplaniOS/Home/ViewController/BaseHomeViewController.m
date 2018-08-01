//
//  BaseHomeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "BaseHomeViewController.h"
#import "HomeViewController.h"
#import "VBFPopFlatButton.h"
#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "HomeTopTitleView.h"
#import "LessonViewController.h"
#import "WordViewController.h"

@interface BaseHomeViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;
@property (nonatomic, strong) HomeTopTitleView *titleView;
@end

@implementation BaseHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithNavi];
    [self initWithView];
    [self setupLeftMenuButton];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = DRGBCOLOR;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //设置打开抽屉模式   这里要设置抽屉的打开和关闭，不能单一设置打开，不然就回不去了
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
#pragma mark 导航栏
- (void)initWithNavi{
    HomeTopTitleView *titleView  =[[HomeTopTitleView alloc]initWithTitleArray:@[@"听力", @"单词", @"课程"]];
    titleView.translatesAutoresizingMaskIntoConstraints = false;
    titleView.topTitleSwitchBlock = ^(NSInteger index) {
        [self.myScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (index - 10001), 0) animated:YES];
        NSLog(@"%ld",(long)index);
    };
    [titleView selectIndexBtn:1];
    self.titleView = titleView;
    self.navigationItem.titleView = titleView;
}
- (void)initWithView{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT)];
    
    HomeViewController *listenVC = [[HomeViewController alloc]init];
    [self addChildViewController:listenVC];
    [scrollView addSubview:listenVC.view];
    [scrollView bringSubviewToFront:listenVC.view];
    listenVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    LessonViewController *lessonVC = [[LessonViewController alloc]init];
    [self addChildViewController:lessonVC];
    [scrollView addSubview:lessonVC.view];
    [scrollView insertSubview:lessonVC.view atIndex:0];
    lessonVC.view.frame = CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH , SCREEN_HEIGHT);
    
    WordViewController *wordVC = [[WordViewController alloc]init];
    [self addChildViewController:wordVC];
    [scrollView addSubview:wordVC.view];
    wordVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    self.myScrollView = scrollView;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    //获取滑动偏移量
    float tagetX = targetContentOffset->x;
    //向左滑动时： 如果滑动后的X为最小（最小的X值），并且 为第一个控制器(contentOffsetX 为最小0)
    //向右滑动时： 如果滑动后的X为最大（最大的X值），并且为最后一个控制器（contentOffsetX 为最大）
    if (tagetX == 0 && self.myScrollView.contentOffset.x == 0 * SCREEN_WIDTH) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x / SCREEN_WIDTH);
    if (scrollView.contentOffset.x / SCREEN_WIDTH == 0) {
        [self.titleView selectIndexBtn:0];
    }else if (scrollView.contentOffset.x / SCREEN_WIDTH == 1){
        [self.titleView selectIndexBtn:1];
    }else if (scrollView.contentOffset.x / SCREEN_WIDTH == 2){
        [self.titleView selectIndexBtn:2];
    }
}
-(void)setupLeftMenuButton{
    self.flatRoundedButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)
                                                         buttonType:buttonMenuType
                                                        buttonStyle:buttonPlainStyle
                                              animateToInitialState:YES];
    self.flatRoundedButton.lineThickness = 2;
    self.flatRoundedButton.lineRadius = 1.0f;
    self.flatRoundedButton.tintColor = [UIColor blackColor];
    [self.flatRoundedButton addTarget:self
                               action:@selector(leftDrawerButtonPress:)
                     forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [view addSubview:self.flatRoundedButton];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:view];
    [self.navigationItem setLeftBarButtonItem:leftBtn animated:YES];
    WeakSelf
    [self.mm_drawerController setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        NSLog(@"%f",percentVisible);
        if (percentVisible == 1) {
            [weakSelf.flatRoundedButton animateToType:buttonCloseType];
        }else if (percentVisible == 0){
            [weakSelf.flatRoundedButton animateToType:buttonMenuType];
        }
    }];
}
-(void)leftDrawerButtonPress:(UIButton *)sender{
    self.flatRoundedButton.selected = !self.flatRoundedButton.selected;
    if (self.flatRoundedButton.selected) {
        [self.flatRoundedButton animateToType:buttonCloseType];
    }else{
        [self.flatRoundedButton animateToType:buttonMenuType];
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

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
