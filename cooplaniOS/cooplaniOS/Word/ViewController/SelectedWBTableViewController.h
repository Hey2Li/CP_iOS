//
//  SelectedWBTableViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/8/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^wordBookNameAndNum)(NSString *wordbookName, NSString *wordbookNum);
@interface SelectedWBTableViewController : UITableViewController
@property (nonatomic, copy) wordBookNameAndNum wordBookNameAndNumBlock;
@end
