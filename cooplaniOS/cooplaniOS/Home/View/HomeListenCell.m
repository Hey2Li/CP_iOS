//
//  HomeListenCell.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HomeListenCell.h"

@implementation HomeListenCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5.0f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.selectionStyle = NO;
    self.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    [self.collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
    [self.collectionBtn setImage:[UIImage imageNamed:@"collection_fill"] forState:UIControlStateSelected];
}
- (void)setFrame:(CGRect)frame{
    frame.origin.x = 15;
    frame.size.width -= 2 * frame.origin.x;
    frame.size.height -= 10;
    [super setFrame: frame];
}
- (IBAction)collectionClick:(UIButton *)sender {
    if (sender.tag == 1) {
        if (IS_USER_ID) {
            [LTHttpManager deleteCollectionTestPaperWithId:_Model.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    SVProgressShowStuteText(@"取消收藏成功", YES);
                    sender.selected = NO;
                    sender.tag = 0;
                    _Model.collection = @"0";
                }else{
                    SVProgressShowStuteText(message, NO);
                }
            }];
        }else{
            LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
            [alertView show];
            alertView.resultIndex = ^(NSInteger index) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.viewController.navigationController pushViewController:vc animated:YES];
            };
        }
    }else if (sender.tag == 0){
        if (IS_USER_ID) {
            [LTHttpManager collectionTestPaperWithUserId:IS_USER_ID TestPaperId:_Model.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    sender.selected = YES;
                    sender.tag = 1;
                    _Model.collection = @"1";
                    SVProgressShowStuteText(@"收藏成功", YES);
                    [LTHttpManager searchCollectionCountWithUserId:IS_USER_ID TestPaperId:_Model.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                        
                    }];
                }else{
                    SVProgressShowStuteText(message, NO);
                }
            }];
        }else{
            LTAlertView *alertView = [[LTAlertView alloc]initWithTitle:@"请先登录" sureBtn:@"去登录" cancleBtn:@"取消"];
            [alertView show];
            alertView.resultIndex = ^(NSInteger index) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                [self.viewController.navigationController pushViewController:vc animated:YES];
            };
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(PaperModel *)Model{
    _Model = Model;
    self.TitleLabel.text = [NSString stringWithFormat:@"%@", Model.name];
    self.detailLabel.text = [NSString stringWithFormat:@"%@",Model.info];
    [self.paperTestImg sd_setImageWithURL:[NSURL URLWithString:Model.coverUrl]];
    if ([Model.collection isEqualToString:@"1"]) {
        self.collectionBtn.tag = 1;
        self.collectionBtn.selected = YES;
        [self.collectionBtn setImage:[UIImage imageNamed:@"collection_fill"] forState:UIControlStateSelected];
    }else if ([Model.collection isEqualToString:@"0"]){
        self.collectionBtn.selected = NO;
         [self.collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        self.collectionBtn.tag = 0;
    }
}
@end
