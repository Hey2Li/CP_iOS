//
//  HomeListenCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperModel.h"

@interface HomeListenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (nonatomic, strong) PaperModel *Model;
@end
