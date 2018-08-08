//
//  WordBookSettingTableViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordBookSettingTableViewController.h"

@interface WordBookSettingTableViewController ()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UIPickerView *pickView;
@end

@implementation WordBookSettingTableViewController

- (NSUserDefaults *)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"词书设置";
    self.tableView.separatorStyle = NO;
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
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"发音";//17bold
    }else{
        return @"其他";//17bold
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = UIColorFromRGB(0xf7f7f7);
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:UIColorFromRGB(0x666666)];
    [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.selectionStyle = NO;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UISwitch *cellSwitch = [[UISwitch alloc]init];
            cellSwitch.onTintColor = UIColorFromRGB(0xFFCE43);
            [cell addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-18);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            if ([[self.userDefaults objectForKey:kWordAutoPlay] isEqualToString:@"1"]) {
                cellSwitch.on = YES;
            }else{
                cellSwitch.on = NO;
            }
            cell.textLabel.text = @"单词自动发音";
            cellSwitch.tag = 0;
            [cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];

        }else{
            UISwitch *cellSwitch = [[UISwitch alloc]init];
            cellSwitch.onTintColor = UIColorFromRGB(0xFFCE43);
            [cell addSubview:cellSwitch];
            [cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.mas_right).offset(-18);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            if ([[self.userDefaults objectForKey:kQuestionVoice] isEqualToString:@"1"]) {
                cellSwitch.on = YES;
            }else{
                cellSwitch.on = NO;
            }
            cellSwitch.tag = 1;
            cell.textLabel.text = @"答题音效";
            [cellSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];

        }
    }else{
        if (indexPath.row == 0) {
//            UITableViewCell *subcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//            subcell.textLabel.font = [UIFont systemFontOfSize:16];
//            subcell.textLabel.textColor = UIColorFromRGB(0x666666);
//            subcell.detailTextLabel.font = [UIFont systemFontOfSize:12];
//            subcell.detailTextLabel.textColor = UIColorFromRGB(0xCCCCCC);
//            subcell.textLabel.text = @"词书下载（推荐）";
//            subcell.detailTextLabel.text = @"234M";
//            subcell.selectionStyle = NO;
//            return subcell;
//            UITableViewCell *subcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
//            subcell.textLabel.font = [UIFont systemFontOfSize:16];
//            subcell.textLabel.textColor = UIColorFromRGB(0x666666);
//            subcell.detailTextLabel.font = [UIFont systemFontOfSize:12];
//            subcell.detailTextLabel.textColor = UIColorFromRGB(0xCCCCCC);
//            subcell.textLabel.text = @"每组单词量";
//            subcell.detailTextLabel.text = @"20";
//            subcell.selectionStyle = NO;
//            return subcell;
        }
    }
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
    }
}
- (void)switchChange:(UISwitch *)sender{
    NSString *wordAutoPlay;//单词自动发音
    NSString *questionVoice;//答题音效
    if (sender.tag == 0) {
        wordAutoPlay = sender.on ? @"1":@"0";
        [self.userDefaults setObject:wordAutoPlay forKey:kWordAutoPlay];
    }else if (sender.tag == 1){
        questionVoice = sender.on ? @"1" : @"0";
        [self.userDefaults setObject:questionVoice forKey:kQuestionVoice];
    }
    [self.userDefaults synchronize];
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
