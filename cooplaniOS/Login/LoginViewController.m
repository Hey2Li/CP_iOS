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


@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (nonatomic, copy) NSString *StringCount;
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
