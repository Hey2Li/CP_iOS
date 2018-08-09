//
//  WordWebViewTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneLessonModel.h"
#import "DownloadVideoModel.h"

@interface WordWebViewTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^scrollSize)(CGFloat x);
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) OneLessonModel *model;
@property (nonatomic, strong) DownloadVideoModel *localVideoModel;
@end