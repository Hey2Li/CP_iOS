//
//  TikaCollectionViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TikaCollectionViewCell.h"

@interface TikaCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *questionLb;
@end

@implementation TikaCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(17);
            make.right.equalTo(self.mas_right).offset(-17);
            make.top.equalTo(self.mas_top).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        tableView.separatorStyle = NO;
        [tableView.layer setCornerRadius:8];
        [tableView.layer setShadowOpacity:0.5];
        [tableView.layer setShadowColor:[UIColor blackColor].CGColor];
        [tableView.layer setShadowOffset:CGSizeMake(2, 2)];
        [tableView.layer setMasksToBounds:YES];
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
            make.height.equalTo(@60);
            make.top.equalTo(tableView);
        }];
        self.questionLb = questionLb;
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
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"Q%ld",self.collectionIndexPath.row + 1];
        cell.textLabel.textColor = UIColorFromRGB(0xBBBBBB);
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%ld.Her friend Erika.",(long)indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.questionCellClick) {
        self.questionCellClick(self.collectionIndexPath);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
