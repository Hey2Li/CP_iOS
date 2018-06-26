//
//  LTDownloadView.h
//  cooplaniOS
//
//  Created by Lee on 2018/6/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertResult)(NSInteger index);

@interface LTDownloadView : UIView
@property (nonatomic, copy) AlertResult resultIndex;
//下载进度条
@property (nonatomic, strong) UIProgressView *progressView;
//进度LB
@property (nonatomic, strong) UILabel *progressLb;

- (instancetype)initWithTitle:(NSString *)title sureBtn:(NSString *)sureTitle fileSize:(NSString *)size;
- (void)show;
- (void)dismiss;
@end
