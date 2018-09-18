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
#import "HomeCategoryTableViewCell.h"
#import "HomeWordBookTableViewCell.h"
#import "HomeBuyLessonTableViewCell.h"
#import "StartLearnWordViewController.h"

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView) name:kHomeReloadData object:nil];
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
}

- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeListenCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([HomeListenCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeCategoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeCategoryTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeWordBookTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeWordBookTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([HomeBuyLessonTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeBuyLessonTableViewCell class])];
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:240])];
    //倒计时
    UILabel *countdownLabel = [UILabel new];
    countdownLabel.text = @"距离四级倒计时还有92天";
    countdownLabel.font = [UIFont boldSystemFontOfSize:14];
    countdownLabel.textColor = UIColorFromRGB(0x333333);
    countdownLabel.textAlignment = NSTextAlignmentRight;
    [tableHeaderView addSubview:countdownLabel];
    [countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tableHeaderView.mas_right).offset(-15);
        make.top.equalTo(tableHeaderView.mas_top).offset(5);
        make.left.equalTo(tableHeaderView.mas_left).offset(20);
    }];
    //banner collectionView
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    flowlayout.minimumLineSpacing = 20;
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:210]) collectionViewLayout:flowlayout];
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
    return CGSizeMake([Tool layoutForAlliPhoneWidth:335], [Tool layoutForAlliPhoneHeight:190]);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(1, 20, 1, 10);
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

#pragma mark -- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) return 140;
    if (indexPath.section == 2) return 110;
    return 80;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *isHaveNet = [USERDEFAULTS objectForKey:@"isHaveNet"];
    if ([isHaveNet isEqualToString:@"0"]) {
        return @"";
    }else{
        if (section == 1) {
            return @"单词学习";
        }else{
            return @"";
        }
    }
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // Background color
//    view.tintColor = UIColorFromRGB(0xF7F7F7);
    view.tintColor = [UIColor whiteColor];

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor blackColor]];
    [header.textLabel setFont:[UIFont systemFontOfSize:14 weight:20]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 40;
    }else{
        return 10;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        HomeBuyLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeBuyLessonTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else if (indexPath.section == 0){
        HomeCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeCategoryTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else if (indexPath.section == 1){
        HomeWordBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeWordBookTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else{
        HomeBuyLessonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeBuyLessonTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        StartLearnWordViewController *vc =[[StartLearnWordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
