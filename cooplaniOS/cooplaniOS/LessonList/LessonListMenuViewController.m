//
//  LessonListMenuViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonListMenuViewController.h"
#import "LessonTopSegment.h"
#import "LessonListTableViewCell.h"
#import "LessonServerView.h"
#import "VideoViewController.h"
#import "VideoLessonModel.h"
#import "learnLessonModel.h"

@interface LessonListMenuViewController ()<TopSegmentDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) LessonTopSegment *topSegment;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LessonServerView *lessonServerView;
@property (nonatomic, strong) NSMutableArray *lessonArray;
@property (nonatomic, strong) UITableView *lessonListTableView;
@property (nonatomic, strong) UITableView *learnedTableView;
@property (nonatomic, strong) NSMutableArray *learnedListArray;
@end

@implementation LessonListMenuViewController
- (NSMutableArray *)lessonArray{
    if (!_lessonArray) {
        _lessonArray = [NSMutableArray array];
    }
    return _lessonArray;
}
- (NSMutableArray *)learnedListArray{
    if (!_learnedListArray) {
        _learnedListArray = [NSMutableArray array];
    }
    return _learnedListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithView];
    [self loadData];
}
- (void)loadData{
    //二维码
    [LTHttpManager getQRWithComplete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            [self.lessonServerView.qrImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",data[@"responseData"]]] placeholderImage:[UIImage new]];
        }
    }];
    //课程列表
    [LTHttpManager findByCurriculumTypeWithUserId:IS_USER_ID CurriculumType:@"2" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *dataArray = data[@"responseData"];
            [self.lessonArray removeAllObjects];
            for (NSDictionary *dict in dataArray) {
                VideoLessonModel *model = [VideoLessonModel mj_objectWithKeyValues:dict];
                [self.lessonArray addObject:model];
            }
            [self.lessonListTableView reloadData];
        }
    }];
    [LTHttpManager  searchPlayRecordWithUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *array = data[@"responseData"];
            [self.learnedListArray removeAllObjects];
            for (NSDictionary *dict in array) {
                VideoLessonModel *model = [VideoLessonModel mj_objectWithKeyValues:dict];
                [self.learnedListArray addObject:model];
            }
            [self.learnedTableView reloadData];
        }
    }];
}
- (void)initWithView{
    self.title = @"CET-4刷题课";
    self.view.backgroundColor = [UIColor whiteColor];
    LessonTopSegment *segment = [[LessonTopSegment alloc]initWithTitles:@[@"课程列表",@"已学列表",@"课程服务"] AndSelectColor:UIColorFromRGB(0x4DAC7D)];
    segment.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.topSegment = segment;
    [self.view addSubview:segment];
    [self.view bringSubviewToFront:segment];
    self.topSegment.delegate = self;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64)];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 3, scrollView.height)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    self.scrollView = scrollView;
    
    UITableView *lessonListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, scrollView.height) style:UITableViewStylePlain];
    lessonListTableView.delegate = self;
    lessonListTableView.dataSource = self;
    [lessonListTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonListTableViewCell class])];
    lessonListTableView.tableFooterView = [UIView new];
    [scrollView addSubview:lessonListTableView];
    self.lessonListTableView = lessonListTableView;
    
    UITableView *learnedTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollView.height) style:UITableViewStylePlain];
    learnedTableView.delegate = self;
    learnedTableView.dataSource = self;
    [learnedTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonListTableViewCell class])];
    learnedTableView.tableFooterView = [UIView new];
    [scrollView addSubview:learnedTableView];
    self.learnedTableView = learnedTableView;
    
    LessonServerView *lessonServerView = [[LessonServerView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40)];
    [scrollView addSubview:lessonServerView];
    self.lessonServerView = lessonServerView;
}

- (void)segmentIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
       NSInteger index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.topSegment selectIndex:index];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == self.lessonListTableView ? self.lessonArray.count : self.learnedListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.lessonListTableView) {
        LessonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonListTableViewCell class])];
        cell.model = self.lessonArray[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    }else{
        LessonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonListTableViewCell class])];
        cell.model = self.learnedListArray[indexPath.row];
        cell.selectionStyle = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoViewController *vc =[[VideoViewController alloc]init];
      if (tableView == self.lessonListTableView) {
        VideoLessonModel *model = self.lessonArray[indexPath.row];
        vc.videoId = model.ID;
          vc.dataArray = self.lessonArray;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tableView == self.learnedTableView){
        VideoLessonModel *model = self.learnedListArray[indexPath.row];
        vc.videoId = model.ID;
        vc.dataArray = self.learnedListArray;
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
