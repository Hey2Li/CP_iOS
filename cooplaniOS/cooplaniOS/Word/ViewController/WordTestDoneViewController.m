//
//  WordTestDoneViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordTestDoneViewController.h"
#import "BaseHomeViewController.h"

@interface WordTestDoneViewController ()

@end

@implementation WordTestDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initWithNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)learnedDone:(UIButton *)sender {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BaseHomeViewController class]]) {
            BaseHomeViewController *revise = (BaseHomeViewController *)controller;
            [self.navigationController popToViewController:revise animated:YES];
        }
    }
}
- (void)initWithNavi{
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(learnedDone:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
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
