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
#import "MyCollectionViewController.h"
#import "UIImage+mask.h"
#import "PracticeModeViewController.h"
#import "TestModeViewController.h"


@interface ListenTrainingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *paperMutableArray;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *changeView;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIView *maskView;


@property (nonatomic, strong) DownloadFileModel *downloadModel;
@property (nonatomic, copy) NSString *downloadVoiceUrl;
@property (nonatomic, copy) NSString *downloadlrcUrl;
@property (nonatomic, copy) NSString *downloadJsonUrl;
@end

@implementation ListenTrainingViewController
- (UIView *)changeView{
    if (!_changeView) {
        _changeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
        // Text Color
        UILabel *titleLabel = [UILabel new];
        [_changeView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_changeView.mas_left).offset(15);
            make.top.equalTo(_changeView.mas_top).offset(5);
            make.height.equalTo(@20);
        }];
        titleLabel.text = @"听力·真题训练";
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
        
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
            make.height.equalTo(@48);
            make.top.equalTo(_changeView).offset(20);
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
            make.height.equalTo(@48);
            make.top.equalTo(_changeView).offset(20);
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
    self.downloadModel = [[DownloadFileModel alloc]init];
    [self loadData];
    [self loadTestPaper];
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
        return 72;
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
    cell.selectionStyle = NO;
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
//        HomeListenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        PaperDetailViewController *vc = [PaperDetailViewController new];
//        vc.nextTitle = cell.TitleLabel.text;
//        vc.onePaperModel = self.paperMutableArray[indexPath.row];
//        [self.navigationController pushViewController:vc animated:YES];
        if (self.rightBtn.selected) {
            [self selectMode];
        }else{
            SVProgressShowStuteText(@"暂无数据", NO);
            return;
            TestModeViewController *vc = [[TestModeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 0){
        VideoViewController *vc = [[VideoViewController alloc]init];
        vc.title = @"听力训练";
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 1){
        MyCollectionViewController *vc = [[MyCollectionViewController alloc]init];
        vc.title = @"听力训练";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 选择练习模式
- (void)selectMode{
    UIView *maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [keyWindow addSubview:maskView];
    
    UIView *selectView = [[UIView alloc]init];
    selectView.backgroundColor = [UIColor whiteColor];
    [selectView.layer setCornerRadius:8.0f];
    [maskView addSubview:selectView];
    [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(maskView.mas_left).offset(20);
        make.right.equalTo(maskView.mas_right).offset(-20);
        make.height.equalTo(@353);
        make.centerY.equalTo(maskView.mas_centerY);
    }];
    
    UILabel *selectedNameLb = [UILabel new];
    selectedNameLb.text = @"选择您想要练习的类型";
    selectedNameLb.textAlignment = NSTextAlignmentCenter;
    selectedNameLb.font = [UIFont systemFontOfSize:18];
    selectedNameLb.textColor = UIColorFromRGB(0x666666);
    [selectView addSubview:selectedNameLb];
    [selectedNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(selectView.mas_centerX);
        make.top.equalTo(@25);
    }];
    
    UIButton *sectionABtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionABtn setTitle:@"新闻题" forState:UIControlStateNormal];
    sectionABtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sectionABtn setTitleColor:UIColorFromRGB(0xA4A4A4) forState:UIControlStateNormal];
    [sectionABtn setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xf7f7f7)] forState:UIControlStateNormal];
    [sectionABtn setBackgroundImage:[UIImage imageWithColor:DRGBCOLOR] forState:UIControlStateHighlighted];
    [sectionABtn.layer setMasksToBounds:YES];
    [sectionABtn.layer setCornerRadius:22.5f];
    [selectView addSubview:sectionABtn];
    [sectionABtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectView.mas_left).offset(50);
        make.right.equalTo(selectView.mas_right).offset(-50);
        make.height.equalTo(@45);
        make.top.equalTo(selectedNameLb.mas_bottom).offset(30);
    }];
    
    UIButton *sectionBBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionBBtn setTitle:@"长对话" forState:UIControlStateNormal];
    sectionBBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sectionBBtn setTitleColor:UIColorFromRGB(0xA4A4A4) forState:UIControlStateNormal];
    [sectionBBtn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [sectionBBtn.layer setCornerRadius:22.5f];
    [sectionBBtn setBackgroundImage:[UIImage imageWithColor:DRGBCOLOR] forState:UIControlStateHighlighted];
    [sectionBBtn.layer setMasksToBounds:YES];
    [selectView addSubview:sectionBBtn];
    [sectionBBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(sectionABtn);
        make.right.equalTo(sectionABtn);
        make.top.equalTo(sectionABtn.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
    
    UIButton *sectionCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionCBtn setTitle:@"短文篇章" forState:UIControlStateNormal];
    sectionCBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [sectionCBtn setTitleColor:UIColorFromRGB(0xA4A4A4) forState:UIControlStateNormal];
    [sectionCBtn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [sectionCBtn.layer setCornerRadius:22.5f];
    [sectionCBtn setBackgroundImage:[UIImage imageWithColor:DRGBCOLOR] forState:UIControlStateHighlighted];
    [sectionCBtn.layer setMasksToBounds:YES];
    [selectView addSubview:sectionCBtn];
    [sectionCBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(sectionABtn);
        make.right.equalTo(sectionABtn);
        make.top.equalTo(sectionBBtn.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
    
    UIButton *allSectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allSectionBtn setTitle:@"全部" forState:UIControlStateNormal];
    allSectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [allSectionBtn setTitleColor:UIColorFromRGB(0xA4A4A4) forState:UIControlStateNormal];
    [allSectionBtn setBackgroundColor:UIColorFromRGB(0xf7f7f7)];
    [allSectionBtn.layer setCornerRadius:22.5f];
    [allSectionBtn setBackgroundImage:[UIImage imageWithColor:DRGBCOLOR] forState:UIControlStateHighlighted];
    [allSectionBtn.layer setMasksToBounds:YES];
    [selectView addSubview:allSectionBtn];
    [allSectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(sectionABtn);
        make.right.equalTo(sectionABtn);
        make.top.equalTo(sectionCBtn.mas_bottom).offset(20);
        make.height.equalTo(@45);
    }];
    [sectionABtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionBBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionCBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allSectionBtn addTarget:self action:@selector(selectedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sectionABtn.tag = 0;
    sectionBBtn.tag = 1;
    sectionCBtn.tag = 2;
    allSectionBtn.tag = 3;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskTapClick:)];
    [maskView addGestureRecognizer:tap];
    self.keyWindow = keyWindow;
    self.maskView = maskView;
}
- (void)maskTapClick:(UITapGestureRecognizer *)tap{
    [tap.view removeFromSuperview];
}
- (void)selectedBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    [btn setBackgroundColor:DRGBCOLOR];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateSelected];
    [self.maskView removeFromSuperview];
    PracticeModeViewController *vc = [[PracticeModeViewController alloc]init];
    vc.mode = btn.tag;
    vc.testPaperId = @"24";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 提前加载试卷信息
- (void)loadTestPaper{
    [LTHttpManager findOneTestPaperWithID:@24 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.downloadVoiceUrl = data[@"responseData"][@"voiceUrl"];
            self.downloadlrcUrl = data[@"responseData"][@"lic"];
            self.downloadJsonUrl = data[@"responseData"][@"testPaperUrl"];
            self.downloadModel.testPaperId = data[@"responseData"][@"id"];
            self.downloadModel.name = data[@"responseData"][@"name"];
            self.downloadModel.info = data[@"responseData"][@"info"];
            self.downloadModel.number = data[@"responseData"][@"number"];
            DownloadFileModel *model = [DownloadFileModel jr_findByPrimaryKey:self.downloadModel.testPaperId];
            if (model.paperVoiceName == nil || [model.paperVoiceName isEqualToString:@""]) {
                self.downloadModel.paperVoiceName = self.downloadVoiceUrl;
                J_Update(self.downloadModel).Columns(@[@"paperVoiceName"]).updateResult;
            }
            [USERDEFAULTS setObject:self.downloadModel.testPaperId forKey:@"testPaperId"];
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
            } failure:^(NSError *error) {
                
            }];
            J_Insert(self.downloadModel).updateResult;
            
            NSLog(@"%@",self.downloadModel);
        }else{
        }
    }];
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
