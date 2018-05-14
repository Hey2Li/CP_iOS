//
//  MyNoteViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "MyNoteViewController.h"
#import "SentenceTableViewCell.h"
#import "collectionSentenceModel.h"

@interface MyNoteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置
@property (nonatomic, strong) NSMutableArray *sentenceArray;
@end

@implementation MyNoteViewController

- (NSMutableArray *)sentenceArray{
    if (!_sentenceArray) {
        _sentenceArray = [NSMutableArray array];
    }
    return _sentenceArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SentenceTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SentenceTableViewCell class])];
        _myTableView.estimatedRowHeight = 70.0f;
        _myTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _myTableView;
}
#pragma mark UITableViewDegate&DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sentenceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SentenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SentenceTableViewCell class])];
    collectionSentenceModel *model = self.sentenceArray[indexPath.row];
    cell.model = model;
    cell.selectionStyle = NO;
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        collectionSentenceModel *model = self.sentenceArray[indexPath.row];
        [LTHttpManager deleteSentenceNoteWithId:[NSNumber numberWithInteger:model.ID] WithComplete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                // 从数据源中删除
                [self.sentenceArray removeObjectAtIndex:indexPath.row];
                //     从列表中删除
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                SVProgressShowStuteText(@"删除失败", NO);
            }
        }];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的笔记";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.myTableView];
//    self.sentenceArray = [collectionSentenceModel jr_findAll];
//    [self.myTableView reloadData];
    [self loadData];
}
- (void)loadData{
    if (IS_USER_ID) {
        [LTHttpManager findSectenceNoteWIthUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            NSArray *array = data[@"responseData"];
            [self.sentenceArray removeAllObjects];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    collectionSentenceModel *model = [collectionSentenceModel mj_objectWithKeyValues:obj];
                    [self.sentenceArray addObject:model];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.myTableView reloadData];
                    });
                });
               
            }];
        }];
    }else{
        SVProgressShowStuteText(@"请先登录", NO);
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
