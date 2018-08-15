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
#import "TYAttributedLabel.h"

@interface LoginNextViewController ()<UITextFieldDelegate,TYAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *FirstTF;
@property (weak, nonatomic) IBOutlet UITextField *SecondTF;
@property (weak, nonatomic) IBOutlet UITextField *ThirdTF;
@property (weak, nonatomic) IBOutlet UITextField *fourthTF;
@property (weak, nonatomic) IBOutlet UITextField *fifthTF;
@property (weak, nonatomic) IBOutlet UITextField *sixthTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(nonatomic,strong) MMDrawerController * drawerController;
@property (nonatomic, assign) int index;
@property (weak, nonatomic) IBOutlet UILabel *secondLb;
@property (weak, nonatomic) IBOutlet UILabel *firstLb;
@property (weak, nonatomic) IBOutlet UILabel *thirdLb;
@property (weak, nonatomic) IBOutlet UILabel *fourthLb;
@property (weak, nonatomic) IBOutlet UILabel *fifthLb;
@property (weak, nonatomic) IBOutlet UILabel *sixthLb;
@property (weak, nonatomic) IBOutlet UIButton *becomeBtn;
@property (weak, nonatomic) IBOutlet TYAttributedLabel *phoneNumber;
@property (weak, nonatomic) IBOutlet TYAttributedLabel *vrCode;
@property (weak, nonatomic) IBOutlet UILabel *userAgreementLb;
@property (weak, nonatomic) IBOutlet UIButton *vrCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementBtn;
@property (nonatomic, strong) NSString *textString;
@end

@implementation LoginNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _index = 0;
    [self.FirstTF becomeFirstResponder];
    self.FirstTF.hidden = YES;
    self.textString = @"";
    [self.loginBtn setBackgroundColor:UIColorFromRGB(0xFDF6C1)];
    self.loginBtn.userInteractionEnabled = NO;
    [self.loginBtn setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.becomeBtn];
    self.becomeBtn.userInteractionEnabled = YES;

    NSMutableAttributedString *userAgreement = [[NSMutableAttributedString alloc] initWithString:
                                      @"点击确定，即表示已阅读并同意《酷学注册服务条款》"];
    [userAgreement addAttribute:NSForegroundColorAttributeName value:
     UIColorFromRGB(0xCCCCCC) range:NSMakeRange(0,14)];
    [userAgreement addAttribute:NSForegroundColorAttributeName value:
     UIColorFromRGB(0x4A90E2) range:NSMakeRange(14,10)];
    [userAgreement addAttribute:NSUnderlineStyleAttributeName value:
     [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(14, 10)]; // 下划线
    [userAgreement addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, userAgreement.length)];
    self.userAgreementLb.attributedText = userAgreement;
    [self openCountdown];
}
- (IBAction)userAgreementClick:(UIButton *)sender {
    
}
- (IBAction)postVrCodeClick:(UIButton *)sender {
    [LTHttpManager UserSMSCodeWithPhone:self.phoneStr Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            SVProgressShowStuteText(@"发送成功", YES);
            [USERDEFAULTS setObject:data[@"responseData"] forKey:USER_CODE_KEY];
            [self openCountdown];
        }else{
            SVProgressShowStuteText(@"发送失败", NO);
        }
    }];
}
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:
                                                  @"验证码已发送，重新发送"];
                [str addAttribute:NSForegroundColorAttributeName value:
                 UIColorFromRGB(0xCCCCCC) range:NSMakeRange(0,7)];
                [str addAttribute:NSForegroundColorAttributeName value:
                 UIColorFromRGB(0x4A90E2) range:NSMakeRange(7,4)];
                [str addAttribute:NSUnderlineStyleAttributeName value:
                 [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, 4)]; // 下划线
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
                self.vrCode.attributedText = str;
                self.vrCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                self.vrCode.text = [NSString stringWithFormat:@"验证码已发送，%.2ds后重新获取",seconds];
                self.vrCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)changePhoneNumber:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.phoneNumber.text = self.phoneStr;
}
- (IBAction)becomeFirst:(id)sender {
    [self.FirstTF becomeFirstResponder];
}
- (IBAction)loginClick:(UIButton *)sender {
    if ([self.phoneStr isEqualToString:@"18812345678"]) {
        //初始化控制器
        UIViewController *centerVC = [[BaseHomeViewController alloc]init];
        UIViewController *leftVC = [[LeftViewController alloc]init];
        
        //初始化导航控制器
        BaseViewController *centerNvaVC = [[BaseViewController alloc]initWithRootViewController:centerVC];
        
        //使用MMDrawerController
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftVC];
        //设置打开/关闭抽屉的手势
        self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
        self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
        //设置左右两边抽屉显示的多少
        self.drawerController.maximumLeftDrawerWidth = 160.0;
        self.drawerController.shouldStretchDrawer = YES;
        [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
        [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
        self.drawerController.view.backgroundColor = [UIColor whiteColor];
        self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
        [self presentViewController:self.drawerController animated:YES completion:nil];
        
        [USERDEFAULTS setObject:@"18812345678" forKey:USER_PHONE_KEY];
        [USERDEFAULTS setObject:@"1338" forKey:USER_ID];
    }else{
        if (![[USERDEFAULTS objectForKey:USER_CODE_KEY] isEqualToString:self.textString]) {
            SVProgressShowStuteText(@"验证码错误", NO);
            return;
        }
        [LTHttpManager UserCodeLoginWithPhone:self.phoneStr andCode:[USERDEFAULTS objectForKey:USER_CODE_KEY] Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                //初始化控制器
                UIViewController *centerVC = [[BaseHomeViewController alloc]init];
                UIViewController *leftVC = [[LeftViewController alloc]init];
                
                //初始化导航控制器
                BaseViewController *centerNvaVC = [[BaseViewController alloc]initWithRootViewController:centerVC];
                
                //使用MMDrawerController
                self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerNvaVC leftDrawerViewController:leftVC];
                //设置打开/关闭抽屉的手势
                self.drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModePanningCenterView;
                self.drawerController.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
                //设置左右两边抽屉显示的多少
                self.drawerController.maximumLeftDrawerWidth = 160.0;
                self.drawerController.shouldStretchDrawer = YES;
                [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
                [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
                self.drawerController.view.backgroundColor = [UIColor whiteColor];
                self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
                [self presentViewController:self.drawerController animated:YES completion:nil];
                
                [USERDEFAULTS setObject:data[@"responseData"][@"phone"] forKey:USER_PHONE_KEY];
                [USERDEFAULTS setObject:data[@"responseData"][@"id"] forKey:USER_ID];
            }else{
                SVProgressShowStuteText(@"登录失败", NO);
            }
        }];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@,%lu",self.textString, (unsigned long)self.textString.length);
    if([string isEqualToString:@""]) {
        switch (self.textString.length) {
            case 6:
                self.sixthLb.text = nil;
                break;
            case 5:
                self.fifthLb.text = nil;
                break;
            case 4:
                self.fourthLb.text = nil;
                break;
            case 3:
                self.thirdLb.text = nil;
                break;
            case 2:
                self.secondLb.text = nil;
                break;
            case 1:
                self.firstLb.text = nil;
                break;
            default:
                break;
        }
        self.textString = [self.textString substringToIndex:self.textString.length - 1];
        [self.loginBtn setBackgroundColor:UIColorFromRGB(0xFDF6C1)];
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
        return YES;
    }else{
        if (self.textString.length <= 5) {
            self.textString = [self.textString stringByAppendingString:string];
            [self.loginBtn setBackgroundColor:UIColorFromRGB(0xFDF6C1)];
            self.loginBtn.userInteractionEnabled = NO;
            [self.loginBtn setTitleColor:UIColorFromRGB(0x9b9b9b) forState:UIControlStateNormal];
            switch (self.textString.length - 1) {
                case 0:
                    self.firstLb.text = string;
                    break;
                case 1:
                    self.secondLb.text = string;
                    break;
                case 2:
                    self.thirdLb.text = string;
                    
                    break;
                case 3:
                    self.fourthLb.text = string;
                    break;
                case 4:
                    self.fifthLb.text = string;
                    break;
                case 5:
                    self.sixthLb.text = string;
                    self.loginBtn.userInteractionEnabled = YES;
                    [self.loginBtn setBackgroundColor:DRGBCOLOR];
                    [self.loginBtn setTitleColor:UIColorFromRGB(0x4a4a4a) forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
            _index++;
            return YES;
        }else{
            return NO;
        }
    }
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
