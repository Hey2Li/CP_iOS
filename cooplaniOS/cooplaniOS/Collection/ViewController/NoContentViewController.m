//
//  NoContentViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/12/4.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "NoContentViewController.h"

@interface NoContentViewController ()

@end

@implementation NoContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.色、、
    self.view.backgroundColor = RGBCOLOR(248, 248, 248);
    self.navigationController.navigationBar.translucent = NO;
    UIImageView *img  = [UIImageView new];
    img.image = [UIImage imageNamed:@"形状-18-拷贝-2"];
    img.contentMode = UIViewContentModeCenter;
    [self.view addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
