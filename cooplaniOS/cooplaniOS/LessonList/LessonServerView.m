//
//  LessonServerView.m
//  cooplaniOS
//
//  Created by Lee on 2018/7/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LessonServerView.h"
#import <Photos/Photos.h>


@implementation LessonServerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LessonServerView class]) owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
        [self.saveQrCodeBtn.layer setCornerRadius:8];
        [self.saveQrCodeBtn.layer setMasksToBounds:YES];
    }
    return self;
}
- (IBAction)saveQrCodeClick:(id)sender {
    self.saveQrCodeBtn.userInteractionEnabled = NO;
    UIImageWriteToSavedPhotosAlbum(self.qrImg.image, self,  @selector(image:didFinishSavingWithError:contextInfo:),nil);

}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){
        SVProgressShowStuteText(@"保存失败", NO);
        self.saveQrCodeBtn.userInteractionEnabled = YES;
    }else{
        SVProgressShowStuteText(@"保存成功", YES);
        self.saveQrCodeBtn.userInteractionEnabled = NO;
    }
}
@end
