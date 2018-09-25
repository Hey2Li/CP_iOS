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
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"PaperSerialNumber":@"Properties.PaperSerialNumber",
             @"PaperFullName":@"Properties.PaperFullName",
             @"PaperAudioName":@"Properties.PaperAudioName",
             @"TimeLimit":@"Properties.TimeLimit",
             @"Version":@"Properties.Version"
             };
}
@end

@implementation PartsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Sections":@"SectionsModel"};
}
@end

@implementation SectionsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Passages":@"PassageModel"};
}
@end

@implementation PassageModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Questions":@"QuestionsModel"};
}
@end

@implementation QuestionsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Options":@"OptionsModel",@"options":@"OptionsModel"};
}
@end

@implementation OptionsModel

@end
