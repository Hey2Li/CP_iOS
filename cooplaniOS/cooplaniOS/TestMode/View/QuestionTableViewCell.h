//
//  QuestionTableViewCell.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TopTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *sectionLb;
@property (weak, nonatomic) IBOutlet UILabel *directionsLb;

@end
