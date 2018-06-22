//
//  MyCollectionViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionPaperTableViewCell.h"
#import "myCollectionModel.h"
#import "PaperDetailViewController.h"

@interface MyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MyCollectionViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
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
#pragma mark UITableViewDegate&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionPaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = NO;
    cell.reloadData = ^{
        [tableView reloadData];
    };
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyCollectionModel *model = self.dataArray[indexPath.row];
        [LTHttpManager deleteCollectionTestPaperWithId:@(model.testPaperId) Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                // 从数据源中删除
                //    [_data removeObjectAtIndex:indexPath.row];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                // 从列表中删除
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"homereloaddata" object:nil];
                SVProgressShowStuteText(@"取消成功", YES);
            }else{
                SVProgressShowStuteText(@"取消失败", NO);
            }
        }];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionModel *model = self.dataArray[indexPath.row];
    PaperDetailViewController *vc = [[PaperDetailViewController alloc]init];
    [LTHttpManager findOneTestPaperInfoWithUserId:IS_USER_ID ? IS_USER_ID : @"" TestPaperId:@(model.testPaperId) Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"][@"tp"]];
            [muDict addEntriesFromDictionary:@{@"collection":data[@"responseData"][@"type"]}];
            PaperModel *onePaperModel = [PaperModel mj_objectWithKeyValues:muDict];
            MyCollectionPaperTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            vc.title = cell.paperName.text;
            vc.onePaperModel = onePaperModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:@"reloadCollection" object:nil];
}
- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager findAllCollectionTestPaperWithUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                [self.dataArray removeAllObjects];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (NSDictionary *dict in data[@"responseData"]) {
                        MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:dict];
                        [self.dataArray addObject:model];
                    }
                    if (self.dataArray.count == 0) {
                        SVProgressShowStuteText(@"暂无收藏", NO);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myTableView reloadData];
                    });
                });
            }else{
                SVProgressShowStuteText(message, NO);
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
