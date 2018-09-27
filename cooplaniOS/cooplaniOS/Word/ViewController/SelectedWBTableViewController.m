//
//  SelectedWBTableViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "SelectedWBTableViewController.h"

@interface SelectedWBTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSUserDefaults *userDefaults;

@end

@implementation SelectedWBTableViewController
- (NSUserDefaults *)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}
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
    self.title = @"选择词书";
    self.tableView.tableFooterView = [UIView new];
    [self loadData];
}
- (void)loadData{
    [LTHttpManager findAllWordBookWithUser_id:IS_USER_ID?IS_USER_ID:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            self.dataArray = [NSMutableArray arrayWithArray:data[@"responseData"]];
            [self.tableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = self.dataArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.textColor = UIColorFromRGB(0xCCCCCC);
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@词", self.dataArray[indexPath.row][@"proWordNum"],self.dataArray[indexPath.row][@"num"]];
    cell.selectionStyle = NO;
    UIImage *imageGray = [UIImage imageNamed:@"词书选中"];
    UIImageView * accessoryViewGray=[[UIImageView alloc] initWithImage:imageGray];
    accessoryViewGray.frame=CGRectMake(0, 0, 16, 16);
    cell.accessoryView = accessoryViewGray;
    cell.accessoryView.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView.hidden = NO;
    if (self.dataArray.count) {
        [self.userDefaults setObject:[NSString stringWithFormat:@"%@", self.dataArray[indexPath.row][@"id"]] forKey:kWordBookId];
        if (self.wordBookNameAndNumBlock) {
            self.wordBookNameAndNumBlock(self.dataArray[indexPath.row][@"name"], self.dataArray[indexPath.row][@"num"]);
        }
        [LTHttpManager changeUserOpenWordbookWithUser_id:IS_USER_ID BookId:self.dataArray[indexPath.row][@"id"] Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@", self.dataArray[indexPath.row][@"id"]] forKey:kWordBookId];
                [[NSNotificationCenter defaultCenter]postNotificationName:kLoadWordHomePageData object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:kHomeReloadData object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
