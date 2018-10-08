//
//  ReadSectionAViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSectionAViewController.h"
#import "ReadSATableViewCell.h"
#import "SAQuestionCollectionViewCell.h"
#import "SAOptionsCollectionViewCell.h"
NSString* sstring =  @"The method for making beer has changed over time. Hops (啤酒花)，for example, which give many amodern beer its bitter flavor, are a (26)_______ recent addition to the beverage. This was first mentioned in reference to brewing in the ninth century. Now, researchers have found a (27)_______ ingredient in residue (残留物) from 5,000-year-old beer brewing equipment. While digging two pits at a site in the central plains of China, scientists discovered fragments from pots and vessels. The different shapes of the containers (28)_______    they were used to brew, filter, and store beer. They may be ancient “beer-making tools,” and the earliest (29)_______ evidence of beer brewing in China, the researchers reported in the Proceedings of the National Academy of Sciences. To (30)_______    that theory, the team examined the yellowish, dried (31)_______    inside the vessels. The majority of the grains, about 80%, were from cereal crops like barley(大麦), and about 10% were bits of roots, (32)_______ lily, which would have made the beer sweeter, the scientists say. Barley was an unexpected find: the crop was domesticated in Western Eurasia and didn't become a (33)_______ food in central China until about 2,000 years ago, according to the researchers. Based on that timing, they indicate barley may have (34)_______ in the region not as food, but as (35)_______ material for beer brewing.";

@interface ReadSectionAViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ReadSectionAViewController
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = SCREEN_HEIGHT;
    }
    return _tableView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.minimumLineSpacing = 0;
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAQuestionCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class])];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SAOptionsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选词填空";
    [self initWithView];
}
- (void)initWithView{
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-130);
        make.left.equalTo(self.view).offset(16);
        make.right.equalTo(self.view).offset(-16);
        make.height.equalTo(@([Tool layoutForAlliPhoneHeight:480]));
    }];
    [self.collectionView.layer setCornerRadius:12];
    [self.collectionView.layer setShadowOpacity:0.2];
    [self.collectionView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.collectionView.layer setShadowOffset:CGSizeMake(2, 2)];
    [self.collectionView.layer setMasksToBounds:NO];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-130);
    }];
    
    UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    panGr.delegate = self;
    [self.collectionView addGestureRecognizer:panGr];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openQuestionCard) name:kReadOpenQuestion object:nil];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
        });
    }];
    self.tableView.mj_header = header;
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    [footer setTitle:@"要再来一题吗" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载下一题" forState:MJRefreshStatePulling];
    [footer setTitle:@"正在为您加载" forState:MJRefreshStateRefreshing];
    self.tableView.mj_footer = footer;
}
- (void)openQuestionCard{
    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.transform = CGAffineTransformMakeTranslation(0, -[Tool layoutForAlliPhoneHeight:480 - 130]);
    }];
}
-(void)handlePan:(UIPanGestureRecognizer *)gr{
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [gr translationInView:self.collectionView];
    
    CGFloat minY = SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的上限
    CGFloat maxY = SCREEN_HEIGHT - 130 - SafeAreaTopHeight + [Tool layoutForAlliPhoneHeight:480]/2;//可拖动题卡的下限
    NSLog(@"minX:%f,maxY:%f,gr.center.y:%f", minY,maxY, gr.view.center.y);
    CGFloat tranY = gr.view.center.y + translation.y;
//    if (tranY == maxY) {
//        _isOpen = NO;
//    }
//    if (tranY == minY) {
//        _isOpen = YES;
//    }
//    if (tranY - 1 <= maxY && tranY + 1 >= minY) {
        //改变panGestureRecognizer.view的中心点 就是self.imageView的中心点
        gr.view.center = CGPointMake(gr.view.center.x, tranY);
        //重置拖拽手势的姿态
        [gr setTranslation:CGPointZero inView:self.view];
//    }
    [gr setTranslation:CGPointZero inView:self.view];
}
#pragma mark UITableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT);
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:sstring];
    [textStr yy_setFont:[UIFont systemFontOfSize:20] range:textStr.yy_rangeOfAll];
    //计算文本尺寸
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:maxSize text:textStr];
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight + 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadSATableViewCell *cell = [[ReadSATableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = NO;
    return cell;
}
#pragma mark UICollectionDelagete&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else{
        return 15;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return CGSizeMake(self.collectionView.width, 45);
    }else if (indexPath.section == 0){
        return CGSizeMake(self.collectionView.width, 35);
    }else{
        return CGSizeMake((self.collectionView.width - 10)/2, 44);
    }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
        [cell.layer setCornerRadius:12.0f];
        [cell.layer setMasksToBounds:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"上下拉动"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [cell addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(30);
            make.right.equalTo(cell.mas_right).offset(-30);
            make.height.equalTo(@35);
            make.centerY.equalTo(cell.mas_centerY);
        }];
        return cell;
    }else if (indexPath.section == 1){
        SAQuestionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAQuestionCollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }else{
        SAOptionsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SAOptionsCollectionViewCell class]) forIndexPath:indexPath];
        return cell;
    }
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
