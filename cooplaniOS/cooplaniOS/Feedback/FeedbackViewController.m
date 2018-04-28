//
//  FeedbackViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackTypeTableViewCell.h"
#import "FeedbackPhoneTableViewCell.h"
#import "FeedbackContentTableViewCell.h"
#import "TZImagePickerController.h"

@interface FeedbackViewController ()<UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSArray *imageDataArray;
@property (nonatomic, copy) NSString *userContact;
@property (nonatomic, assign) NSInteger feedbackType;
@property (nonatomic, copy) NSString *feedbackContent;
@end

@implementation FeedbackViewController

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.tableFooterView = [UIView new];
        _myTableView.backgroundColor = UIColorFromRGB(0xF7F7F7);
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview: btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@45);
        make.bottom.equalTo(self.view);
    }];
    [btn setBackgroundColor:DRGBCOLOR];
    [btn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = btn;
    
    [self.view addSubview:self.myTableView];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FeedbackTypeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedbackTypeTableViewCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FeedbackContentTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedbackContentTableViewCell class])];
    [self.myTableView registerNib:[UINib nibWithNibName:@"FeedbackPhoneTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([FeedbackPhoneTableViewCell class])];
    [self.view bringSubviewToFront:self.submitBtn];
}
- (void)submitClick:(UIButton *)btn{
    if (!self.feedbackType) {
        SVProgressShowStuteText(@"请选择反馈类型", NO);
        return;
    }
    if (self.feedbackContent.length == 0) {
        SVProgressShowStuteText(@"请填写反馈内容", NO);
        return;
    }
    if (self.userContact.length == 0) {
        SVProgressShowStuteText(@"请填写联系方式", NO);
        return;
    }
    if (![USERDEFAULTS objectForKey:USER_ID]) {
        SVProgressShowStuteText(@"请先登录", NO);
        return;
    }
    [LTHttpManager feedbackWithUserId:[USERDEFAULTS objectForKey:USER_ID] Type:[NSString stringWithFormat:@"%ld",(long)self.feedbackType] Info:self.feedbackContent ContactInfo:self.userContact Files:self.imageDataArray Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            SVProgressShowStuteText(@"反馈成功", YES);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            SVProgressShowStuteText(message, NO);
        }
    }];
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 90;
            break;
        case 1:
            return 210;
            break;
        case 2:
            return 45;
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorFromRGB(0xF7F7F7);
    UILabel *label = [UILabel new];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(10);
        make.right.equalTo(view);
        make.top.equalTo(view);
        make.bottom.equalTo(view);
    }];
    label.backgroundColor = UIColorFromRGB(0xF7F7F7);
    if (section < 2) {
        label.text = @"选择反馈类型";
    }else{
        label.text = @"联系方式（选填）";
    }
    label.textColor = UIColorFromRGB(0x666666);
    label.font = [UIFont systemFontOfSize:14];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        FeedbackTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedbackTypeTableViewCell class])];
        cell.feedbackTypeClick = ^(UIButton *btn) {
            self.feedbackType = btn.tag;
        };
        return cell;
    }else if (indexPath.section == 1){
        FeedbackContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedbackContentTableViewCell class])];
        WeakSelf
        cell.uploadImageClick = ^(UIButton *leftBtn, UIButton *rightBtn) {
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:2 delegate:weakSelf];
            imagePickerVc.needCircleCrop = YES;
            imagePickerVc.circleCropRadius = 30;
            imagePickerVc.navigationBar.translucent = NO;
            imagePickerVc.navigationBar.barTintColor = DRGBCOLOR;
            imagePickerVc.navigationBar.translucent = NO;
            imagePickerVc.navigationBar.shadowImage = [UIImage new];
            imagePickerVc.barItemTextColor = [UIColor blackColor];
            imagePickerVc.oKButtonTitleColorNormal = [UIColor blackColor];
            imagePickerVc.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -10) forBarMetrics:UIBarMetricsDefault];
            UIImage *back = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            imagePickerVc.navigationBar.backIndicatorImage = back;
            imagePickerVc.navigationBar.backIndicatorTransitionMaskImage = back;
            //这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
                        
            // You can get the photos by block, the same as by delegate.
            // 你可以通过block或者代理，来得到用户选择的照片.
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets ,BOOL isSelectOriginalPhoto) {
                NSLog(@"%@%@",photos, assets);
                if (photos.count ==2) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [leftBtn setImage:photos[0] forState:UIControlStateNormal];
                        [rightBtn setImage:photos[1] forState:UIControlStateNormal];
                    });
                }else if (photos.count == 1){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [leftBtn setImage:photos[0] forState:UIControlStateNormal];
                    });
                }
                self.imageDataArray = photos;
            }];
            [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
        };
        cell.feedbackContent = ^(NSString *str) {
            self.feedbackContent = str;
        };
        return cell;
    }else if (indexPath.section == 2){
        FeedbackPhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FeedbackPhoneTableViewCell class])];
        cell.userContact = ^(NSString *contact) {
            self.userContact = contact;
        };
        return cell;
    }else{
        return nil;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
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
