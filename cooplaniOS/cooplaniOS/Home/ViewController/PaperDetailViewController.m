//
//  PaperDetailViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaperDetailViewController.h"
#import "PaperDetailTableViewCell.h"
#import "ListenPaperViewController.h"
#import "TestModeViewController.h"


@interface PaperDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation PaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:@"PaperDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PaperDetailTableViewCell class])];
    self.myTableView.scrollEnabled = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = [UIColor whiteColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaperDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaperDetailTableViewCell class])];
    if (indexPath.row == 1) {
        cell.modeImageView.image = [UIImage imageNamed:@"practicemode"];
        cell.titleLb.text = @"真题练习";
    }else if (indexPath.row == 2){
        cell.modeImageView.image = [UIImage imageNamed:@"testmode"];
        cell.titleLb.text = @"模拟考场";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ListenPaperViewController *vc = [[ListenPaperViewController alloc]init];
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        TestModeViewController *vc = [[TestModeViewController alloc]init];
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        SVProgressShowStuteText(@"暂未开放", NO);
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
