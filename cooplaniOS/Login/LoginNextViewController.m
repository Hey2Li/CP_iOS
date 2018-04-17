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
    [self addTextAttributed];
}
- (void)addTextAttributed {
    TYAttributedLabel *label = [[TYAttributedLabel alloc]init];
    [self.view addSubview:label];
    label.backgroundColor = [UIColor blackColor];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.FirstTF.mas_bottom).offset(25);
    }];
    // 规则声明
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:@"I agree to myApp "];
    [attributedString addAttributeTextColor:[UIColor blackColor]];
    [attributedString addAttributeFont:[UIFont systemFontOfSize:15]];
    [label appendTextAttributedString:attributedString];
    
    // 增加链接 Terms and Conditions
    [label appendLinkWithText:@"Terms and Conditions" linkFont:[UIFont systemFontOfSize:15] linkColor:[UIColor blueColor] linkData:@"https://www.baidu.com"];
    // And
    NSMutableAttributedString *attributedAndString = [[NSMutableAttributedString alloc]initWithString:@" and "];
    [attributedAndString addAttributeTextColor:[UIColor blackColor]];
    [attributedAndString addAttributeFont:[UIFont systemFontOfSize:15]];
    [label appendTextAttributedString:attributedAndString];
    
    // 增加链接 Privacy Polices
    [label appendLinkWithText:@"Privacy Polices" linkFont:[UIFont systemFontOfSize:15] linkColor:[UIColor blueColor] linkData:@"https://www.google.com"];
    
    [label sizeToFit];
}
#pragma mark - Delegate
//TYAttributedLabelDelegate
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)TextRun atPoint:(CGPoint)point {
    if ([TextRun isKindOfClass:[TYLinkTextStorage class]]) {
        NSString *linkStr = ((TYLinkTextStorage*)TextRun).linkData;
        NSLog(@"linkStr === %@",linkStr);
    }
}
- (IBAction)changePhoneNumber:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.phoneNumber.text = [userDefaults objectForKey:@"user_phonenumber"];
}
- (IBAction)becomeFirst:(id)sender {
    [self.FirstTF becomeFirstResponder];
}
- (IBAction)loginClick:(UIButton *)sender {
    if (![[USERDEFAULTS objectForKey:USER_CODE_KEY] isEqualToString:self.textString]) {
        SVProgressShowStuteText(@"验证码错误", NO);
        return;
    }
    [LTHttpManager UserCodeLoginWithPhone:[USERDEFAULTS objectForKey:USER_PHONE_KEY] andCode:[USERDEFAULTS objectForKey:USER_CODE_KEY] Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
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
            [self presentViewController:self.drawerController animated:YES completion:nil];
            [USERDEFAULTS setObject:data[@"responseData"][@"phone"] forKey:USER_PHONE_KEY];
            [USERDEFAULTS setObject:data[@"responseData"][@"id"] forKey:USER_ID];
        }else{
            SVProgressShowStuteText(@"登录失败", NO);
        }
    }];
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
