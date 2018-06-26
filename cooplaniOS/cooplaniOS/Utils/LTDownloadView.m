//
//  LTDownloadView.m
//  cooplaniOS
//
//  Created by Lee on 2018/6/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTDownloadView.h"

@interface LTDownloadView()
//弹窗
@property (nonatomic, strong) UIView *alertView;
//title
@property (nonatomic, strong) UILabel *titleLb;
//确认按钮
@property (nonatomic, strong) UIButton *sureBtn;
//横线线
@property (nonatomic, strong) UILabel *lineLb;
//关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

//subtitle
@property (nonatomic, strong) UILabel *subTitleLb;
@end

@implementation LTDownloadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithTitle:(NSString *)title sureBtn:(NSString *)sureTitle fileSize:(NSString *)size{
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
        
        self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeBtn.backgroundColor = [UIColor whiteColor];
        [self.closeBtn setImage:[UIImage imageNamed:@"关闭-1"] forState:UIControlStateNormal];
        [self.closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.alertView.mas_right).offset(-5);
            make.top.equalTo(self.alertView.mas_top).offset(5);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sureBtn.backgroundColor = [UIColor whiteColor];
        [self.sureBtn setTitleColor:DRGBCOLOR forState:UIControlStateNormal];
        self.sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.alertView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.alertView.mas_bottom);
            make.height.equalTo(@45);
            make.left.equalTo(self.alertView);
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
        
        self.titleLb = [[UILabel alloc]init];
        self.titleLb.textColor = UIColorFromRGB(0x666666);
        self.titleLb.font = [UIFont systemFontOfSize:18];
        self.titleLb.numberOfLines = 2;
        self.titleLb.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:self.titleLb];
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.alertView.mas_centerY).offset(-30);
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
        self.subTitleLb = [[UILabel alloc]init];
        self.subTitleLb.textColor = UIColorFromRGB(0x666666);
        self.subTitleLb.font = [UIFont systemFontOfSize:14];
        self.subTitleLb.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:self.subTitleLb];
        [self.subTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLb.mas_centerX);
            make.top.equalTo(self.titleLb.mas_bottom).offset(10);
        }];
        self.subTitleLb.text = [NSString stringWithFormat:@"文件大小（%@）",size];
        
        self.progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progress = 0;
        [self.alertView addSubview:self.progressView];
        self.progressView.progressTintColor = UIColorFromRGB(0x4DAC7D);
        self.progressView.trackTintColor = UIColorFromRGB(0xcccccc);
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.alertView.mas_left).offset(16);
            make.right.equalTo(self.alertView.mas_right).offset(-16);
            make.height.equalTo(@2);
            make.centerY.equalTo(self.alertView.mas_centerY).offset(-5);
        }];
        self.progressView.hidden = YES;
        UILabel *progressLb = [[UILabel alloc]init];
        progressLb.textColor = UIColorFromRGB(0x666666);
        progressLb.font = [UIFont systemFontOfSize:13];
        [self.alertView addSubview:progressLb];
        [progressLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.progressView.mas_centerX);
            make.top.equalTo(self.progressView.mas_bottom).offset(5);
        }];
        progressLb.text = [NSString stringWithFormat:@"%0.1f%%",self.progressView.progress];
        self.progressLb = progressLb;
        self.progressLb.hidden = YES;
        
        if (sureTitle.length > 0) {
            [self.sureBtn setTitle:sureTitle forState:UIControlStateNormal];
        }else{
            [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        self.sureBtn.tag = 2000;
        [self.sureBtn addTarget:self action:@selector(buttonEnvent:) forControlEvents:UIControlEventTouchUpInside];

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
    if ([sender.titleLabel.text isEqualToString:@"立即下载"]) {
        [sender setTitle:@"取消下载" forState:UIControlStateNormal];
        self.titleLb.text = @"正在下载请稍后";
        self.progressView.hidden = NO;
        self.progressLb.hidden = NO;
        self.subTitleLb.hidden = YES;
        if (self.resultIndex) {
            self.resultIndex(2000);
        }
    }else{
        [self dismiss];
        if (self.resultIndex) {
            self.resultIndex(1000);
        }
         [sender setTitle:@"立即下载" forState:UIControlStateNormal];
    }
}
- (void)dismiss{
    [self removeFromSuperview];
}
@end
