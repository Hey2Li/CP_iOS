//
//  DictionaryTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionWordModel.h"

@interface DictionaryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *wordLb;
@property (weak, nonatomic) IBOutlet UILabel *explainLb;
@property (weak, nonatomic) IBOutlet UIButton *addDictionaryBtn;
@property (weak, nonatomic) IBOutlet UIButton *sayEnBtn;
@property (weak, nonatomic) IBOutlet UIButton *sayAmBtn;
@property (weak, nonatomic) IBOutlet UILabel *enLb;
@property (weak, nonatomic) IBOutlet UILabel *amLb;
@property (weak, nonatomic) IBOutlet UILabel *allExplainLb;
@property (nonatomic, strong) NSDictionary *model;
@end
