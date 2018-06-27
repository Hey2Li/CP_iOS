//
//  PaperDetailViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaperModel.h"

@interface PaperDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *paperDetailLb;
@property (weak, nonatomic) IBOutlet UIButton *downloadPaperBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionPaperBtn;
@property (weak, nonatomic) IBOutlet UIImageView *collectionImageView;
@property (nonatomic, strong) PaperModel *onePaperModel;
@property (nonatomic, copy) NSString *nextTitle;
@end
