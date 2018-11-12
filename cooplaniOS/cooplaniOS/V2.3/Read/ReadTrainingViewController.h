//
//  ReadTrainingViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListenTeacherTableViewCell.h"
#import "PracticeTestTableViewCell.h"
#import "HomeListenCell.h"
#import "VideoViewController.h"
#import "MyCollectionViewController.h"
#import "ReadSectionA/ReadSectionAViewController.h"
#import "ReadSectionB/ReadSectionBViewController.h"
#import "ReadSectionC/ReadSectionCViewController.h"
#import "ReadTest/ReadTestViewController.h"
#import "ReadTest/ReadTestListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReadTrainingViewController : UIViewController
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSDictionary *categoryDict;
- (void)loadData;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
