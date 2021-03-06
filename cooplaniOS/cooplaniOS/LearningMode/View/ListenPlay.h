//
//  ListenPlay.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPlayer.h"

@interface ListenPlay : UIView
@property (weak, nonatomic) IBOutlet UIButton *upSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *playSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *downSongBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIView *otherView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITableView *lyricTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherViewBottom;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic, strong) SUPlayer *player;
@property (nonatomic, copy) NSString *paperName;
@property (nonatomic, copy) void (^contentError)(void);
- (void)stopRoll;
- (void)startRoll;
@end
