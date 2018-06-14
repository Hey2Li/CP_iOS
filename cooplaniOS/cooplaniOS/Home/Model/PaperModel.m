//
//  PaperModel.m
//  cooplaniOS
//
//  Created by Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "PaperModel.h"

@implementation PaperModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.number forKey:@"number"];
    [aCoder encodeObject:self.coverUrl forKey:@"coverUrl"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.pictureUrl forKey:@"pictureUrl"];
    [aCoder encodeObject:self.info forKey:@"info"];
    [aCoder encodeObject:self.voiceUrl forKey:@"voiceUrl"];
    [aCoder encodeObject:self.collection forKey:@"collection"];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.coverUrl = [aDecoder decodeObjectForKey:@"coverUrl"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.pictureUrl = [aDecoder decodeObjectForKey:@"pictureUrl"];
        self.info = [aDecoder decodeObjectForKey:@"info"];
        self.voiceUrl = [aDecoder decodeObjectForKey:@"voiceUrl"];
        self.collection = [aDecoder decodeObjectForKey:@"collection"];
    }
    return self;
}

@end
