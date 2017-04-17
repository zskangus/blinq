//
//  otaUpdateProgress.m
//  sss
//
//  Created by zsk on 16/8/5.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "otaUpdateProgress.h"
#import "SKConst.h"

@implementation otaUpdateProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    return self;
}

- (void)setProgressvalue:(CGFloat)progressvalue{
    
    _progressvalue = progressvalue;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    UIBezierPath *background = [UIBezierPath bezierPath];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    CGFloat radius = MIN(self.bounds.size.width/2, self.bounds.size.height/2);
    
    [background addArcWithCenter:center radius:(radius-1.5) startAngle:3*M_PI_2 endAngle:2*M_PI+3*M_PI_2 clockwise:YES];
    
    //[RGB_COLOR(76, 76, 76) setStroke];
    [RGB_COLORA(29, 29, 38, 0.1)setStroke];
    
    background.lineWidth = 3;
    
    [background stroke];
    
    [path addArcWithCenter:center radius:(radius-1.5) startAngle:3*M_PI_2 endAngle:self.progressvalue*2*M_PI+3*M_PI_2 clockwise:YES];
    
    if (self.progresscolor) {
        [self.progresscolor setStroke];
    }else{
        [[UIColor blueColor]setStroke];
    }
    
    path.lineWidth = 3;
    
    [path stroke];
    
}

@end
