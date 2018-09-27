//
//  PracticeModeTiKaCCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PracticeModeTiKaCCell.h"
#import "PaperJSONKey.h"
#import "NoHighlightedTableViewCell.h"

@interface PracticeModeTiKaCCell ()<UITableViewDelegate, UITableViewDataSource>
{
    /**
     是否触摸到可拖动区域
     */
    BOOL isMove;
    CGPoint _currentPoint;
}
@property (nonatomic, strong) UILabel *questionLb;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PracticeModeTiKaCCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(20);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
        }];
        [backView.layer setCornerRadius:12];
        [backView.layer setShadowOpacity:0.2];
        [backView.layer setShadowColor:[UIColor blackColor].CGColor];
        [backView.layer setShadowOffset:CGSizeMake(2, 2)];
        [backView.layer setMasksToBounds:NO];
    
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [backView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_right);
            if (UI_IS_IPHONE5) {
                make.top.equalTo(self.mas_top).offset(0);
            }else{
                make.top.equalTo(self.mas_top).offset(30);
            }
            make.bottom.equalTo(backView.mas_bottom);
        }];
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView.layer setCornerRadius:8];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [UIView new];
        [tableView registerClass:[NoHighlightedTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoHighlightedTableViewCell class])];
        self.tableView = tableView;
        
        UILabel *questionLb = [[UILabel alloc]init];
        questionLb.text = @"这是题目";
        questionLb.numberOfLines = 2;
        questionLb.textColor = UIColorFromRGB(0x666666);
        questionLb.font = [UIFont boldSystemFontOfSize:14];
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, UI_IS_IPHONE4 ? 50 : 80)];
        [tableView.tableHeaderView setBackgroundColor:[UIColor whiteColor]];
        [tableView.tableHeaderView addSubview:questionLb];
        [questionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(20);
            make.right.equalTo(backView).offset(-20);
            make.height.equalTo(@(UI_IS_IPHONE5 ? 50 : 80));
            make.top.equalTo(backView).offset(UI_IS_IPHONE5 ? 20 : 35);
        }];
        self.questionLb = questionLb;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView.mas_left).offset(10);
            make.right.equalTo(tableView.mas_right).offset(-10);
            make.top.equalTo(self.mas_top).offset(UI_IS_IPHONE5 ? 0 : 20);
            make.height.equalTo(@30);
        }];
        [btn setImage:[UIImage imageNamed:@"上下拉动"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        [self btnClick:btn];
    }
    return self;
}

- (void)setQuestionStr:(NSString *)questionStr{
    _questionStr = questionStr;
    self.questionLb.text = questionStr;
}
- (void)btnClick:(UIButton *)btn{
    if (self.UpAndDownBtnClick) {
        self.UpAndDownBtnClick(btn);
        btn.selected = !btn.selected;
    }
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return UI_IS_IPHONE5 ? _questionsModel.Options.count : _questionsModel.Options.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UI_IS_IPHONE5 ? (self.tableView.height - 80)/4 : 50;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoHighlightedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoHighlightedTableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DRGBCOLOR;
    cell.selectedBackgroundView = view;
    if (UI_IS_IPHONE5) {
        UILabel *label = [UILabel new];
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell);
            make.right.equalTo(cell);
            make.bottom.equalTo(cell.mas_bottom).offset(-1);
            make.height.equalTo(@1);
        }];
        label.backgroundColor = UIColorFromRGB(0xE9E9E9);
        OptionsModel *model = _questionsModel.Options[indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setSelected:model.isSelecteOption animated:YES];
        });
        cell.selectionStyle = YES;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = [NSString stringWithFormat:@"%@. %@",model.Alphabet,model.Text];
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Q%ld",self.collectionIndexPath.row + 1];
            cell.textLabel.textColor = UIColorFromRGB(0xBBBBBB);
            cell.selectionStyle = NO;
        }else{
            UILabel *label = [UILabel new];
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell);
                make.right.equalTo(cell);
                make.bottom.equalTo(cell.mas_bottom).offset(-1);
                make.height.equalTo(@1);
            }];
            label.backgroundColor = UIColorFromRGB(0xE9E9E9);
            OptionsModel *model = _questionsModel.Options[indexPath.row - 1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell setSelected:model.isSelecteOption animated:YES];
            });
            cell.selectionStyle = YES;
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.text = [NSString stringWithFormat:@"%@. %@",model.Alphabet,model.Text];
        }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        if (self.questionCellClick) {
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            cell.selected = YES;
            if (UI_IS_IPHONE5) {
                switch (indexPath.row) {
                    case 0:
                        NSLog(@"A");
                        _questionsModel.youAnswer = @"A";
                        self.questionCellClick(self.collectionIndexPath,[@"A" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 1:
                        NSLog(@"B");
                        _questionsModel.youAnswer = @"B";
                        self.questionCellClick(self.collectionIndexPath,[@"B" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 2:
                        NSLog(@"C");
                        _questionsModel.youAnswer = @"C";
                        self.questionCellClick(self.collectionIndexPath,[@"C" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 3:
                        NSLog(@"D");
                        _questionsModel.youAnswer = @"D";
                        self.questionCellClick(self.collectionIndexPath,[@"D" isEqualToString:_questionsModel.Answer]);
                        break;
                    default:
                        break;
                }
                OptionsModel *model = _questionsModel.Options[indexPath.row];
                model.isSelecteOption = YES;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (OptionsModel *otherModel in _questionsModel.Options) {
                        if (otherModel != model) {
                            otherModel.isSelecteOption = NO;
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadData];
                    });
                });
            }else{
                switch (indexPath.row) {
                    case 1:
                        NSLog(@"A");
                        _questionsModel.youAnswer = @"A";
                        self.questionCellClick(self.collectionIndexPath,[@"A" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 2:
                        NSLog(@"B");
                        _questionsModel.youAnswer = @"B";
                        self.questionCellClick(self.collectionIndexPath,[@"B" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 3:
                        NSLog(@"C");
                        _questionsModel.youAnswer = @"C";
                        self.questionCellClick(self.collectionIndexPath,[@"C" isEqualToString:_questionsModel.Answer]);
                        break;
                    case 4:
                        NSLog(@"D");
                        _questionsModel.youAnswer = @"D";
                        self.questionCellClick(self.collectionIndexPath,[@"D" isEqualToString:_questionsModel.Answer]);
                        break;
                    default:
                        break;
                }
                OptionsModel *model = _questionsModel.Options[indexPath.row - 1];
                model.isSelecteOption = YES;
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    for (OptionsModel *otherModel in _questionsModel.Options) {
                        if (otherModel != model) {
                            otherModel.isSelecteOption = NO;
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableView reloadData];
                    });
                });
            }
        }
    }
}
- (void)setQuestionsModel:(QuestionsModel *)questionsModel{
    _questionsModel = questionsModel;
    [self.tableView reloadData];
}
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
        //        [[NSNotificationCenter defaultCenter]postNotificationName:kCloseTBUser object:nil];
    }
    if (currentPoint.y > SCREEN_HEIGHT - self.height / 2.0f - 64) {
        currentPoint.y = SCREEN_HEIGHT - self.height / 2.0f - 64;
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
    return fitView;
}
*/
@end
