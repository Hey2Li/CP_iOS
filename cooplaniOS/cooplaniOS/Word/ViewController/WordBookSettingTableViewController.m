//
//  WordBookSettingTableViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "WordBookSettingTableViewController.h"
#import "LTPickView.h"
#import "SectionWordNumsTableViewCell.h"
#import "SelectedWBTableViewController.h"

@interface WordBookSettingTableViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy) NSString *rowIndex;
@end

@implementation WordBookSettingTableViewController

- (NSUserDefaults *)userDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}
- (UIPickerView *)pickView{
    if (!_pickView) {
        _pickView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        _pickView.delegate = self;
        _pickView.dataSource = self;
//        _pickView.backgroundColor = [UIColor whiteColor];
//        _pickView.hidden = YES;
    }
    return _pickView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"词书设置";
    self.tableView.separatorStyle = NO;
    self.tableView.scrollEnabled = NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SectionWordNumsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SectionWordNumsTableViewCell class])];
    self.rowIndex = @"20";
}
- (void)initWithPickView{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [keyWindow addSubview:maskView];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 219, SCREEN_WIDTH, 219)];
    backView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:backView];
    
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSure.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [btnSure setTitleColor:UIColorFromRGB(0x4DAC7D) forState:UIControlStateNormal];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(pickerViewBtnOk:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView).offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@44);
        make.top.equalTo(backView);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [btnCancel setTitleColor:UIColorFromRGB(0xD76F67) forState:UIControlStateNormal];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pickerViewBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView).offset(10);
        make.height.equalTo(btnSure.mas_height);
        make.width.equalTo(btnSure.mas_width);
        make.top.equalTo(backView);
    }];
    UILabel *line = [UILabel new];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.height.equalTo(@(0.5));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.top.equalTo(btnSure.mas_bottom);
    }];
    
    line.backgroundColor = UIColorFromRGB(0xD8D3D3);
    [backView addSubview:self.pickView];
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(backView);
    }];
    self.maskView = maskView;
}
- (void)pickerViewBtnOk:(UIButton *)btn{
    SectionWordNumsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.numberLb.text = [NSString stringWithFormat:@"%@个", self.rowIndex];
    [self.userDefaults setObject:[NSString stringWithFormat:@"%@",self.rowIndex] forKey:kWordNum];
    [self.tableView reloadData];
    [self.maskView removeFromSuperview];
}

- (void)pickerViewBtnCancel:(UIButton *)btn{
    [self.maskView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PickView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.rowIndex = self.dataArray[row];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"词书选择";//17bold
    }else if (section == 1){
        return @"发音";
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
            //            UITableViewCell *subcell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            //            subcell.textLabel.font = [UIFont systemFontOfSize:16];
            //            subcell.textLabel.textColor = UIColorFromRGB(0x666666);
            
            //            subcell.textLabel.text = @"词书下载（推荐）";
            //            subcell.detailTextLabel.text = @"234M";
            //            subcell.selectionStyle = NO;
            //            return subcell;
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = self.wordBookName;
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = UIColorFromRGB(0xCCCCCC);
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@词", self.wordNum];
            cell.selectionStyle = NO;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            SectionWordNumsTableViewCell *subcell = [tableView  dequeueReusableCellWithIdentifier:NSStringFromClass([SectionWordNumsTableViewCell class])];
            NSString *wordum = [self.userDefaults objectForKey:kWordNum];
            if (wordum) {
                subcell.numberLb.text = wordum;
            }else{
                subcell.numberLb.text = @"20个";
            }
            return subcell;
        }
    }else{
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
    }
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self initWithPickView];
        self.dataArray = @[@"20", @"25", @"30", @"35", @"40", @"45", @"50",@"55", @"60", @"65", @"70", @"75"];
        [self.pickView reloadAllComponents];
    }else if (indexPath.section == 0 && indexPath.row == 0){
        if (IS_USER_ID) {
            WeakSelf
            SelectedWBTableViewController *vc = [[SelectedWBTableViewController alloc]init];
            vc.wordBookNameAndNumBlock = ^(NSString *wordbookName, NSString *wordbookNum) {
                weakSelf.wordBookName = wordbookName;
                weakSelf.wordNum = wordbookNum;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [Tool gotoLogin:self];
        }
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
