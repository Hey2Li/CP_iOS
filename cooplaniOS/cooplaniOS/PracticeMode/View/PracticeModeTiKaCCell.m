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
@end

@implementation PracticeModeTiKaCCell
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
        [backView.layer setCornerRadius:8];
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
        
        UILabel *questionLb = [[UILabel alloc]init];
        questionLb.text = @"这是题目";
        questionLb.numberOfLines = 2;
        questionLb.textColor = UIColorFromRGB(0x666666);
        questionLb.font = [UIFont boldSystemFontOfSize:14];
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];
        [tableView.tableHeaderView addSubview:questionLb];
        [questionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView).offset(20);
            make.right.equalTo(tableView).offset(-20);
            make.height.equalTo(@45);
            make.top.equalTo(tableView).offset(35);
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
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;
    }else{
        return 45;
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
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.Her friend Erika.",(long)indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 1) {
        if (self.questionCellClick) {
            switch (indexPath.row) {
                case 1:
                    NSLog(@"A");
                    self.questionCellClick(self.collectionIndexPath,@"A");
                    break;
                case 2:
                    NSLog(@"B");
                    self.questionCellClick(self.collectionIndexPath,@"B");
                    break;
                case 3:
                    NSLog(@"C");
                    self.questionCellClick(self.collectionIndexPath,@"C");
                    break;
                case 4:
                    NSLog(@"D");
                    self.questionCellClick(self.collectionIndexPath,@"D");
                    break;
                default:
                    break;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
