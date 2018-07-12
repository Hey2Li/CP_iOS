//
//  PaySuccessViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "BuyLessonTableHeaderView.h"
#import "PaySuccessTableViewCell.h"

@interface PaySuccessViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) BuyLessonTableHeaderView *headerView;
@end
@implementation PaySuccessViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        _myTableView.scrollEnabled = NO;
        _myTableView.backgroundColor = UIColorHex(0xf7f7f7);
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PaySuccessTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PaySuccessTableViewCell class])];
    }
    return _myTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"课程详情";
    [self initWithView];
}
- (void)initWithView{
    self.headerView = [[BuyLessonTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    [self.headerView selectIndex:HeaderSelectLearn];
    self.myTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.myTableView];
    
    UIButton *nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:nextStepBtn];
    [self.view bringSubviewToFront:nextStepBtn];
    [nextStepBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTableView.mas_left).offset(48);
        make.right.equalTo(self.myTableView.mas_right).offset(-48);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.myTableView.mas_bottom).offset(-145);
    }];
    [nextStepBtn.layer setCornerRadius:8.0f];
    [nextStepBtn setBackgroundColor:UIColorFromRGB(0xd76f67)];
    [nextStepBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    [nextStepBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextStepBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    nextStepBtn.tag = 1;
    [self.headerView selectIndex:2];
}
- (void)nextStep:(UIButton *)btn{
    [self.headerView selectIndex:btn.tag++];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaySuccessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaySuccessTableViewCell class])];
    return cell;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
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
