//
//  TranslationTrainingViewController.m
//  cooplaniOS
//
//  Created by Lee on 2018/11/9.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "TranslationTrainingViewController.h"

@interface TranslationTrainingViewController ()

@end

@implementation TranslationTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"翻译学习";
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)loadData{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"翻译·讲解课";
    }else if (section == 1){
        return @"翻译·知识锦囊";
    }
    else {
        return @"翻译·范文精选";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ListenTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListenTeacherTableViewCell class])];
        cell.selectionStyle = NO;
        return cell;
    }else{
        PracticeTestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PracticeTestTableViewCell class])];
        cell.learnImg.image = [UIImage imageNamed:@"开发中"];
        cell.selectionStyle = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        [MobClick endEvent:@"listeningpage_course"];
        VideoViewController *vc = [[VideoViewController alloc]init];
        vc.title = @"翻译·讲解课";
        vc.lessonType = @"40";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
