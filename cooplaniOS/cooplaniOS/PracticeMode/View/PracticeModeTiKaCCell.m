//
//  PracticeModeTiKaCCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PracticeModeTiKaCCell.h"
#import "PaperJSONKey.h"

@interface PracticeModeTiKaCCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *questionLb;
@property (nonatomic, strong) NSMutableArray *questionArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PracticeModeTiKaCCell
- (NSMutableArray *)questionArray{
    if (!_questionArray) {
        _questionArray = [NSMutableArray array];
    }
    return _questionArray;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(17);
            make.right.equalTo(self.mas_right).offset(-17);
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
        tableView.scrollEnabled = NO;
        [backView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView.mas_left);
            make.right.equalTo(backView.mas_right);
            make.top.equalTo(self.mas_top).offset(30);
            make.bottom.equalTo(backView.mas_bottom);
        }];
        [tableView.layer setCornerRadius:8];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [UIView new];
        self.tableView = tableView;
        
        UILabel *questionLb = [[UILabel alloc]init];
        questionLb.text = @"这是题目";
        questionLb.numberOfLines = 2;
        questionLb.textColor = UIColorFromRGB(0x666666);
        questionLb.font = [UIFont boldSystemFontOfSize:14];
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 80)];
        [tableView.tableHeaderView addSubview:questionLb];
        [questionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).offset(20);
            make.right.equalTo(backView).offset(-20);
            make.height.equalTo(@80);
            make.top.equalTo(backView).offset(35);
        }];
        self.questionLb = questionLb;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView.mas_left).offset(10);
            make.right.equalTo(tableView.mas_right).offset(-10);
            make.top.equalTo(tableView.mas_top);
            make.height.equalTo(@30);
        }];
        [btn setImage:[UIImage imageNamed:@"Group 3"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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
    }
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questionArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [Tool layoutForAlliPhoneHeight:60];
    }else{
        return [Tool layoutForAlliPhoneHeight:45];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = NO;
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"Q%ld",self.collectionIndexPath.row + 1];
        cell.textLabel.textColor = UIColorFromRGB(0xBBBBBB);
    }else{
        OptionsModel *model = self.questionArray[indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@.%@",model.Alphabet,model.Text];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
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
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)setQuestionsModel:(QuestionsModel *)questionsModel{
    _questionsModel = questionsModel;
    [self.questionArray removeAllObjects];
    for (OptionsModel *optionsModel in questionsModel.Options) {
        [self.questionArray addObject:optionsModel];
    }
    [self.tableView reloadData];
}
@end
