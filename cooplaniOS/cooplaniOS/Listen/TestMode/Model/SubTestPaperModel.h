//
//  SubTestPaperModel.h
//  cooplaniOS
//
//  Created by Lee on 2018/9/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubTestPaperModel : NSObject
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * number;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * voiceUrl;
@property (nonatomic , copy) NSString              * info;
@property (nonatomic , copy) NSString              * testPaperUrl;
@property (nonatomic , copy) NSString              * lic;
@property (nonatomic , copy) NSString              * size;
@property (nonatomic , copy) NSString              * coverUrl;
@end

NS_ASSUME_NONNULL_END
