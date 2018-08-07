//
//  ReciteWordsViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReciteWordsViewController.h"
#import "ReciteWordTbFooterView.h"
#import "ReciteWordTbHeaderView.h"
#import "NotKnowView.h"
#import "WordTestDoneViewController.h"
#import "ReciteWordTableViewCell.h"
#import "ReciteWordModel.h"
#import "SUPlayer.h"


@interface ReciteWordsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ReciteWordTbHeaderView *tableViewHeaderView;
@property (nonatomic, strong) ReciteWordTbFooterView *tableViewFooterView;
@property (nonatomic, strong) NotKnowView *notKonwView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int wordIndex;
@property (nonatomic, strong) NSMutableArray *postDataArray;
@property (nonatomic, strong) NSDateFormatter *currentDate;
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, strong) ReciteWordTableViewCell *selectionCell;
@property (nonatomic, assign) BOOL isSelectedCell;//cell是否被点击
@end

@implementation ReciteWordsViewController
- (SUPlayer *)player{
    if (!_player) {
        _player = [[SUPlayer alloc]init];
    }
    return _player;
}
- (NSMutableArray *)postDataArray{
    if (!_postDataArray) {
        _postDataArray = [NSMutableArray array];
    }
    return _postDataArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
//- (NotKnowView *)notKonwView{
//    if (!_notKonwView) {
//        _notKonwView = [[NotKnowView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 360)];
//        [self.view bringSubviewToFront:_notKonwView];
//        [_notKonwView.nextWordBtn addTarget:self action:@selector(goOnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _notKonwView;
//}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        _myTableView.scrollEnabled = NO;
        _myTableView.tableFooterView = [UIView new];
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReciteWordTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReciteWordTableViewCell class])];
    }
    return _myTableView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
    self.mm_drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeNone;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    [self loadData];
    _wordIndex = 0;
}
- (void)loadData{
    [LTHttpManager findAllAppWordWithUser_id:IS_USER_ID WordbookId:@"1" Num:@"20" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"];
            if (array.count > 0) {
                _wordIndex = 0;
                [self.postDataArray removeAllObjects];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in array) {
                    ReciteWordModel *model = [ReciteWordModel mj_objectWithKeyValues:dic];
                    [model.arr_options addObject:model.result];
                    NSMutableArray *beginArray = [NSMutableArray arrayWithArray:model.arr_options];
                    NSInteger arrayCount = beginArray.count;
                    NSMutableArray *endArray = [NSMutableArray array];
                    for (int i = 0; i < arrayCount ; i++) {
                        int num = arc4random() % beginArray.count;
                        [endArray addObject:beginArray[num]];
                        [beginArray removeObjectAtIndex:num];
                    }
                    [model.arr_options removeAllObjects];
                    model.arr_options = [NSMutableArray arrayWithArray:endArray];
                    [self.dataArray addObject:model];
                }
                [self.myTableView reloadData];
            }else{
                WordTestDoneViewController *vc = [[WordTestDoneViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}
- (void)initWithView{
    ReciteWordTbHeaderView *tableHeaderView = [[ReciteWordTbHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
    NSArray<UIImage*> *imageArray=[NSArray arrayWithObjects:
                                   [UIImage imageNamed:@"播放2根线"],
                                   [UIImage imageNamed:@"播放一根线"]
                                   ,nil];
    tableHeaderView.playImageView.image = [UIImage imageNamed:@"播放2根线"];
    //赋值
    tableHeaderView.playImageView.animationImages = imageArray;
    //周期时间
    tableHeaderView.playImageView.animationDuration = 1;
    //重复次数，0为无限制
    tableHeaderView.playImageView.animationRepeatCount = 1;
    
    [tableHeaderView.playBtn addTarget:self action:@selector(playAnimation:) forControlEvents:UIControlEventTouchUpInside];
    
    ReciteWordTbFooterView *tableFooterView = [[ReciteWordTbFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 105)];
    [tableFooterView.nextWordBtn addTarget:self action:@selector(nextWordClick:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView.notKnowBtn addTarget:self action:@selector(notKnowClick:) forControlEvents:UIControlEventTouchUpInside];
    self.myTableView.tableFooterView = tableFooterView;
    self.myTableView.tableHeaderView = tableHeaderView;
    self.tableViewHeaderView = tableHeaderView;
    self.tableViewFooterView = tableFooterView;
    [self.view addSubview:self.myTableView];
    
    _notKonwView = [[NotKnowView alloc]init];
    [_notKonwView.nextWordBtn addTarget:self action:@selector(goOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_notKonwView.addNoteBtn addTarget:self action:@selector(addNoteClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_notKonwView];
    [_notKonwView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.equalTo(@360);
    }];
}
#pragma mark Play播放动画
-(void)playAnimation:(UIButton *)btn{
    btn.enabled = NO;
    [self.tableViewHeaderView.playImageView startAnimating];
    ReciteWordModel *model = self.dataArray[_wordIndex];
    [[self.player initWithURL:[NSURL URLWithString:model.us_mp3]] play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [self.tableViewHeaderView.playImageView startAnimating];
//    }else{
//        [self.tableViewHeaderView.playImageView stopAnimating];
//        self.tableViewHeaderView.playImageView.image = self.tableViewHeaderView.playImageView.animationImages.firstObject;
//    }
}
#pragma mark 下一个
- (void)nextWordClick:(UIButton *)btn{
    ReciteWordModel *model = self.dataArray[_wordIndex];
    NSString *wordId = [NSString stringWithFormat:@"%ld",(long)model.ID];
    NSInteger socre = model.score;
    socre = socre + 0;//下一个+0
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:IS_USER_ID forKey:@"user_id"];
    [dict setValue:wordId forKey:@"word_id"];
    [dict setValue:[self getCurrentTimes] forKey:@"time"];
    [dict setValue:@(socre) forKey:@"score"];
    [dict setValue:@(model.word_book_id) forKey:@"word_book_id"];
    [self.postDataArray addObject:dict];
    [self nextWordReloadData];
}
#pragma mark 添加到笔记
- (void)addNoteClick:(UIButton *)btn{
    ReciteWordModel *model = self.dataArray[_wordIndex];
    btn.enabled = NO;
    if (IS_USER_ID) {
        [LTHttpManager addWordsWithUserId:IS_USER_ID Word:model.word Tranlate:[self arrayToJSONString:@[model.result]] Ph_en_mp3:model.uk_mp3 Ph_am_mp3:model.us_mp3 Ph_am:model.us_soundmark Ph_en:model.uk_soundmark Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                SVProgressShowStuteText(@"添加成功", YES);
                [self.notKonwView.addNoteImg setImage:[UIImage imageNamed:@"已添加-2"]];
                [self.notKonwView.addNoteLb setText:@"已添加"];
                [self.notKonwView.addNoteLb  setTextColor:UIColorFromRGB(0xcccccc)];
            }else{
                SVProgressShowStuteText(message, NO);
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
#pragma mark 不认识
- (void)notKnowClick:(UIButton *)btn{
    ReciteWordModel *model = self.dataArray[_wordIndex];
    [[self.player initWithURL:[NSURL URLWithString:model.us_mp3]] play];
    NSString *wordId = [NSString stringWithFormat:@"%ld",(long)model.ID];
    NSInteger socre = model.score;
    socre = socre + 0;//不认识+0
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:IS_USER_ID forKey:@"user_id"];
    [dict setValue:wordId forKey:@"word_id"];
    [dict setValue:[self getCurrentTimes] forKey:@"time"];
    [dict setValue:@(socre) forKey:@"score"];
    [dict setValue:@(model.word_book_id) forKey:@"word_book_id"];
    [self.postDataArray addObject:dict];
    
    [self.notKonwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-360);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@360);
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }];
}
- (void)goOnClick:(UIButton *)btn{
    [self.notKonwView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@360);
    }];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ceilf((SCREEN_HEIGHT - 250 - 105 - 64)/4);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReciteWordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ReciteWordTableViewCell class])];
    cell.selectionStyle = NO;
    if (self.dataArray.count && _wordIndex < self.dataArray.count) {
        ReciteWordModel *model = self.dataArray[_wordIndex];
        self.tableViewHeaderView.wordLb.text = model.word;
        self.tableViewHeaderView.phonogramLb.text = model.us_soundmark;
        self.notKonwView.exampleLb.text = model.ex;
        self.notKonwView.wordMeanLb.text = model.result;
        if (indexPath.row == 0) {
            cell.optionsTitle.text = @"A.";
            cell.optionsLb.text = model.arr_options.count > 0 ? model.arr_options[0] : @"";
        }else if (indexPath.row == 1){
            cell.optionsTitle.text = @"B.";
            cell.optionsLb.text = model.arr_options.count > 1 ? model.arr_options[1] : @"";
        }else if (indexPath.row == 2){
            cell.optionsTitle.text = @"C.";
            cell.optionsLb.text = model.arr_options.count > 2 ? model.arr_options[2] : @"";
        }else{
            cell.optionsTitle.text = @"D.";
            cell.optionsLb.text = model.arr_options.count > 3 ? model.arr_options[3] : @"";
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isSelectedCell) {
        self.isSelectedCell = YES;
        ReciteWordModel *model = self.dataArray[_wordIndex];
        ReciteWordTableViewCell *cell = [tableView  cellForRowAtIndexPath:[tableView indexPathForSelectedRow]];
        [cell.optionsLb setTextColor:[UIColor whiteColor]];
        [cell.optionsTitle setTextColor:[UIColor whiteColor]];
        NSString *optionStr = cell.optionsLb.text;
        NSString *wordId = [NSString stringWithFormat:@"%ld",(long)model.ID];
        NSInteger socre = model.score;
        NSLog(@"%@----%@",optionStr,model.result);
        if ([optionStr isEqualToString:model.result]) {//判断单词多少分数
            if ([model.state isEqualToString:@"1"]) {
                socre = socre + 100;//第一次背对直接+100 熟练词
            }else{
                socre = socre + 50;//第一次背错 后来背对 + 50 记忆中
            }
            cell.selectedView.backgroundColor = UIColorFromRGB(0x7EDDBC);
            [self playYESVoice];
        }else{
            socre = socre - 25;//背错 -25 常错词
            cell.selectedView.backgroundColor = UIColorFromRGB(0xE6948E);
            [self playNOVoice];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:IS_USER_ID forKey:@"user_id"];
        [dict setValue:wordId forKey:@"word_id"];
        [dict setValue:[self getCurrentTimes] forKey:@"time"];
        [dict setValue:@(socre) forKey:@"score"];
        [dict setValue:@(model.word_book_id) forKey:@"word_book_id"];
        [self.postDataArray addObject:dict];
        self.selectionCell = cell;
        [self reloadNextWord];
    }
}
- (void)reloadNextWord{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self nextWordReloadData];
        self.isSelectedCell = NO;
    });
}
- (void)nextWordReloadData{
    _wordIndex ++;
    if (_wordIndex >= self.dataArray.count) {
        LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"你已经完成今日任务，是否继续" sureBtn:@"继续" cancleBtn:@"歇一歇"];
        alertView.resultIndex = ^(NSInteger index) {
            //发给后台
            [LTHttpManager saveOldWordWithwordData:[self arrayToJSONString:self.postDataArray] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [self loadData];
                }
            }];
        };
        alertView.cancelClick = ^(NSInteger index) {
            [LTHttpManager saveOldWordWithwordData:[self arrayToJSONString:self.postDataArray] Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    _wordIndex = 0;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        };
        [alertView show];
    }else{
        ReciteWordModel *model = self.dataArray[_wordIndex];
        [[self.player initWithURL:[NSURL URLWithString:model.us_mp3]] play];
    }
    [self.selectionCell.optionsLb setTextColor:UIColorFromRGB(0x666666)];
    [self.selectionCell.optionsTitle setTextColor:UIColorFromRGB(0x666666)];

    self.selectionCell.selectedView.backgroundColor = [UIColor whiteColor];
    [self.notKonwView.addNoteImg setImage:[UIImage imageNamed:@"添加-4"]];
    [self.notKonwView.addNoteLb setText:@"添加到笔记"];
    [self.notKonwView.addNoteLb  setTextColor:UIColorFromRGB(0xFFCE43)];
    self.notKonwView.addNoteBtn.enabled = YES;
    [self.myTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSString *)arrayToJSONString:(NSArray *)array{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
- (NSString*)getCurrentTimes{
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [self.currentDate stringFromDate:datenow];
    return currentTimeString;
}
- (NSDateFormatter *)currentDate{
    if (!_currentDate) {
        _currentDate = [[NSDateFormatter alloc]init];
        [_currentDate setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return _currentDate;
}
/**
 *  字典转JSON字符串
 *
 *  @param dic 字典
 *
 *  @return JSON字符串
 */
- (NSString*)dictionaryToJson:(NSDictionary *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)playYESVoice{
    NSString *audioFile = [[NSBundle mainBundle]pathForResource:@"YES" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    [[self.player initWithURL:fileUrl]play];
}
- (void)playNOVoice{
    // 普通短震，3D Touch 中 Peek 震动反馈
    AudioServicesPlaySystemSound(1519);
    NSString *audioFile = [[NSBundle mainBundle]pathForResource:@"NO" ofType:@"mp3"];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    [[self.player initWithURL:fileUrl]play];
}
- (void)dealloc{
    [self.player stop];
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
