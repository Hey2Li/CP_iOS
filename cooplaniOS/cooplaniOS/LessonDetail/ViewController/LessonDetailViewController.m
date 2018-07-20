//
//  LessonDetailViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonDetailViewController.h"
#import "BuyLessonViewController.h"

@interface LessonDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation LessonDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    self.title = @"课程详情";
}
- (void)initWithView{
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://wx.cooplan.cn/methods.html"]];
    [webView loadRequest:request];
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view);
    }];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UILabel *priceLb = [UILabel new];
    [bottomView addSubview:priceLb];
    [priceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView.mas_centerX).offset(20);
        make.height.equalTo(@50);
        make.left.equalTo(bottomView).offset(20);
    }];
    priceLb.text = @"￥29";
    priceLb.textColor = UIColorFromRGB(0xD76F67);
    [priceLb setFont:[UIFont boldSystemFontOfSize:26]];
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLb.mas_right);
        make.height.equalTo(@50);
        make.right.equalTo(bottomView);
        make.centerY.equalTo(bottomView);
    }];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyBtn setBackgroundColor:UIColorFromRGB(0xD76F67)];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(-3, 0);
    bottomView.layer.shadowOpacity = 0.4;
}
- (void)buy:(UIButton *)btn{
    BuyLessonViewController *vc = [[BuyLessonViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
