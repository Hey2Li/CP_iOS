//
//  NewCheckWordView.m
//  cooplaniOS
//
//  Created by Lee on 2018/9/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "NewCheckWordView.h"
#import "WordDetailFirstCellTableViewCell.h"
#import "WordDetailSecondTableViewCell.h"
#import "WordDetailThirdTableViewCell.h"
#import "WordDetailFooterView.h"

@interface NewCheckWordView()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    /**
     是否触摸到可拖动区域
     */
    BOOL isMove;
    CGPoint _currentPoint;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *clickBtn;
@property (nonatomic, strong) UIButton *closeBtn;
@end

@implementation NewCheckWordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initWithView];
    }
    return self;
}
- (void)setWord:(NSString *)word{
    _word = word;
    [LTHttpManager searchWordWithWord:word Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *array = data[@"responseData"][@"symbols"];
            if ([data[@"responseData"][@"state"] isEqualToString:@"0"]) {
            }else if ([data[@"responseData"][@"state"] isEqualToString:@"1"]){
            }
            NSDictionary *parts = array[0];
            NSString *enStr = parts[@"ph_en"];
            enStr = [enStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *amStr = parts[@"ph_am"];
            amStr = [amStr stringByReplacingOccurrencesOfString:@" " withString:@""];

            if ([parts[@"ph_am_mp3"] isEqualToString:@""]) {
              
            }else{
               
            }
            [_tableView reloadData];
        }else{
            //
        }
    }];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 130) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setImage:[UIImage imageNamed:@"上拉-2"] forState:UIControlStateNormal];
    [clickBtn setImage:[UIImage imageNamed:@"收起"] forState:UIControlStateSelected];
    [self addSubview:clickBtn];
    [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
        make.centerX.equalTo(self);
    }];
    [clickBtn addTarget:self action:@selector(TopAndDown:) forControlEvents:UIControlEventTouchUpInside];
    self.clickBtn = clickBtn;
    
    [self addSubview:tableView];
    
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailFirstCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailSecondTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailThirdTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
    
    tableView.estimatedRowHeight = 140.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView = tableView;
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_closeBtn];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(10);
        make.height.equalTo(@18);
        make.width.equalTo(@50);
    }];
    [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    _closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.tableView.estimatedRowHeight = 144.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return self.tableView.rowHeight;
    }else{
        self.tableView.estimatedRowHeight = 110.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        return  self.tableView.rowHeight;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WordDetailFirstCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
//        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 1){
        WordDetailSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
//        cell.enAndZhLb.text = [NSString stringWithFormat:@"%@\n%@",self.model.eg_en ? self.model.eg_en : @"", self.model.eg_cn ? self.model.eg_cn : @""];
        return cell;
    }else if (indexPath.row == 2){
        WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
//        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.mnemonic ? self.model.mnemonic : @""];
        return cell;
    }else{
        WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
        cell.cellTitleCell.text = @"提示";
//        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.prompt ? self.model.prompt : @""];
        return cell;
    }
}
#pragma mark 拖拽手势
/*
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"---触摸开始");
    UITouch *touch = [touches anyObject];
    _currentPoint = [touch locationInView:self];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:nil];//传空获取当前窗口的坐标
    currentPoint.y += self.height / 2.0f - _currentPoint.y - 64 - 86;
    if (currentPoint.y < self.height / 2.0f + 20) {
        currentPoint.y = self.height / 2.0f + 20;
        self.clickBtn.selected = YES;//上拉到顶部
//        [[NSNotificationCenter defaultCenter]postNotificationName:kCloseTBUser object:nil];
    }
    if (currentPoint.y > SCREEN_HEIGHT - self.height / 2.0f - 64) {
        currentPoint.y = SCREEN_HEIGHT - self.height / 2.0f - 64;
        self.clickBtn.selected = NO;//下拉到底部
//        [[NSNotificationCenter defaultCenter]postNotificationName:kOpenTBUser object:nil];
    }
    currentPoint.x = self.width / 2.0f;
    [UIView animateWithDuration:0.1 animations:^{
        self.center = currentPoint;
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"FlyElephant---触摸结束");
}
 */

- (void)TopAndDown:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.height = SCREEN_HEIGHT - 64 - 130;
            self.transform = CGAffineTransformMakeTranslation(0, - (SCREEN_HEIGHT - 64 - 100 - 140));
        } completion:^(BOOL finished) {
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.height = 200;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
}
- (void)closeClick:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, 140);
    } completion:^(BOOL finished) {
        if (self.closeBlock) {
            self.closeBlock();
        }
        [self removeFromSuperview];
        [[NSNotificationCenter defaultCenter]postNotificationName:kFindWordIsClose object:nil];
    }];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
