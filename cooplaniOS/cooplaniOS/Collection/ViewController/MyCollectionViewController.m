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
#import "TestModeViewController.h"
#import "LTDownloadView.h"

@interface MyCollectionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *downloadVoiceUrl;
@property (nonatomic, copy) NSString *downloadlrcUrl;
@property (nonatomic, copy) NSString *downloadJsonUrl;
@property (nonatomic, strong) DownloadFileModel *downloadModel;
@property (nonatomic, strong) LTDownloadView *downloadView;
@property (nonatomic, copy) NSString *voiceSize;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
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
    self.downloadModel = [[DownloadFileModel alloc]init];
    [self loadData];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCollectionModel *onePaperModel = self.dataArray[indexPath.row];
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *urlString = [Dmodel.paperVoiceName stringByRemovingPercentEncoding];
//    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", caches, urlString];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if ([fileManager fileExistsAtPath:fullPath]) {
//        [self.dowloadBtn setImage:[UIImage imageNamed:@"downloaded"] forState:UIControlStateNormal];
//        self.dowloadBtn.enabled = NO;
//    }
    DownloadFileModel *model = [DownloadFileModel jr_findByPrimaryKey:[NSString stringWithFormat:@"%ld", onePaperModel.ID]];
    if (model.paperJsonName == nil || [model.paperJsonName isEqualToString:@""] || [model.paperJsonName hasPrefix:@"http"]) {
        [LTHttpManager findOneTestPaperWithID:@(onePaperModel.ID) Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                self.downloadVoiceUrl = data[@"responseData"][@"voiceUrl"];
                self.downloadlrcUrl = data[@"responseData"][@"lic"];
                self.downloadJsonUrl = data[@"responseData"][@"testPaperUrl"];
                self.downloadModel.testPaperId = data[@"responseData"][@"id"];
                self.downloadModel.name = data[@"responseData"][@"name"];
                self.downloadModel.info = data[@"responseData"][@"info"];
                self.downloadModel.number = data[@"responseData"][@"number"];
                self.voiceSize = data[@"responseData"][@"size"];
                if (model.paperVoiceName == nil || [model.paperVoiceName isEqualToString:@""]) {
                    self.downloadModel.paperVoiceName = self.downloadVoiceUrl;
                    J_Update(self.downloadModel).Columns(@[@"paperVoiceName"]).updateResult;
                }
                [USERDEFAULTS setObject:[NSString stringWithFormat:@"%ld", (long)onePaperModel.ID] forKey:@"testPaperId"];
                [LTHttpManager downloadURL:self.downloadJsonUrl progress:^(NSProgress *downloadProgress) {
                    
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    self.downloadModel.paperJsonName = fileName;
                    J_Update(self.downloadModel).Columns(@[@"paperJsonName"]).updateResult;
                } failure:^(NSError *error) {
                    
                }];
                [LTHttpManager downloadURL:self.downloadlrcUrl progress:^(NSProgress *downloadProgress) {
                    
                } destination:^(NSURL *targetPath) {
                    NSString *url = [NSString stringWithFormat:@"%@",targetPath];
                    NSString *fileName = [url lastPathComponent];
                    self.downloadModel.paperLrcName = fileName;
                    J_Update(self.downloadModel).Columns(@[@"paperLrcName"]).updateResult;
                    TestModeViewController *vc = [[TestModeViewController alloc]init];
                    vc.testPaperId = [NSString stringWithFormat:@"%ld",onePaperModel.ID];
                    [self.navigationController pushViewController:vc animated:YES];
                } failure:^(NSError *error) {
                    
                }];
                J_Insert(self.downloadModel).updateResult;
            }else{
                [USERDEFAULTS setObject:[NSString stringWithFormat:@"%ld", (long)onePaperModel.ID] forKey:@"testPaperId"];
            }
        }];
    }else{
        TestModeViewController *vc = [[TestModeViewController alloc]init];
        vc.testPaperId = [NSString stringWithFormat:@"%ld",onePaperModel.ID];
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}

- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager FindAllWithUseId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self.dataArray removeAllObjects];
                NSArray *array = data[@"responseData"];
                NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
                for (NSDictionary *dic in array) {
                    muDict = [NSMutableDictionary dictionaryWithDictionary:dic[@"tp"]];
                    [muDict addEntriesFromDictionary:@{@"collection":dic[@"type"]}];
                    MyCollectionModel *model = [MyCollectionModel mj_objectWithKeyValues:muDict];
                    [self.dataArray addObject:model];
                }
                if (self.dataArray.count == 0) {
                    SVProgressShowStuteText(@"暂无收藏", NO);
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
