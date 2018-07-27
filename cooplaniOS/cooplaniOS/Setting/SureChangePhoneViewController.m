//
//  SureChangePhoneViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SureChangePhoneViewController.h"
#import "SettingViewController.h"

@interface SureChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneTF;
@property (weak, nonatomic) IBOutlet UIButton *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation SureChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.sureChangeBtn.layer setCornerRadius:8.0f];
    [self.sureChangeBtn.layer setMasksToBounds:YES];
    self.title = @"设置";
}
- (IBAction)sureChangePhoneBtnClick:(id)sender {
    if (self.telephoneTF.text.length > 0) {
        if (self.codeTextField.text.length > 0) {
            [LTHttpManager verifyCodeUpdatePhoneWithUserId:IS_USER_ID Phone:self.telephoneTF.text Code:self.codeTextField.text Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    SVProgressShowStuteText(@"换绑成功", YES);
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[SettingViewController class]]) {
                            SettingViewController *revise = (SettingViewController *)controller;
                            [self.navigationController popToViewController:revise animated:YES];
                        }
                    }
                }
            }];
        }else{
            SVProgressShowStuteText(@"请输入验证码", NO);
        }
    }else{
        SVProgressShowStuteText(@"请输入手机号码", NO);
    }
}
- (IBAction)getCode:(UIButton *)sender {
    if ([Tool judgePhoneNumber:self.telephoneTF.text]) {
        [LTHttpManager UserSMSCodeWithPhone:self.telephoneTF.text Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                sender.enabled = NO;
                SVProgressShowStuteText(@"验证码已发送", YES);
                [self openCountdown];
            }else{
                SVProgressShowStuteText(message, NO);
            }
        }];
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
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
                                                  @"重新发送"];
//                [str addAttribute:NSForegroundColorAttributeName value:
//                 UIColorFromRGB(0xCCCCCC) range:NSMakeRange(0,7)];
//                [str addAttribute:NSForegroundColorAttributeName value:
//                 UIColorFromRGB(0x4A90E2) range:NSMakeRange(7,4)];
//                [str addAttribute:NSUnderlineStyleAttributeName value:
//                 [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, 4)]; // 下划线
//                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
                [self.getCodeBtn setTitle:[str string] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2d",seconds] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
