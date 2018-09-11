//
//  WordExplainTableViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordExplainTableViewController.h"
#import "WordDetailFirstCellTableViewCell.h"
#import "WordDetailSecondTableViewCell.h"
#import "WordDetailThirdTableViewCell.h"
#import "WordDetailFooterView.h"

@interface WordExplainTableViewController ()
@property(nonatomic, strong) WordDetailFooterView *footerView;
@end

@implementation WordExplainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailFirstCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailSecondTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailThirdTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
    
    self.tableView.separatorStyle = NO;
    self.tableView.estimatedRowHeight = 140.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    WordDetailFooterView *footerView = [[WordDetailFooterView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(SCREEN_HEIGHT - 85 - 64);
        make.height.equalTo(@85);
    }];
    self.footerView = footerView;
    self.footerView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setModel:(ReciteWordModel *)model{
    _model = model;
    self.title = model.word;
    [self.tableView reloadData];
    self.footerView.model = model;
    self.footerView.hidden = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }else{
        self.tableView.estimatedRowHeight = 110.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return  self.tableView.rowHeight;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WordDetailFirstCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 1){
        WordDetailSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
        cell.enAndZhLb.text = [NSString stringWithFormat:@"%@\n%@",self.model.eg_en ? self.model.eg_en : @"", self.model.eg_cn ? self.model.eg_cn : @""];
        return cell;
    }else if (indexPath.row == 2){
        WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.mnemonic ? self.model.mnemonic : @""];
        return cell;
    }else{
        WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
        cell.cellTitleCell.text = @"提示";
        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.prompt ? self.model.prompt : @""];
        return cell;
    }
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
