//
//  TestModeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestModeViewController.h"
#import "ListenPaperViewController.h"

@interface TestModeViewController ()

@end

@implementation TestModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ListenPaperViewController *vc  =[[ListenPaperViewController alloc]init];
    vc.view.bounds = self.view.bounds;
    [self.view addSubview:vc.view];
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
