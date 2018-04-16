//
//  LoginNextViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LoginNextViewController.h"
#import "BaseViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface LoginNextViewController ()
@property (weak, nonatomic) IBOutlet UITextField *FirstTF;
@property (weak, nonatomic) IBOutlet UITextField *SecondTF;
@property (weak, nonatomic) IBOutlet UITextField *ThirdTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;
@property (weak, nonatomic) IBOutlet UITextField *fifthTF;
@property (weak, nonatomic) IBOutlet UITextField *sixthTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (IBAction)loginClick:(UIButton *)sender {
    //初始化控制器
    UIViewController *centerVC = [[HomeViewController alloc]init];
    UIViewController *leftVC = [[LeftViewController alloc]init];
    
    //初始化导航控制器
    BaseViewController *centerNvaVC = [[BaseViewController alloc]initWithRootViewController:centerVC];
    
    //使用MMDrawerController
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftVC];
    //设置打开/关闭抽屉的手势
    self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
    self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    //设置左右两边抽屉显示的多少
    self.drawerController.maximumLeftDrawerWidth = 200.0;
    self.drawerController.maximumRightDrawerWidth = 200.0;
    self.drawerController.shouldStretchDrawer = YES;
    [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
    //把阴影关闭
    //    self.drawerController.showsShadow = YES;
    [self presentViewController:self.drawerController animated:YES completion:nil];
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
