//
//  ChangePhoneViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "SureChangePhoneViewController.h"

@interface ChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telephoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.nextStepBtn.layer setCornerRadius:8.0f];
    [self.nextStepBtn.layer setMasksToBounds:YES];
    self.title = @"设置";
}
- (IBAction)getCode:(UIButton *)sender {
    sender.enabled = NO;
    if ([Tool judgePhoneNumber:self.telephoneTF.text]) {
        [LTHttpManager UserSMSCodeWithPhone:self.telephoneTF.text Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                [self openCountdown];
            }
        }];
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
        sender.enabled = YES;
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
                [str addAttribute:NSForegroundColorAttributeName value:
                 UIColorFromRGB(0xCCCCCC) range:NSMakeRange(0,7)];
                [str addAttribute:NSForegroundColorAttributeName value:
                 UIColorFromRGB(0x4A90E2) range:NSMakeRange(7,4)];
                [str addAttribute:NSUnderlineStyleAttributeName value:
                 [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(7, 4)]; // 下划线
                [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
                [self.getCodeBtn setTitle:[str string] forState:UIControlStateNormal];
                self.getCodeBtn.enabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%.2d",seconds] forState:UIControlStateNormal];
                self.getCodeBtn.enabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
- (IBAction)nextStepBtnClick:(id)sender {
    [LTHttpManager VerifyCodeWithPhone:self.telephoneTF.text Code:self.codeTF.text Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            SureChangePhoneViewController *vc = [[SureChangePhoneViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
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
