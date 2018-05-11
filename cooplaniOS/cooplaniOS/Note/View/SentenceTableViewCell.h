//
//  SentenceTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionSentenceModel.h"

@interface SentenceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *englishSentenceLb;
@property (weak, nonatomic) IBOutlet UILabel *chineseSentenceLb;
@property (weak, nonatomic) IBOutlet UILabel *paperNameLb;
@property (nonatomic, strong) collectionSentenceModel *model;
@end
