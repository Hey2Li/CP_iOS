//
//  ReadSCModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/10/16.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "ReadSCModel.h"

@implementation ReadSCModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Questions":@"QuestionsItem"};
}
@end

@implementation QuestionsItem
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Options":@"OptionsItem"};
}
@end

@implementation OptionsItem
@end

