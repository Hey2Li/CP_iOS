//
//  ReadSAResultsHeaderView.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/13.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReadSAResultsHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *correctImageView;
@property (weak, nonatomic) IBOutlet UILabel *correctLb;
@property (weak, nonatomic) IBOutlet UILabel *paperNameLb;
@property (weak, nonatomic) IBOutlet UILabel *userTimeLb;
@property (nonatomic, copy) NSString *correctStr;
@end

NS_ASSUME_NONNULL_END
