//
//  StartLearnWordViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "StartLearnWordViewController.h"
#import "TopWordBookTableViewCell.h"
#import "BottomWordProgressTableViewCell.h"
#import "ReciteWordsViewController.h"

@interface StartLearnWordViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, strong) NSArray *wordbookArray;
@property (nonatomic, strong) NSString *residueStr;
@property (nonatomic, assign) NSInteger alwaysErrorNum;
@property (nonatomic, assign) NSInteger skilledNum;
@end

@implementation StartLearnWordViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
    [self.navigationController.navigationBar setBarTintColor:DRGBCOLOR];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kLoadWordHomePageData object:nil];
}
- (void)loadData{
    [LTHttpManager getReciteWordProgressWithUser_id:IS_USER_ID ? IS_USER_ID : @"" WordbookId:@"1" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.dataDict = data[@"responseData"];
            _alwaysErrorNum = [[NSString stringWithFormat:@"%@",self.dataDict[@"mistake_num"]] integerValue];
            _skilledNum = [[NSString stringWithFormat:@"%@",self.dataDict[@"proficiency_num"]] integerValue];
            [LTHttpManager getResidueWordNumWithUser_id:IS_USER_ID ? IS_USER_ID : @"" Wordbookid:@"1" Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    _residueStr = [NSString stringWithFormat:@"%@",data[@"responseData"]];
                    [self.myTableView reloadData];
                }
            }];
        }else{
            
        }
    }];
    [LTHttpManager getAllWordbookComplete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            self.wordbookArray = data[@"responseData"];
            [self.myTableView reloadData];
        }
    }];
}
- (void)initWithView{
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:255])];
    tableHeaderView.backgroundColor = [UIColor clearColor];
  
    [self.view addSubview:tableHeaderView];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
//    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    tableView.separatorStyle = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TopWordBookTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopWordBookTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BottomWordProgressTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([BottomWordProgressTableViewCell class])];
    
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView = tableView;
    
    self.myTableView.tableFooterView = [UIView new];
    
    self.view.backgroundColor = [UIColor clearColor];
}
- (void)startLearnClick:(UIButton *)btn{
    ReciteWordsViewController *vc = [[ReciteWordsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 140;
    }else if (indexPath.row == 1){
        return 182 + 38;
    }else{
        return 100;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TopWordBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopWordBookTableViewCell class])];
        if (self.wordbookArray) {
            cell.wordBookNameLb.text = self.wordbookArray[0][@"name"];
            cell.wordBookDetailLb.text = self.wordbookArray[0][@"info"];
            [cell.wordBookImg sd_setImageWithURL:[NSURL URLWithString:self.wordbookArray[0][@"img"]] placeholderImage:nil];
            cell.wordBookNumLb.text = [NSString stringWithFormat:@"%@",_residueStr ? _residueStr : @"0"];
        }
        return cell;
    }else if (indexPath.row == 1){
        BottomWordProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottomWordProgressTableViewCell class])];
        if ([self.dataDict allKeys].count) {
            cell.inMemoryLb.text = [NSString stringWithFormat:@"%@",self.dataDict[@"memory_num"]];
            cell.alwaysErrorLb.text = [NSString stringWithFormat:@"%@",self.dataDict[@"mistake_num"]];
            cell.skilledWordLb.text = [NSString stringWithFormat:@"%@",self.dataDict[@"proficiency_num"]];
            cell.progressView.progress = (float)(_skilledNum + _alwaysErrorNum) / [_residueStr integerValue];
            cell.progressLb.text = [NSString stringWithFormat:@"%.1f%%",(float)(_skilledNum + _alwaysErrorNum) / [_residueStr integerValue] * 100];
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = NO;
        cell.backgroundColor = [UIColor clearColor];
        UIButton *startLearnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [startLearnBtn setTitle:@"开始学习" forState:UIControlStateNormal];
        [startLearnBtn setBackgroundColor:UIColorFromRGB(0xffce43)];
        [startLearnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [startLearnBtn.layer setMasksToBounds:YES];
        [startLearnBtn.layer setCornerRadius:8.0f];
        
        CALayer *shadowLayer = [CALayer layer];
        [cell.layer addSublayer:shadowLayer];

        [cell addSubview:startLearnBtn];
        [startLearnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(cell.mas_centerX);
            make.height.equalTo(@45);
            make.width.equalTo(@280);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        shadowLayer.frame = CGRectMake((SCREEN_WIDTH - 280)/2,(100 - 44)/2, 280, 44);
        [shadowLayer setCornerRadius:8.0f];
        shadowLayer.backgroundColor = [UIColor blackColor].CGColor;
        shadowLayer.shadowOffset = CGSizeMake(3, 3);
        shadowLayer.shadowOpacity = 0.3;
        [startLearnBtn addTarget:self action:@selector(startLearnClick:) forControlEvents:UIControlEventTouchUpInside];
        
      
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
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
