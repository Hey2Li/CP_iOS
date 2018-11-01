//
//  ReadTestListViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/31.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadTestListViewController.h"
#import "MyCollectionPaperTableViewCell.h"
#import "LTDownloadView.h"
#import "ReadTestViewController.h"

@interface ReadTestListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ReadTestListViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCollectionPaperTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    }
    return _myTableView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"模拟考场";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
    [self loadData];
}
- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager searchAllReadingTestWithComplete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self.dataArray removeAllObjects];
                NSArray *array = data[@"responseData"];
                for (NSDictionary *dic in array) {
                    MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dic];
                    [self.dataArray addObject:model];
                }
                [self.myTableView reloadData];
            }else{
                SVProgressShowStuteText(message, NO);
                self.myTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                    [self loadData];
                }];
            }
        }];
    }else{
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
        [alertView show];
        alertView.resultIndex = ^(NSInteger index) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
    }
}
#pragma mark UITableViewDegate&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionPaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    cell.testPaperListModel = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.dowloadBtn.hidden = YES;
    cell.fileSizeLb.hidden = YES;
    cell.fileImageView.hidden = YES;
    cell.selectionStyle = NO;
    cell.reloadData = ^{
        [tableView reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionModel *onePaperModel = self.dataArray[indexPath.row];
    LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"模拟考场需要一鼓作气的完成准备好了吗？" sureBtn:@"准备好了！" cancleBtn:@"改日再战"];
    alertView.resultIndex = ^(NSInteger index) {
        kPreventRepeatClickTime(3);
        [MobClick event:[NSString stringWithFormat:@"examinationpage_subject+%@", onePaperModel.name]];
        ReadTestViewController *vc = [[ReadTestViewController alloc]init];
        vc.testPaperNumber = [NSNumber numberWithInteger:[onePaperModel.number integerValue]];
        [self.navigationController pushViewController:vc animated:YES];
    };
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
