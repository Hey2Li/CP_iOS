//
//  ListenPaperViewController.h
//  cooplaniOS
//
//  Created by Lee on 2018/4/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListenPaperViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *upSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *playSongBtn;
@property (weak, nonatomic) IBOutlet UIButton *downSongBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIView *otherView;

@end
