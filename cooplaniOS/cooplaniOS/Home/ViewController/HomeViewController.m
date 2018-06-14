//
//  HomeViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeViewController.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "HomeListenCell.h"
#import "BottomLabel.h"
#import "ListenPaperViewController.h"
#import "BannerCollectionViewCell.h"
#import "PaperDetailViewController.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *paperMutableArray;
@end

@implementation HomeViewController

- (NSMutableArray *)paperMutableArray{
    if (!_paperMutableArray) {
        _paperMutableArray = [NSMutableArray array];
    }
    return _paperMutableArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = DRGBCOLOR;
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithNavi];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupLeftMenuButton];
    [self loadData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:@"homereloaddata" object:nil];
}
- (void)reloadTableView{
    [self loadData];
}
- (void)loadData{
    [LTHttpManager FindAllBannerWithComplete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                self.bannerArray = data[@"responseData"];
                [USERDEFAULTS setObject:[NSKeyedArchiver archivedDataWithRootObject:self.bannerArray]forKey:@"bannerData"];
                [self.myCollectionView reloadData];
            }else{
                self.bannerArray = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:@"bannerData"]];
                if (self.bannerArray.count > 0) {
                    [self.myCollectionView reloadData];
                }
            }
        }];
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
            }
        }
    }];
}
-(void)setupLeftMenuButton{
    UIImage *image = [[UIImage imageNamed:@"view_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftDrawerBtn = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(leftDrawerButtonPress:)];
    leftDrawerBtn.tag = 0;
    [self.navigationItem setLeftBarButtonItem:leftDrawerBtn animated:YES];
}
-(void)leftDrawerButtonPress:(UIBarButtonItem *)sender{
//    UIImage *image = [[UIImage imageNamed:@"view_list"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *back = [[UIImage imageNamed:@"back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    if (sender.tag == 0) {
//        sender.tag = 1;
//
//    }else if (sender.tag == 1){
//        sender.tag = 0;
//        [sender setImage:image];
//    }
    
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    [self.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
//        [sender setImage:back];
//    }];
//    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
//        [sender setImage:image];
//    }];
}

- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView registerNib:[UINib nibWithNibName:@"HomeListenCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HOMELISTEN"];
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:255])];
    //底部背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake((-750 + SCREEN_WIDTH)/2 , - 444 - 64, 750, 750)];
    backView.backgroundColor = DRGBCOLOR;
    backView.layer.cornerRadius = 375;
    backView.layer.masksToBounds = YES;
    [tableHeaderView addSubview:backView];
    //banner collectionView
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 20;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, -10, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:270]) collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"BannerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BannerCollectionViewCell class])];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [tableHeaderView addSubview:collectionView];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    tableView.tableHeaderView = tableHeaderView;
    self.myCollectionView = collectionView;
    self.myTableView = tableView;
    [self.view addSubview:tableView];
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.bannerArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([Tool layoutForAlliPhoneWidth:330], [Tool layoutForAlliPhoneHeight:240]);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 20, 0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BannerCollectionViewCell class]) forIndexPath:indexPath];
    cell.bannerImageView.userInteractionEnabled = NO;
    if (self.bannerArray.count) {
        cell.imageUrl = self.bannerArray[indexPath.row][@"photoUrl"];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",self.bannerArray[indexPath.row][@"skipUrl"]]];
    NSLog(@"%@",url);
    if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{}
                                         completionHandler:^(BOOL success) {
                                             NSLog(@"Open %d",success);
                                         }];
            } else {
                // Fallback on earlier versions
            }
        } else {
            BOOL success = [[UIApplication sharedApplication] openURL:url];
            NSLog(@"Open  %d",success);
        }
        
    } else{
        bool can = [[UIApplication sharedApplication] canOpenURL:url];
        if(can){
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark 导航栏
- (void)initWithNavi{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-100, 44)];
    titleView.backgroundColor = DRGBCOLOR;
   
    BottomLabel *monthAndDayLb = [[BottomLabel alloc]init];
    monthAndDayLb.verticalAlignment = 2;
    monthAndDayLb.font = [UIFont systemFontOfSize:14 weight:18];
    monthAndDayLb.textColor = [UIColor blackColor];
    monthAndDayLb.text = [NSString stringWithFormat:@"%@th %@",[Tool dateArray][2],[Tool dateArray][1]];
    UIFont *font = [UIFont systemFontOfSize:14 weight:18];
    // 根据字体得到NSString的尺寸
    CGSize size = [monthAndDayLb.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]];
    CGFloat width = size.width;
    monthAndDayLb.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:monthAndDayLb];
    [monthAndDayLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView.mas_right);
        make.bottom.equalTo(titleView).offset(-2);
        make.top.equalTo(titleView);
        make.width.equalTo(@(width + 10));
    }];
    
    BottomLabel *weekLb = [BottomLabel new];
    [titleView addSubview:weekLb];
    [weekLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
        make.bottom.equalTo(titleView);
        make.right.equalTo(monthAndDayLb.mas_left);
    }];
    weekLb.font = [UIFont systemFontOfSize:26 weight:26];
    NSString *weekStr = [Tool dateArray][0];
    weekLb.text = [NSString stringWithFormat:@"%@ %@",weekStr.uppercaseString ,@""];
    weekLb.verticalAlignment = 2;
    weekLb.textColor = [UIColor blackColor];
    weekLb.textAlignment = NSTextAlignmentRight;
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = barItem;
}
#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paperMutableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"四级听力"];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17]range:NSMakeRange(0, 3)];
    return [titleStr string];//17bold
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UILabel *label = [UILabel new];
//    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"四级听力"];
//    [titleStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17]range:NSMakeRange(0, 3)];
//    label.attributedText = titleStr;
//    return label;
//}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = [UIColor whiteColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:17 weight:20]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HOMELISTEN"];
    cell.backgroundColor = UIColorFromRGB(0xF7F7F7);
    cell.Model = self.paperMutableArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PaperDetailViewController *vc = [PaperDetailViewController new];
    vc.title = cell.TitleLabel.text;
    vc.onePaperModel = self.paperMutableArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //设置打开抽屉模式   这里要设置抽屉的打开和关闭，不能单一设置打开，不然就回不去了
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning{
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
