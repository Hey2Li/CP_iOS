//
//  LTAlertView.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTAlertView.h"

@interface LTAlertView()
//弹窗
@property (nonatomic, strong) UIView *alertView;
//title
@property (nonatomic, strong) UILabel *titleLb;
//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;
//取消按钮
@property (nonatomic, strong) UIButton *cancleBtn;
//横线线
@property (nonatomic, strong) UILabel *lineLb;
//竖线
@property (nonatomic, strong) UILabel *verLineLb;

@end

@implementation LTAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title sureBtn:(NSString *)sureTitle cancleBtn:(NSString *)cancleTitle{
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4/1.0];
        self.alertView = [[UIView alloc]init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 14.0;
        [self.alertView.layer setMasksToBounds:YES];
        [self addSubview:self.alertView];
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@162);
            make.width.equalTo(@270);
        }];
        
        self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancleBtn.backgroundColor = [UIColor whiteColor];
        [self.cancleBtn setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
        self.cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.alertView addSubview:self.cancleBtn];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView.mas_bottom);
            make.height.equalTo(@45);
            make.width.equalTo(@134);
            make.left.equalTo(self.alertView);
        }];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.backgroundColor = [UIColor whiteColor];
        [self.sureBtn setTitleColor:DRGBCOLOR forState:UIControlStateNormal];
        self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.alertView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView.mas_bottom);
            make.height.equalTo(self.cancleBtn.mas_height);
            make.width.equalTo(self.cancleBtn.mas_width);
            make.right.equalTo(self.alertView);
        }];
        
        self.lineLb = [[UILabel alloc]init];
        self.lineLb.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.alertView addSubview:self.lineLb];
        [self.lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView);
            make.right.equalTo(self.alertView);
            make.height.equalTo(@1);
            make.bottom.equalTo(self.sureBtn.mas_top);
        }];
        
        self.verLineLb = [[UILabel alloc]init];
        self.verLineLb.backgroundColor = UIColorFromRGB(0xebebeb);
        [self.alertView addSubview:self.verLineLb];
        [self.verLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineLb.mas_bottom);
            make.bottom.equalTo(self.alertView.mas_bottom);
            make.width.equalTo(@1);
            make.left.equalTo(self.sureBtn.mas_left);
        }];
        
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.textColor = UIColorFromRGB(0x666666);
        self.titleLb.font = [UIFont systemFontOfSize:18];
        self.titleLb.numberOfLines = 2;
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.alertView.mas_centerY).offset(-22);
//            make.bottom.equalTo(self.alertView.mas_bottom).offset(-28);
            make.left.equalTo(self.alertView.mas_left).offset(23.5);
            make.right.equalTo(self.alertView.mas_right).offset(-25.5);
        }];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 10;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];

        if (title) {
            self.titleLb.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
            self.titleLb.textAlignment = NSTextAlignmentCenter;
        }else{
            self.titleLb.text = @"";
        }
        if (cancleTitle.length > 0) {
            [self.cancleBtn setTitle:cancleTitle forState:UIControlStateNormal];
        }else{
            [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
        if (sureTitle.length > 0) {
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        self.sureBtn.tag = 2000;
        self.cancleBtn.tag = 1000;
        [self.sureBtn addTarget:self action:@selector(buttonEnvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleBtn addTarget:self action:@selector(buttonEnvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)show{
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    [rootWindow addSubview:self];
    [self creatShowAnimation];
}
- (void)creatShowAnimation{
    self.alertView.layer.position = self.center;
    self.alertView.transform = CGAffineTransformMakeScale(0.90, 0.90);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.alertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
    }];
}
- (void)buttonEnvent:(UIButton *)sender{
    if (sender.tag == 2000) {
        if (self.resultIndex) {
            self.resultIndex(sender.tag);
        }
    }
    [self removeFromSuperview];
}
- (void)dismiss{
    [self removeFromSuperview];
}
@end
