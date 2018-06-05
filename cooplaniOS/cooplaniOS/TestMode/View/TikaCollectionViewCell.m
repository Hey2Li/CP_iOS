//
//  TikaCollectionViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TikaCollectionViewCell.h"
#import "NoHighlightedTableViewCell.h"

@interface TikaCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *questionLb;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TikaCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
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
            make.top.equalTo(backView.mas_top);
            make.bottom.equalTo(backView.mas_bottom);
        }];
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
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [tableView.tableHeaderView addSubview:questionLb];
        [questionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(20);
            make.right.equalTo(backView).offset(-20);
            make.height.equalTo(@60);
            make.top.equalTo(backView);
        }];
        self.questionLb = questionLb;
    }
    return self;
}
- (void)btnClick:(UIButton *)btn{
    if (self.UpAndDownBtnClick) {
        self.UpAndDownBtnClick(btn);
    }
}
- (void)setQuestionStr:(NSString *)questionStr{
    _questionStr = questionStr;
    self.questionLb.text = questionStr;
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _questionsModel.Options.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoHighlightedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoHighlightedTableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = DRGBCOLOR;
    cell.selectedBackgroundView = view;
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"Q%@",_questionsModel.QuestionNo];
        cell.textLabel.textColor = UIColorFromRGB(0xBBBBBB);
        cell.selectionStyle = NO;
    }else{
        cell.textLabel.numberOfLines = 2;
        cell.selectionStyle = YES;
        OptionsModel *model = _questionsModel.Options[indexPath.row - 1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setSelected:model.isSelecteOption animated:YES];
        });
        cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",model.Alphabet,model.Text];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) return;
    if (self.questionCellClick) {
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
- (void)setQuestionsModel:(QuestionsModel *)questionsModel{
    _questionsModel = questionsModel;
    [self.tableView reloadData];
}
@end
