//
//  PaperDetailViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaperDetailViewController.h"
#import "PaperDetailTableViewCell.h"
#import "ListenPaperViewController.h"
#import "TestModeViewController.h"
#import "PracticeModeViewController.h"
#import "UIImage+mask.h"

@interface PaperDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, copy) NSString *downloadUrl;
@end

@implementation PaperDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myTableView registerNib:[UINib nibWithNibName:@"PaperDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PaperDetailTableViewCell class])];
    self.myTableView.scrollEnabled = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    [self loadData];
}
- (void)loadData{
    if ([self.onePaperModel.collection isEqualToString:@"0"]) {
        self.collectionImageView.image = [UIImage imageNamed:@"collection"];
        self.collectionPaperBtn.tag = 10;
    }else if ([self.onePaperModel.collection isEqualToString:@"1"]){
        self.collectionImageView.image = [UIImage imageNamed:@"collection_fill"];
        self.collectionPaperBtn.tag = 11;
    }
    [LTHttpManager findOneTestPaperWithID:self.onePaperModel.ID Complete:^(LTHttpResult result, NSString *message, id data) {
        self.paperDetailLb.text = data[@"responseData"][@"info"];
        self.downloadUrl = data[@"responseData"][@"voiceUrl"];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    [self.navigationController.navigationBar setBarTintColor:DRGBCOLOR];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = [UIColor whiteColor];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PaperDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaperDetailTableViewCell class])];
    if (indexPath.row == 1) {
        cell.modeImageView.image = [UIImage imageNamed:@"practicemode"];
        cell.titleLb.text = @"真题练习";
    }else if (indexPath.row == 2){
        cell.modeImageView.image = [UIImage imageNamed:@"testmode"];
        cell.titleLb.text = @"模拟考场";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ListenPaperViewController *vc = [[ListenPaperViewController alloc]init];
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){
        [self selectMode];
    }else if (indexPath.row == 2){
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"模拟考场需要一鼓作气的完成准备好了吗？" sureBtn:@"准备好了！" cancleBtn:@"取消"];
        alertView.resultIndex = ^(NSInteger index) {
            TestModeViewController *vc = [[TestModeViewController alloc]init];
            vc.title = self.title;
            [self.maskView removeFromSuperview];
            [self.navigationController pushViewController:vc animated:YES];
        };
        [alertView show];
    }else{
        SVProgressShowStuteText(@"暂未开放", NO);
    }
}
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
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)downloadPaper:(UIButton *)sender {
    [LTHttpManager downloadURL:self.downloadUrl progress:^(NSProgress *downloadProgress) {
        [SVProgressHUD showProgress:downloadProgress.fractionCompleted];
        if (downloadProgress.completedUnitCount/downloadProgress.totalUnitCount == 1.0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                SVProgressShowStuteText(@"下载成功", YES);
            });
        }
    } destination:^(NSURL *targetPath) {
        
        NSLog(@"%@",targetPath);
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)collectionBtn:(UIButton *)sender {
    if (sender.tag == 11) {
        if (IS_USER_ID) {
            [LTHttpManager deleteCollectionTestPaperWithId:self.onePaperModel.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    SVProgressShowStuteText(@"取消收藏成功", YES);
                    sender.selected = NO;
                    sender.tag = 10;
                    self.onePaperModel.collection = @"0";
                    self.collectionImageView.image = [UIImage imageNamed:@"collection"];
                     [[NSNotificationCenter defaultCenter]postNotificationName:@"homereloaddata" object:nil];
                }else{
                    SVProgressShowStuteText(message, NO);
                }
            }];
        }else{
            SVProgressShowStuteText(@"请先登录", NO);
        }
    }else if (sender.tag == 10){
        if (IS_USER_ID) {
            [LTHttpManager collectionTestPaperWithUserId:IS_USER_ID TestPaperId:self.onePaperModel.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    sender.selected = YES;
                    sender.tag = 11;
                    self.collectionImageView.image = [UIImage imageNamed:@"collection_fill"];
                    self.onePaperModel.collection = @"1";
                    SVProgressShowStuteText(@"收藏成功", YES);
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"homereloaddata" object:nil];
                }else{
                    SVProgressShowStuteText(message, NO);
                }
            }];
        }else{
            SVProgressShowStuteText(@"请先登录", NO);
        }
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
