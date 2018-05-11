//
//  MyDownloadViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyDownloadViewController.h"
#import "MyCollectionPaperTableViewCell.h"
#import "PaperDetailViewController.h"

@interface MyDownloadViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation MyDownloadViewController
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCollectionPaperTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的下载";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 74)];
    view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    UILabel *dowloadLb = [[UILabel alloc]init];
    dowloadLb.text = @"正在下载";
    dowloadLb.font = [UIFont systemFontOfSize:16];
    dowloadLb.textColor = UIColorFromRGB(0x666666);
    [view addSubview:dowloadLb];
    [dowloadLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(16);
        make.centerY.equalTo(view.mas_centerY);
        make.width.equalTo(@70);
    }];
    
    UILabel *numLabel = [[UILabel alloc]init];
    numLabel.text = @"0";
    numLabel.font = [UIFont systemFontOfSize:16];
    numLabel.textColor = UIColorFromRGB(0xFFBE2E);
    [view addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dowloadLb.mas_right);
        make.width.equalTo(@15);
        make.centerY.equalTo(dowloadLb);
    }];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionPaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    [cell.dowloadBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    cell.selectionStyle = NO;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 从数据源中删除
    //    [_data removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    //    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PaperDetailViewController *vc = [[PaperDetailViewController alloc]init];
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
