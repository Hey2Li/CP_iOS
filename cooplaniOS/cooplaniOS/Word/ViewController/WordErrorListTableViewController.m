//
//  WordErrorListTableViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordErrorListTableViewController.h"
#import "WordListTableViewCell.h"
#import "ReciteWordModel.h"
#import "WordExplainTableViewController.h"

@interface WordErrorListTableViewController ()
@property (nonatomic, assign) int page_num;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WordErrorListTableViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordListTableViewCell class])];
    self.tableView.separatorStyle = NO;
    self.tableView.estimatedRowHeight = 60.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"您还没有单词"];
    _page_num = 1;
    [self loadData];
    [self footerLoadData];
}
- (void)loadData{
    [LTHttpManager searchOldWordWithUserId:IS_USER_ID ? IS_USER_ID : @"" WordBookId:@"1" Type:@(self.type) PageNum:@(_page_num) Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *array = data[@"responseData"];
            [self.dataArray removeAllObjects];
            for (NSDictionary *dict in array) {
                ReciteWordModel *model = [ReciteWordModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)footerLoadData{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _page_num++;
        [LTHttpManager searchOldWordWithUserId:IS_USER_ID ? IS_USER_ID : @"" WordBookId:@"1" Type:@(self.type) PageNum:@(_page_num) Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"];
                for (NSDictionary *dict in array) {
                    ReciteWordModel *model = [ReciteWordModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }else{
                [self.tableView.mj_footer endRefreshing];
                _page_num--;
            }
        }];
    }];
     footer.stateLabel.hidden = YES;
  
    self.tableView.mj_footer = footer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WordListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordListTableViewCell class])];
    // Configure the cell...
    cell.selectionStyle = NO;
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReciteWordModel *model = self.dataArray[indexPath.row];
    WordExplainTableViewController *vc = [[WordExplainTableViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
