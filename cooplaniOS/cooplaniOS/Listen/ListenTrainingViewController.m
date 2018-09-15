//
//  ListenTrainingViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ListenTrainingViewController.h"
#import "ListenTeacherTableViewCell.h"
#import "PracticeTestTableViewCell.h"
#import "PaperModel.h"
#import "HomeListenCell.h"
#import "PaperDetailViewController.h"
#import "VideoViewController.h"

@interface ListenTrainingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *paperMutableArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *changeView;
@end

@implementation ListenTrainingViewController
- (UIView *)changeView{
    if (!_changeView) {
        _changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
        _changeView.backgroundColor = [UIColor whiteColor];
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [leftBtn setTitle:@"专项训练" forState:UIControlStateNormal];
        [leftBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateSelected];
        [leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_changeView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_changeView);
            make.right.equalTo(_changeView.mas_centerX);
            make.height.equalTo(_changeView);
            make.top.equalTo(_changeView);
        }];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn setTitle:@"历年真题" forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateSelected];
        [rightBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_changeView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_changeView);
            make.left.equalTo(_changeView.mas_centerX);
            make.height.equalTo(_changeView);
            make.top.equalTo(_changeView);
        }];
        
        UIView *bottomView = [UIView new];
        bottomView.backgroundColor = UIColorFromRGB(0xFFCE43);
        [_changeView addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@85);
            make.height.equalTo(@3);
            make.centerX.equalTo(leftBtn.mas_centerX);
            make.bottom.equalTo(_changeView);
        }];
        
        UILabel *line = [UILabel new];
        [_changeView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_changeView);
            make.right.equalTo(_changeView);
            make.height.equalTo(@1);
            make.bottom.equalTo(_changeView);
        }];
        line.backgroundColor = UIColorFromRGB(0xF0F0F0);
        
        self.bottomView = bottomView;
        self.leftBtn = leftBtn;
        self.leftBtn.tag = 101;
        self.rightBtn.tag = 102;
        self.rightBtn = rightBtn;
        [self changeClick:leftBtn];
        [self.leftBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.rightBtn addTarget:self action:@selector(scrollClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeView;
}
- (NSMutableArray *)paperMutableArray{
    if (!_paperMutableArray) {
        _paperMutableArray = [NSMutableArray array];
    }
    return _paperMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"听力训练";
    [self initWithView];
    [self loadData];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ListenTeacherTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([PracticeTestTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListenCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeListenCell class])];
    [self.view addSubview:tableView];
    tableView.tableFooterView = [UIView new];
    self.myTableView = tableView;
}
- (void)loadData{
    [LTHttpManager FindAllWithUseId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"];
            NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
            [self.paperMutableArray removeAllObjects];
            for (NSDictionary *dic in array) {
                muDict = [NSMutableDictionary dictionaryWithDictionary:dic[@"tp"]];
                [muDict addEntriesFromDictionary:@{@"collection":dic[@"type"]}];
                PaperModel *model = [PaperModel mj_objectWithKeyValues:muDict];
                [self.paperMutableArray addObject:model];
            }
            [USERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:self.paperMutableArray]forKey:@"homeData"];
            [self.myTableView reloadData];
        }else{
            [self.paperMutableArray removeAllObjects];
            NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:@"homeData"]];
            if (array.count) {
                self.paperMutableArray = [NSMutableArray arrayWithArray:array];
                [self.myTableView reloadData];
            }else{
                self.myTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                    [self loadData];
                }];
            }
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1) return 1;
    if (self.leftBtn.selected) {
        return 3;
    }else{
        return self.paperMutableArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        return 97;
    }
    else{
        return 48;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"听力·讲解课";
    }else if (section == 1){
        return @"模拟考场";
    }
    else {
        return @"听力·真题训练";
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return self.changeView;
    }else{
        return nil;
    }
}
- (void)scrollClick:(UIButton *)sender{
    [self changeClick:sender];
    [UIView animateWithDuration:0.1 animations:^{
        [self.myTableView reloadData];
    }];
}
- (void)changeClick:(UIButton *)sender{
    if (_tempBtn == nil){
        sender.selected = YES;
        _tempBtn = sender;
    }else if (_tempBtn !=nil && _tempBtn == sender){
        sender.selected = YES;
    }else if (_tempBtn!= sender && _tempBtn!=nil){
        _tempBtn.selected = NO;
        sender.selected = YES;
        _tempBtn = sender;
    }
    
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
        make.width.equalTo(@85);
        make.height.equalTo(@3);
        make.bottom.equalTo(self.bottomView.superview);
    }];
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if (section < 2) {
        // Background color
        view.tintColor = [UIColor whiteColor];
        
        // Text Color
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        [header.textLabel setTextColor:[UIColor blackColor]];
        [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section < 2) {
        return 44;
    }else{
        return 48;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ListenTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else if (indexPath.section == 1){
        PracticeTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.textColor = UIColorFromRGB(0x333333);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.leftBtn.selected) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"短篇新闻";
            cell.imageView.image = [UIImage imageNamed:@"短篇新闻"];
            cell.detailTextLabel.text = @"已练习1/80道";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"长对话";
            cell.imageView.image = [UIImage imageNamed:@"长对话"];
            cell.detailTextLabel.text = @"已练习1/80道";
        }else{
            cell.textLabel.text = @"听力篇章";
            cell.imageView.image = [UIImage imageNamed:@"听力篇章"];
            cell.detailTextLabel.text = @"已练习1/80道";
        }
        return cell;
    }else{
       PaperModel *model = self.paperMutableArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", model.name];
        cell.imageView.image = [UIImage imageNamed:@"试题"];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        HomeListenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        PaperDetailViewController *vc = [PaperDetailViewController new];
        vc.nextTitle = cell.TitleLabel.text;
        vc.onePaperModel = self.paperMutableArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0){
        VideoViewController *vc = [[VideoViewController alloc]init];
        vc.title = @"听力训练";
        [self.navigationController pushViewController:vc animated:YES];
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
