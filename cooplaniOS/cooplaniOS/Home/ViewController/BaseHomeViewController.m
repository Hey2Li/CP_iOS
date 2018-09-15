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
#import "StartLearnWordViewController.h"
#import "BottomLabel.h"

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2 + 20, 44)];
    titleView.backgroundColor = DRGBCOLOR;
    
    BottomLabel *weekLb = [BottomLabel new];
    [titleView addSubview:weekLb];
    [weekLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.width.equalTo(@((SCREEN_WIDTH/2 + 20)/6*5));
    }];
    weekLb.font = [UIFont systemFontOfSize:26 weight:26];
    NSString *weekStr = [Tool dateArray][0];
    weekLb.text = [NSString stringWithFormat:@"%@ %@",weekStr.uppercaseString ,@""];
    weekLb.verticalAlignment = 2;
    weekLb.textColor = [UIColor blackColor];
    weekLb.textAlignment = NSTextAlignmentRight;
    
    BottomLabel *monthAndDayLb = [[BottomLabel alloc]init];
    [titleView addSubview:monthAndDayLb];
    [monthAndDayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weekLb.mas_right);
        make.right.equalTo(titleView.mas_right);
        make.bottom.equalTo(titleView).offset(-2);
        make.height.equalTo(weekLb);
    }];
    monthAndDayLb.verticalAlignment = 2;
    monthAndDayLb.font = [UIFont systemFontOfSize:14 weight:18];
    monthAndDayLb.textColor = [UIColor blackColor];
    monthAndDayLb.text = [NSString stringWithFormat:@"%@ %@",[Tool dateArray][2],[Tool dateArray][1]];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)initWithView{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:255])];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    //底部背景
    UIView *backView;
    if (UI_IS_IPHONE4) {
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64 - 100 , 750, 750)];
    }else{
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64 -100, 750, 750)];
    }
    backView.backgroundColor = DRGBCOLOR;
    backView.layer.cornerRadius = 375;
    backView.layer.masksToBounds = YES;
    backView.clipsToBounds = YES;
    //添加homeviewcontroller
    [self.view insertSubview:backView atIndex:0];
    HomeViewController *listenVC = [[HomeViewController alloc]init];
    [self addChildViewController:listenVC];
    listenVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:listenVC.view];
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
    //控制navigation 左滑动画
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
