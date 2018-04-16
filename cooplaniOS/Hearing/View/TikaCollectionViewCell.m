//
//  TikaCollectionViewCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TikaCollectionViewCell.h"

@interface TikaCollectionViewCell ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TikaCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(50);
            make.right.equalTo(self.mas_right).offset(-50);
            make.top.equalTo(self.mas_top).offset(50);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [tableView.layer setCornerRadius:5];
        tableView.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blackColor];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tableView.mas_left);
            make.right.equalTo(tableView.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(tableView.mas_top);
        }];
        [btn setTitle:@"click" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)btnClick:(UIButton *)btn{
    if (self.UpAndDownBtnClick) {
        self.UpAndDownBtnClick(btn);
    }
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"Q%ld",(long)indexPath.row];
    return cell;
}
@end
