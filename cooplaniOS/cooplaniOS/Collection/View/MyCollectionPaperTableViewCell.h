//
//  MyCollectionPaperTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionModel.h"

@interface MyCollectionPaperTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *paperImageView;
@property (weak, nonatomic) IBOutlet UILabel *paperName;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLb;
@property (weak, nonatomic) IBOutlet UIButton *dowloadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fileImageView;
@property (nonatomic, strong) MyCollectionModel *model;
@property (nonatomic, copy) void (^reloadData)(void);
@property (nonatomic, strong) DownloadFileModel *downloadViewModel;
@property (nonatomic, strong) MyCollectionModel *testPaperListModel;

@end
