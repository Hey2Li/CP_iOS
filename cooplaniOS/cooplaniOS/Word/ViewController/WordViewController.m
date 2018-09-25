//
//  WordViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordViewController.h"
#import "WordBookTableViewCell.h"
#import "LearnWordGroupView.h"

@interface WordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isSelectedWordBook;
@end

@implementation WordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    self.title = @"单词学习";
    _isSelectedWordBook = NO;
}
- (void)initWithView{
     UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:255])];
    tableHeaderView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    //底部背景
    UIView *backView;
    if (UI_IS_IPHONE4) {
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64 - 100 , 750, 750)];
    }else{
        backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64, 750, 750)];
    }
    backView.backgroundColor = DRGBCOLOR;
    backView.layer.cornerRadius = 375;
    backView.layer.masksToBounds = YES;
    backView.clipsToBounds = YES;
    [tableHeaderView.layer setMasksToBounds:YES];
    [tableHeaderView addSubview:backView];
    [self.view addSubview:tableHeaderView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.separatorStyle = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordBookTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordBookTableViewCell class])];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView = tableView;
    
    self.myTableView.tableFooterView = [UIView new];
    
    self.view.backgroundColor = UIColorFromRGB(0xF7F7F7);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:152];
}
//修改sectionheader背景颜色
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = DRGBCOLOR;
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"选择词书"];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17]range:NSMakeRange(0, 3)];
    return [titleStr string];//17bold
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WordBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordBookTableViewCell class])];
    cell.selectionStyle = NO;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isSelectedWordBook) {
        LearnWordGroupView *learnWordGroupView = [[LearnWordGroupView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [learnWordGroupView show];
        [self.view addSubview:learnWordGroupView];
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
