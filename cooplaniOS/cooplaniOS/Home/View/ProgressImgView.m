//
//  ProgressImgView.m
//  cooplaniOS
//
//  Created by Lee on 2018/6/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "ProgressImgView.h"

@interface ProgressImgView ()
@property (nonatomic, assign) CGFloat progress;

@property(strong,nonatomic)UIBezierPath *path;
@property(strong,nonatomic)CAShapeLayer *shapeLayer;
@property(strong,nonatomic)CAShapeLayer *bgLayer;
@end

@implementation ProgressImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
        
        _bgLayer = [CAShapeLayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.fillColor = [UIColor clearColor].CGColor;
        _bgLayer.lineWidth = 2.f;
        _bgLayer.strokeColor = [UIColor grayColor].CGColor;
        _bgLayer.strokeStart = 0.f;
        _bgLayer.strokeEnd = 1.f;
        _bgLayer.path = _path.CGPath;
        [self.layer addSublayer:_bgLayer];
        
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.lineWidth = 2.f;
        _shapeLayer.lineCap = kCALineCapRound;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.strokeStart = 0.f;
        _shapeLayer.strokeEnd = 0.f;
        
        
        _shapeLayer.path = _path.CGPath;
        [self.layer addSublayer:_shapeLayer];
        
    }
    return self;
}

@synthesize value = _value;
-(void)setValue:(CGFloat)value{
    _value = value;
    _shapeLayer.strokeEnd = value;
}
-(CGFloat)value{
    return _value;
}

@synthesize lineColr = _lineColr;
-(void)setLineColr:(UIColor *)lineColr{
    _lineColr = lineColr;
    _shapeLayer.strokeColor = lineColr.CGColor;
}
-(UIColor*)lineColr{
    return _lineColr;
}

@synthesize lineWidth = _lineWidth;
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    _shapeLayer.lineWidth = lineWidth;
    _bgLayer.lineWidth = lineWidth;
}
-(CGFloat)lineWidth{
    return _lineWidth;
}

@end
