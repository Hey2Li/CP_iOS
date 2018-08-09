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
#import "VBFPopFlatButton.h"
#import "HomeTopTitleView.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *paperMutableArray;
@property (nonatomic, strong) VBFPopFlatButton *flatRoundedButton;
@end

@implementation HomeViewController

- (NSMutableArray *)paperMutableArray{
    if (!_paperMutableArray) {
        _paperMutableArray = [NSMutableArray array];
    }
    return _paperMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
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

- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:@"HomeListenCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"HOMELISTEN"];
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:255])];

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
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    tableView.tableHeaderView = tableHeaderView;
    self.myCollectionView = collectionView;
    self.myTableView = tableView;
    self.view.backgroundColor = [UIColor clearColor];
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
    [LTHttpManager searchBannerCountWithUserId:IS_USER_ID BannerId:self.bannerArray[indexPath.row][@"id"] Complete:^(LTHttpResult result, NSString *message, id data) {
        NSLog(@"用户点击banner统计");
    }];
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

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paperMutableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"四级听力·真题";//17bold
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
    view.tintColor = UIColorFromRGB(0xF7F7F7);
    
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
    cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    cell.Model = self.paperMutableArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeListenCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PaperDetailViewController *vc = [PaperDetailViewController new];
    vc.nextTitle = cell.TitleLabel.text;
    vc.onePaperModel = self.paperMutableArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [LTHttpManager  searchListeningCountWithUserId:IS_USER_ID TestPaperId:vc.onePaperModel.ID Complete:^(LTHttpResult result, NSString *message, id data) {

    }];
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
