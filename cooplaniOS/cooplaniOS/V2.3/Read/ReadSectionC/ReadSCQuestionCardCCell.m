//
//  ReadSCQuestionCardCCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ReadSCQuestionCardCCell.h"
#import "NoHighlightedTableViewCell.h"

@interface ReadSCQuestionCardCCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *questionLb;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ReadSCQuestionCardCCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 32, 150)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(10);
            make.right.equalTo(headerView.mas_right).offset(-10);
            make.top.equalTo(headerView.mas_top);
            make.height.equalTo(@30);
        }];
        [btn setImage:[UIImage imageNamed:@"上下拉动"] forState:UIControlStateNormal];
        btn.userInteractionEnabled = YES;
        
        UILabel *passageNoLb = [UILabel new];
        passageNoLb.text = @"Questions 46 to 50 are based on the";
        passageNoLb.textColor = UIColorFromRGB(0x666666);
        passageNoLb.font = [UIFont boldSystemFontOfSize:14];
        passageNoLb.numberOfLines = 2;
        [headerView addSubview: passageNoLb];
        [passageNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(20);
            make.right.equalTo(headerView.mas_right).offset(-20);
            make.height.equalTo(@44);
            make.top.equalTo(btn.mas_bottom);
        }];
        
        UILabel *questionNoLb = [UILabel new];
        questionNoLb.text = @"Q46";
        questionNoLb.textColor = UIColorFromRGB(0xBBBBBB);
        questionNoLb.font = [UIFont boldSystemFontOfSize:14];
        [headerView addSubview:questionNoLb];
        [questionNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passageNoLb);
            make.right.equalTo(passageNoLb);
            make.height.equalTo(@43);
            make.top.equalTo(passageNoLb.mas_bottom);
        }];
        
        UILabel *questionLb = [UILabel new];
        questionLb.text = @"Questions 46 to 50 are based on the";
        questionLb.textColor = UIColorFromRGB(0x444444);
        questionLb.font = [UIFont systemFontOfSize:14];
        questionLb.numberOfLines = 2;
        [questionNoLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passageNoLb);
            make.right.equalTo(passageNoLb);
            make.height.equalTo(@40);
            make.top.equalTo(questionNoLb.mas_bottom);
        }];
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.top.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
        }];
        tableView.scrollEnabled = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView.layer setCornerRadius:8];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.tableFooterView = [UIView new];
        tableView.tableHeaderView = headerView;
        [tableView registerClass:[NoHighlightedTableViewCell class] forCellReuseIdentifier:NSStringFromClass([NoHighlightedTableViewCell class])];
        [tableView.layer setCornerRadius:12];
        [tableView.layer setShadowOpacity:0.2];
        [tableView.layer setShadowColor:[UIColor blackColor].CGColor];
        [tableView.layer setShadowOffset:CGSizeMake(2, 2)];
        [tableView.layer setMasksToBounds:NO];
    
        self.tableView = tableView;
        self.questionLb = questionLb;
    }
    return self;
}
#pragma mark UITableViewDataSource&Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoHighlightedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoHighlightedTableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColorFromRGB(0xFFCE43);
    cell.selectedBackgroundView = view;
    
    UILabel *label = [UILabel new];
    [cell addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell);
        make.right.equalTo(cell);
        make.bottom.equalTo(cell.mas_bottom).offset(-1);
        make.height.equalTo(@1);
    }];
    label.backgroundColor = UIColorFromRGB(0xE9E9E9);
    dispatch_async(dispatch_get_main_queue(), ^{
        //            [cell setSelected:model.isSelecteOption animated:YES];
    });
    cell.selectionStyle = YES;
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.text = [NSString stringWithFormat:@"B.    She found birds and dolphins sleep in much"];
    return cell;
}
@end
