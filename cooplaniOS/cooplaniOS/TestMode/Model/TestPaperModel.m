//
//  TestPaperModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "TestPaperModel.h"

@implementation TestPaperModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Parts":@"PartsModel"};
}
@end

@implementation PartsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Sections":@"SectionsModel"};
}
@end

@implementation SectionsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Passage":@"PassageModel"};
}
@end

@implementation PassageModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Questions":@"QuestionsModel"};
}
@end

@implementation QuestionsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Options":@"OptionsModel"};
}
@end

@implementation OptionsModel

@end
