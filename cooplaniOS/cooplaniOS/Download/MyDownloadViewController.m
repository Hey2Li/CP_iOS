//
//  MyDownloadViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyDownloadViewController.h"
#import "MyCollectionPaperTableViewCell.h"
#import "PaperDetailViewController.h"
#import "NSString+FileSize.h"
#import "PaperModel.h"
#import "LessonTopSegment.h"
#import "LessonDownloadTableViewCell.h"
#import "DownloadVideoModel.h"
#import "VideoViewController.h"
#import "LocalVideoViewController.h"

@interface MyDownloadViewController ()<UITableViewDelegate, UITableViewDataSource, TopSegmentDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LessonTopSegment *topSegment;
@property (nonatomic, strong) UITableView *listenTableView;
@property (nonatomic, strong) NSMutableArray *videoDownloadArray;
@end

@implementation MyDownloadViewController
- (NSMutableArray *)videoDownloadArray{
    if (!_videoDownloadArray) {
        _videoDownloadArray = [NSMutableArray array];
    }
    return _videoDownloadArray;
}
- (NSMutableArray *)downloadArray{
    if (!_downloadArray) {
        _downloadArray = [NSMutableArray array];
    }
    return _downloadArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyCollectionPaperTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
    }
    return _myTableView;
}
- (UITableView *)listenTableView{
    if (!_listenTableView) {
        _listenTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 40) style:UITableViewStylePlain];
        _listenTableView.delegate = self;
        _listenTableView.dataSource = self;
        _listenTableView.separatorStyle = NO;
        [_listenTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LessonDownloadTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([LessonDownloadTableViewCell class])];
    }
    return _listenTableView;
}
#pragma mark segmentDelegate
- (void)segmentIndex:(NSInteger)index{
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的下载";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
    [self initDB];
}
- (void)initWithView{
    LessonTopSegment *topSegment = [[LessonTopSegment alloc]initWithTitles:@[@"听力",@"课程"] AndSelectColor:UIColorFromRGB(0x4dac7d)];
    [self.view addSubview:topSegment];
    topSegment.delegate = self;
    self.topSegment = topSegment;
    
    UIScrollView *scrolleView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:scrolleView];
    scrolleView.backgroundColor = [UIColor whiteColor];
    [scrolleView setContentSize:CGSizeMake(SCREEN_WIDTH, scrolleView.height)];
    
    [scrolleView addSubview:self.myTableView];
    [scrolleView addSubview:self.listenTableView];
    scrolleView.pagingEnabled = YES;
    scrolleView.showsHorizontalScrollIndicator = NO;
    scrolleView.scrollEnabled = NO;
    self.scrollView = scrolleView;
    self.scrollView.delegate = self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        [self.topSegment selectIndex:scrollView.contentOffset.x/SCREEN_WIDTH];
    }
}
- (void)initDB{
    NSArray<DownloadFileModel *> *list = J_Select(DownloadFileModel).Where(@"paperVoiceName").list;
    
    NSArray *videoList1 = J_Select(DownloadVideoModel).Where(@"videoId").list;
     NSArray<DownloadVideoModel *> *videoList = J_Select(DownloadVideoModel).list;
    [self.downloadArray removeAllObjects];
    for (DownloadVideoModel *model in videoList) {
        if (model.videourl.length > 10) {
            [self.videoDownloadArray addObject:model];
        }
    }
    [self.videoDownloadArray removeAllObjects];
    for (DownloadVideoModel *model in videoList) {
        if (model.videourl.length > 10) {
            [self.videoDownloadArray addObject:model];
        }
        [self.listenTableView reloadData];
    }
    NSLog(@"videoList---%lu",(unsigned long)videoList.count);
    list = J_Select(DownloadFileModel).Where(@"paperVoiceName").list;
    
//    videoList = J_Select(DownloadVideoModel).Where(@"videourl").list;
    
    NSLog(@"videoList---%lu",(unsigned long)videoList.count);
    [self.myTableView reloadData];
    NSArray *array = [DownloadFileModel jr_findAll];
    NSArray *videoArray = [DownloadVideoModel jr_findAll];
    
    self.downloadArray = [NSMutableArray arrayWithArray:list];
    

    //    unsigned int count;
    for (int i = 0; i < videoArray.count; i++) {
        DownloadFileModel *model = videoArray[i];
        NSLog(@"%@,%@",[model jr_primaryKeyValue],model);
    }
//    for (int i = 0; i < videoList.count; i ++) {
//        DownloadFileModel *model = array[i];
//        NSLog(@"%@,%@",[model jr_primaryKeyValue],model);
//    }
    //    if (self.downloadArray.count > 0) {
    //        objc_property_t *props = class_copyPropertyList([model class], &count);
    //        NSMutableArray *marray = [NSMutableArray array];
    //        for (int i = 0; i < count; i++) {
    //            objc_property_t property = props[i];
    //            const char *cName = property_getName(property);
    //            NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    //            id propertyValue = [model valueForKey:(NSString *)name];
    //            NSLog(@"%@:%@",name,propertyValue);
    //            [marray addObject:name];
    //        }
    //    }
    
    [self.myTableView reloadData];
    [self.listenTableView reloadData];
    self.myTableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"您还没有下载"];
    self.listenTableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"您还没有下载"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.myTableView) {
        return self.downloadArray.count;
    }else{
        return self.videoDownloadArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 74;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myTableView) {
        MyCollectionPaperTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyCollectionPaperTableViewCell class])];
        [cell.dowloadBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        cell.selectionStyle = NO;
        DownloadFileModel *model = self.downloadArray[indexPath.row];
        cell.downloadViewModel = model;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,model.paperVoiceName];
        cell.fileSizeLb.text = filePath.fileSize;
        return cell;
    }else if(tableView == self.listenTableView){
        LessonDownloadTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LessonDownloadTableViewCell class])];
        DownloadVideoModel *model = self.videoDownloadArray[indexPath.row];
        cell.model = model;
        cell.selectionStyle = NO;
        return cell;
    }else{
        return nil;
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.myTableView) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            DownloadFileModel *model = [self.downloadArray objectAtIndex:indexPath.row];
            BOOL result = J_Delete(model).Recursive(YES).updateResult;
            if (result) {
                SVProgressShowStuteText(@"删除成功", YES);
            }
            // 从数据源中删除
            [self.downloadArray removeObjectAtIndex:indexPath.row];
            // 从列表中删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else{
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            DownloadVideoModel *model = [self.videoDownloadArray objectAtIndex:indexPath.row];
            BOOL result = J_Delete(model).Recursive(YES).updateResult;
            if (result) {
                SVProgressShowStuteText(@"删除成功", YES);
            }
            // 从数据源中删除
            [self.videoDownloadArray removeObjectAtIndex:indexPath.row];
            // 从列表中删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myTableView) {
//        PaperDetailViewController *vc = [[PaperDetailViewController alloc]init];
//        DownloadFileModel *model = self.downloadArray[indexPath.row];
//        [LTHttpManager findOneTestPaperInfoWithUserId:IS_USER_ID ? IS_USER_ID : @"" TestPaperId:@([model.testPaperId integerValue]) Complete:^(LTHttpResult result, NSString *message, id data) {
//            if (LTHttpResultSuccess == result) {
//                NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"][@"tp"]];
//                [muDict addEntriesFromDictionary:@{@"collection":data[@"responseData"][@"type"]}];
//                PaperModel *onePaperModel = [PaperModel mj_objectWithKeyValues:muDict];
//                vc.onePaperModel = onePaperModel;
//                vc.nextTitle = onePaperModel.name;
//                [self.navigationController pushViewController:vc animated:YES];
//            }else{
//                NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:[USERDEFAULTS objectForKey:@"homeData"]];
//                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    PaperModel *pmodel = (PaperModel *)obj;
//                    if ([[NSString stringWithFormat:@"%@",pmodel.ID] isEqualToString:model.testPaperId]) {
//                        vc.onePaperModel = pmodel;
//                        vc.nextTitle = pmodel.name;
//                        [self.navigationController pushViewController:vc animated:YES];
//                    }
//                }];
//            }
//        }];
    }else{
//        DownloadVideoModel *model = self.videoDownloadArray[indexPath.row];
//        LocalVideoViewController *vc = [[LocalVideoViewController alloc]init];
//        vc.localVideoModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
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
