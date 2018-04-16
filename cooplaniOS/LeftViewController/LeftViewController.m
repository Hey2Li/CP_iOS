//
//  LeftViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LeftViewController.h"
#import "MyNoteViewController.h"
#import "MyCollectionViewController.h"
#import "MyDownloadViewController.h"
#import "WrongTopicViewController.h"
#import "SettingViewController.h"

@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
}
- (void)initWithView{
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 200, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [self.view addSubview:tableView];
}
#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:45];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DRGBCOLOR;
    cell.selectedBackgroundView = view;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"我的笔记";
            cell.imageView.image = [UIImage imageNamed:@"note"];
            break;
        case 1:
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"collection"];
            break;
        case 2:
            cell.textLabel.text = @"错题本";
            cell.imageView.image = [UIImage imageNamed:@"errorlog"];
            break;
        case 3:
            cell.textLabel.text = @"我的下载";
            cell.imageView.image = [UIImage imageNamed:@"download"];
            break;
        case 4:
            cell.textLabel.text = @"设置";
            cell.imageView.image = [UIImage imageNamed:@"settings"];
        default:
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *VC;
    switch (indexPath.row) {
        case 0:{
            VC = [[MyNoteViewController alloc]init];
        }
            break;
        case 1:{
            VC = [[MyCollectionViewController alloc]init];
        }
            break;
        case 2:{
            VC = [[WrongTopicViewController alloc]init];
        }
            break;
        case 3:{
            VC = [[MyDownloadViewController alloc]init];
        }
            break;
        case 4:{
            VC = [[SettingViewController alloc]init];
        }
        default:
            break;
    }
   //拿到我们的ViewController，让它去push
    UINavigationController* nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:VC animated:NO];
    //当我们push成功之后，关闭我们的抽屉
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        //设置打开抽屉模式为MMOpenDrawerGestureModeNone，也就是没有任何效果。
        [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
        [tableView deselectRowAtIndexPath:indexPath animated:NO]; 
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
