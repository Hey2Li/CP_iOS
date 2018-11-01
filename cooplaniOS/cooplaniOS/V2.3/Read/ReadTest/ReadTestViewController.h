//
//  ReadTestViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/10/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ReadSectionA,
    ReadSectionB,
    ReadSectionC,
    ReadSectionCPassageTwo,
} ReadSection;

@interface ReadTestViewController : UIViewController
@property (nonatomic, assign) ReadSection ReadSetionEnum;
@property (nonatomic, strong) NSNumber *testPaperNumber;
@end

NS_ASSUME_NONNULL_END
