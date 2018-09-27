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
#import "FindWordTopTableViewCell.h"

#define kFindWordHeight  SCREEN_HEIGHT - SafeAreaTopHeight - 12
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
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSDictionary *partsDict;
@property (nonatomic, strong) NSArray *dataArray;
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
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -3);
        self.layer.shadowOpacity = 0.15;
        [self initWithView];
    }
    return self;
}
- (void)setWord:(NSString *)word{
    _word = word;
    [LTHttpManager searchWordWithWord:word Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            NSArray *array = data[@"responseData"][@"symbols"];
            self.partsDict = array[0];
            [_tableView reloadData];
        }else{
            //
        }
    }];
}
- (void)initWithView{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFindWordHeight) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    [self addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailFirstCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailSecondTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WordDetailThirdTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FindWordTopTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FindWordTopTableViewCell class])];
    tableView.estimatedRowHeight = 140.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIView *bottomView= [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(tableView.mas_bottom);
        make.height.equalTo(@(47));
    }];
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"X 关闭详情" forState:UIControlStateNormal];
    [closeBtn setTitleColor:UIColorFromRGB(0xFFCE43) forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomView.mas_centerX);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.equalTo(@(78));
        make.height.equalTo(@(22));
    }];
    [closeBtn.layer setBorderWidth:1.0f];
    [closeBtn.layer setBorderColor:UIColorFromRGB(0xFFCE43).CGColor];
    [closeBtn.layer setCornerRadius:11.0f];
    _bottomView = bottomView;
    _bottomView.hidden = YES;
    self.tableView = tableView;
    self.tableView.scrollEnabled = NO;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.clickBtn.selected) {
        return 143;
    }else{
        if (indexPath.row == 0) {
            self.tableView.estimatedRowHeight = 144.0f;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return self.tableView.rowHeight;
        }else if (indexPath.row == 4){
            return 47;
        }else{
            self.tableView.estimatedRowHeight = 110.0f;
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            return  self.tableView.rowHeight;
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clickBtn.selected ? 5 : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickBtn.selected) {
        if (indexPath.row == 0) {
            WordDetailFirstCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailFirstCellTableViewCell class])];
            cell.wordNameLb.text = [NSString stringWithFormat:@"%@", self.word];
            cell.dataDict = self.partsDict;
            return cell;
        }else if (indexPath.row == 1){
            WordDetailSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailSecondTableViewCell class])];
            //        cell.enAndZhLb.text = [NSString stringWithFormat:@"%@\n%@",self.model.eg_en ? self.model.eg_en : @"", self.model.eg_cn ? self.model.eg_cn : @""];
            return cell;
        }else if (indexPath.row == 2){
            WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
            //        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.mnemonic ? self.model.mnemonic : @""];
            return cell;
        }else if (indexPath.row == 3){
            WordDetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WordDetailThirdTableViewCell class])];
            cell.cellTitleCell.text = @"提示";
            //        cell.helpMemoryLb.text = [NSString stringWithFormat:@"%@", self.model.prompt ? self.model.prompt : @""];
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = NO;
            return cell;
        }
    }else{
        //未展开的时候
        FindWordTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FindWordTopTableViewCell class])];
        [cell.lookForDetailBtn addTarget:self action:@selector(TopAndDown:) forControlEvents:UIControlEventTouchUpInside];
        self.clickBtn = cell.lookForDetailBtn;
        cell.wordName.text = [NSString stringWithFormat:@"%@", self.word];
        cell.dataDict = self.partsDict;
        return cell;
    }
}
- (void)TopAndDown:(UIButton *)btn{
    NSLog(@"findWordViewFrame:%@,%f",NSStringFromCGRect(self.frame), SCREEN_HEIGHT);
    btn.selected = !btn.selected;
    if (self.findViewIsOpenBlock) {
        self.findViewIsOpenBlock(btn);
    }
    if (btn.selected) {
        self.tableView.scrollEnabled = YES;
        self.bottomView.hidden = NO;
//        [UIView animateWithDuration:0.2 animations:^{
//            self.height = kFindWordHeight;
//            self.transform = CGAffineTransformMakeTranslation(0, -(kFindWordHeight) + 143);
//        } completion:^(BOOL finished) {
//        }];
    }else{
        self.tableView.scrollEnabled = NO;
        self.bottomView.hidden = YES;
//        [UIView animateWithDuration:0.2 animations:^{
//            self.height = 143;
//            self.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//        }];
    }
    [self.tableView reloadData];
}
- (void)closeClick:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, kFindWordHeight);
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
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView * fitView = [super hitTest:point withEvent:event];
    NSLog(@"hitTest:%@",fitView);
    //    UIResponder *nextResponder = [self nextResponder];
    //    do {
    //        if ([nextResponder isKindOfClass:[UICollectionView class]]) {
    //            return (UICollectionView *)nextResponder;
    //        }
    //        nextResponder = [nextResponder nextResponder];
    //    } while (nextResponder != nil);
    //        return ;
    if (fitView == nil) {
        [self removeFromSuperview];
        if (self.closeBlock) {
            self.closeBlock();
        }
    }
    return fitView;
}
@end
