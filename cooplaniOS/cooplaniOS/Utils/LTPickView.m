//
//  LTPickView.m
//  cooplaniOS
//
//  Created by Lee on 2018/8/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LTPickView.h"
@interface LTPickView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIView *maskView;
@end
static const int pickerViewHeight = 228;
static const int toolBarHeight = 44;

@implementation LTPickView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (void)initWithPickView:(NSArray *)array InView:(UIView *)view ResultStr:(stringResultBlock)block{
    LTPickView *pickView = [[LTPickView alloc]init];
    pickView.dataArray = array;
    [pickView initWithView:view];
    pickView.block =  block;
}

- (void)initWithView:(UIView *)view{
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [view addSubview:maskView];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - pickerViewHeight, SCREEN_WIDTH, pickerViewHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    [maskView addSubview:backView];
    
    UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSure.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [btnSure setTitle:@"确定" forState:UIControlStateNormal];
    [btnSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnSure addTarget:self action:@selector(pickerViewBtnOk:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnSure];
    [btnSure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView);
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.top.equalTo(backView);
    }];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pickerViewBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btnCancel];
    [btnCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.height.equalTo(btnSure.mas_height);
        make.width.equalTo(btnSure.mas_width);
        make.top.equalTo(backView);
    }];
    
    UIPickerView *pickerView = [[UIPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [backView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backView);
        make.right.equalTo(backView);
        make.top.equalTo(btnSure.mas_bottom);
        make.bottom.equalTo(backView);
    }];
    [pickerView reloadAllComponents];
    self.maskView = maskView;
}
#pragma mark - event response
- (void)pickerViewBtnOk:(UIButton *)btn{
    [self.maskView removeFromSuperview];
}

- (void)pickerViewBtnCancel:(UIButton *)btn{
    [self.maskView removeFromSuperview];
}

#pragma mark - PickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataArray.count;
}
#pragma mark - PickerDelegate
//滑动到当行进行的操作，这里把当行的数据回调
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.block(self.dataArray[row]);
}

//要修改picker滚动里每行文字的值及相关属性，分割线等在此方法里设置
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色,这里设为隐藏
    for(UIView *singleLine in pickerView.subviews){
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    
    //设置文字的属性
    UILabel *genderLabel = [UILabel new];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = self.dataArray[row];
    genderLabel.font = [UIFont systemFontOfSize:23.0];
    genderLabel.textColor = [UIColor blackColor];
    return genderLabel;
}

@end
