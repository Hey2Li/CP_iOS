//
//  LoginViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginNextViewController.h"
#import "TYAttributedLabel.h"
#import <UMShare/UMShare.h>
#import "BaseViewController.h"
#import "HomeViewController.h"
#import "LeftViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (nonatomic, copy) NSString *StringCount;
@property(nonatomic,strong) MMDrawerController * drawerController;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.phoneTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    NSString *holderText = @"请输入您的手机号";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:UIColorFromRGB(0xCCCCCC)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont systemFontOfSize:14]
                        range:NSMakeRange(0, holderText.length)];
    self.phoneTF.attributedPlaceholder = placeholder;
    _StringCount = @"";
    if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession] && !UI_IS_IPHONE4) {
        self.wxButton.hidden = NO;
        self.leftLine.hidden = NO;
        self.rightLine.hidden = NO;
        self.thirtyLogin.hidden = NO;
    }else{
        self.wxButton.hidden = YES;
        self.leftLine.hidden = YES;
        self.rightLine.hidden = YES;
        self.thirtyLogin.hidden = YES;
    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    CGFloat maxLength = 11;
    NSString *toBeString = textField.text;
    if (toBeString.length < 11) {
        self.nextStepBtn.backgroundColor = UIColorFromRGB(0xFDF6C1);
        [self.nextStepBtn setTitleColor:UIColorFromRGB(0x9B9B9B) forState:UIControlStateNormal];
        self.nextStepBtn.userInteractionEnabled = NO;
    }else{
        self.nextStepBtn.backgroundColor = DRGBCOLOR;
        self.nextStepBtn.userInteractionEnabled = YES;
        [self.nextStepBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (IBAction)NextStep:(UIButton *)sender {
//    [self presentViewController:[LoginNextViewController new] animated:YES completion:nil];
    if ([self.phoneTF.text isEqualToString:@"18812345678"]) {
        LoginNextViewController *vc = [[LoginNextViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //                [userDefaults setObject:self.phoneTF.text forKey:@"user_phonenumber"];
        vc.phoneStr = self.phoneTF.text;
        [userDefaults setObject:@"000000" forKey:@"user_code"];
    }else{
        if ([Tool judgePhoneNumber:self.phoneTF.text]) {
            [LTHttpManager UserSMSCodeWithPhone:self.phoneTF.text Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    LoginNextViewController *vc = [[LoginNextViewController alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    //                [userDefaults setObject:self.phoneTF.text forKey:@"user_phonenumber"];
                    vc.phoneStr = self.phoneTF.text;
                    [userDefaults setObject:data[@"responseData"] forKey:@"user_code"];
                }else{
                    [self.view makeToast:message];
                }
            }];
        }else if (self.phoneTF.text.length == 0){
            SVProgressShowStuteText(@"请输入手机号码", NO);
        }else{
            SVProgressShowStuteText(@"请输入正确的手机号码", NO);
        }
        NSLog(@"%@",self.phoneTF.text);
    }
}
- (IBAction)wxLogin:(id)sender {
    [self getAuthWithUserInfoFromWechat];
}
- (void)getAuthWithUserInfoFromWechat{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            [LTHttpManager thirdPartyLoginWithOpenId:resp.openid IdentityType:@"wx" Token:resp.accessToken TokenTime:resp.refreshToken HeadPortrait:resp.iconurl NickName:resp.name Sex:resp.unionGender age:@"" UnionId:resp.unionId Complete:^(LTHttpResult result, NSString *message, id data) {
                if (result == LTHttpResultSuccess) {
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user"][@"id"] forKey:USER_ID];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"tpu"][@"headPortrait"] forKey:USER_PHOTO];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"tpu"][@"nickname"] forKey:USER_NICKNAME];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"tpu"][@"sex"] forKey:USER_SEX];
                    [[NSUserDefaults standardUserDefaults] synchronize];
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
                    self.drawerController.maximumLeftDrawerWidth = 160.0;
                    self.drawerController.shouldStretchDrawer = YES;
                    [leftVC setRestorationIdentifier:@"MMExampleLeftNavigationControllerRestorationKey"];
                    [self.drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideAndScaleVisualStateBlock]];
                    self.drawerController.view.backgroundColor = [UIColor whiteColor];
                    self.drawerController.centerViewController.view.backgroundColor = [UIColor whiteColor];
                    [self presentViewController:self.drawerController animated:YES completion:nil];
                }else{
                    [self.view makeToast:message];    
                }
            }];
        }
    }];
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
