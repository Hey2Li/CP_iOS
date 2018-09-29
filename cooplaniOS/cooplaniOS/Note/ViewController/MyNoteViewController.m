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
#import "WordTableViewCell.h"
#import "WZSwitch.h"
#import "collectionWordModel.h"

@interface MyNoteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置
@property (nonatomic, strong) NSMutableArray *sentenceArray;
@property (nonatomic, strong) UITableView *wordTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WZSwitch     *mySwitch;
@property (nonatomic, strong) NSMutableArray *wordArray;
@end

@implementation MyNoteViewController

- (NSMutableArray *)wordArray{
    if (!_wordArray) {
        _wordArray = [NSMutableArray array];
    }
    return _wordArray;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (NSMutableArray *)sentenceArray{
    if (!_sentenceArray) {
        _sentenceArray = [NSMutableArray array];
    }
    return _sentenceArray;
}
- (UITableView *)wordTableView{
    if (!_wordTableView) {
        _wordTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _wordTableView.delegate = self;
        _wordTableView.dataSource = self;
        _wordTableView.separatorStyle = NO;
        [_wordTableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordTableViewCell class])];
        _wordTableView.estimatedRowHeight = 67.0f;
        _wordTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _wordTableView;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 2, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromRGB(0xEEEEEE);
    return view;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.myTableView) {
        return self.sentenceArray.count;
    }else{
        return self.wordArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.wordTableView) {
        collectionWordModel *model = self.wordArray[indexPath.row];
        if (model.isOpen) {
            NSLog(@"%f",self.wordTableView.rowHeight);
            return self.wordTableView.rowHeight;
        }else{
            return 67;
        }
    }else{
        return tableView.rowHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.myTableView) {
        SentenceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SentenceTableViewCell class])];
        collectionSentenceModel *model = self.sentenceArray[indexPath.row];
        cell.model = model;
        cell.selectionStyle = NO;
        return cell;
    }else{
        WordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordTableViewCell class])];
        cell.selectionStyle = NO;
        if (self.wordArray.count) {
            collectionWordModel *model = self.wordArray[indexPath.row];
            cell.model = model;
        }
        cell.cellOpenBtnClick = ^(UIButton *btn) {
            collectionWordModel *model = self.wordArray[indexPath.row];
            model.isOpen = !model.isOpen;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:nil];
            if (model.isOpen) {
                WordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.arrowsBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                WordTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.arrowsBtn.transform = CGAffineTransformMakeRotation(M_PI/2*4);
            }
        };
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (tableView == self.wordTableView) {
//      
//    }
}
//允许 Menu菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.wordTableView) {
        return NO;
    }
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    if (tableView == self.wordTableView) {
        return NO;
    }
    // 设置只能复制
    if (action == @selector(cut:)){
        return NO;
    }
    else if(action == @selector(copy:)){
        return YES;
    }
    else if(action == @selector(paste:)){
        return NO;
    }
    else if(action == @selector(select:)){
        return NO;
    }
    else if(action == @selector(selectAll:)){
        return NO;
    }
    else{
        return [super canPerformAction:action withSender:sender];
    }
}
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (tableView == self.wordTableView) {
        return;
    }
    SentenceTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (action == @selector(copy:)) {
        [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@\n%@",cell.englishSentenceLb.text, cell.chineseSentenceLb.text];
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
    }else{
        collectionWordModel *model = self.wordArray[indexPath.row];
        [LTHttpManager removeWordsWithUseId:IS_USER_ID Word:model.word Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                // 从数据源中删除
                [self.wordArray removeObjectAtIndex:indexPath.row];
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
    [self.scrollView addSubview:self.myTableView];
    [self.scrollView addSubview:self.wordTableView];
    self.scrollView.scrollEnabled = NO;
//    self.sentenceArray = [collectionSentenceModel jr_findAll];
//    [self.myTableView reloadData];
    [self loadData];
    self.mySwitch = [[WZSwitch alloc]initWithFrame:CGRectMake(0, 0, 105, 36)];
    [self.view addSubview:_mySwitch];
    [_mySwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-30);
        make.width.equalTo(@105);
        make.height.equalTo(@36);
    }];
    self.mySwitch.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    self.mySwitch.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    self.mySwitch.layer.shadowOpacity = 0.3;//不透明度
    self.mySwitch.layer.shadowRadius = 2.0;//半径
    self.mySwitch.layer.masksToBounds = NO;
    self.mySwitch.leftString = @"单词";
    self.mySwitch.rightString = @"句子";
    self.mySwitch.backgroundColor = [UIColor whiteColor];
    self.mySwitch.selectColor = DRGBCOLOR;
    self.mySwitch.unselectColor = UIColorFromRGB(0xDCDCDC);
    if (!_switchType) {
        [self.mySwitch setSwitchState:NO animation:NO];
    }else{
        [self.mySwitch setSwitchState:YES animation:NO];
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }
    [self.mySwitch setTextFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    WeakSelf
    self.mySwitch.block = ^(BOOL state) {
        //yes句子  no 单词 
        if (state) {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(0, 0);
            }];
        }
    };
    
}
- (void)loadData{
    if (IS_USER_ID) {
        [self.wordTableView ly_startLoading];
        [self.myTableView ly_startLoading];
        [LTHttpManager findSectenceNoteWIthUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"];
                [self.sentenceArray removeAllObjects];
                for (NSDictionary *dic in array) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        collectionSentenceModel *model = [collectionSentenceModel mj_objectWithKeyValues:dic];
                        [self.sentenceArray addObject:model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.myTableView reloadData];
                        });
                    });
                }
                self.myTableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"您还没有笔记"];
                [self.myTableView ly_endLoading];
            }else{
                self.myTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                    [self loadData];
                }];
                [self.myTableView ly_endLoading];
            }
           
        }];
        [LTHttpManager findWordsWithUserId:IS_USER_ID Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *array = data[@"responseData"];
                [self.wordArray removeAllObjects];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        collectionWordModel *model = [collectionWordModel mj_objectWithKeyValues:obj];
                        [self.wordArray addObject:model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.wordTableView reloadData];
                        });
                    });
                }];
                self.wordTableView.ly_emptyView = [LTEmpty NoDataEmptyWithMessage:@"您还没有笔记"];
                [self.wordTableView ly_endLoading];
            }else{
                self.wordTableView.ly_emptyView = [LTEmpty NoNetworkEmpty:^{
                    [self loadData];
                }];
                [self.wordTableView ly_endLoading];
            }
        }];
    }else{
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
        [alertView show];
        alertView.resultIndex = ^(NSInteger index) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        };
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
