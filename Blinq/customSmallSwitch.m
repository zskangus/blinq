//
//  customSmallSwitch.m
//  Blinq
//
//  Created by zsk on 16/4/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "customSmallSwitch.h"

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

@interface customSmallSwitch()

// 执行动画的载体
@property (nonatomic, strong) CAShapeLayer *Knob;

@property (nonatomic, strong) CAShapeLayer *background;

@end

@implementation customSmallSwitch


- (instancetype)init{
    self = [super init];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(packupSidebar)];
    
    [self addGestureRecognizer:tapGesture];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.isOn = YES;
    
    [self.layer addSublayer:self.background];
    [self.layer addSublayer:self.Knob];
    return self;
    
}

- (CAShapeLayer *)Knob{
    if (!_Knob) {
        _Knob = [[CAShapeLayer alloc]init];
        
        // 绘制圆形\椭圆
        UIBezierPath *Knobpath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(17, 0, 21, 21)];
        
        /*
         cornerRadius: 转角半径------控制圆角弧度
         */
        
        _Knob.path = Knobpath.CGPath;
        _Knob.fillColor = RGBA_COLOR(80, 210, 194, 1.0f).CGColor;
        
    }
    return _Knob;
}

-(CAShapeLayer *)background{
    
    if (!_background) {
        _background = [[CAShapeLayer alloc]init];
        
        // 绘制圆角矩形
        UIBezierPath *bgpath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1.5, 3, 35, 15) cornerRadius:10];
        
        _background.path = bgpath.CGPath;
        _background.fillColor = RGBA_COLOR(80, 210, 194, 0.5f).CGColor;
    }
    return _background;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    self.isOn = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(packupSidebar)];
    
    [self addGestureRecognizer:tapGesture];
    
    [self.layer addSublayer:self.background];
    [self.layer addSublayer:self.Knob];
    return self;
    
}

- (void)packupSidebar{
    
    [UIView animateWithDuration:2 animations:^{
        CGRect endpoint = self.Knob.frame;
        if (self.isOn) {
            [self offColor];
            endpoint.origin.x = -17;
            
            self.isOn = NO;
            
        }else{
            [self onColor];
            endpoint.origin.x = 0;
            
            self.isOn = YES;
        }
        
        
        self.Knob.frame = endpoint;
        
        //CAShapeLayer 通过打印知道只有 坐标当并没有宽和高
        //NSLog(@"%f %f",self.Knob.frame.size.width,self.Knob.frame.size.height);
        
    }];
    
    [self.delegate clickSwitch:self withBOOL:self.isOn];
    
    NSLog(@"ifReadOnly value: %@" ,self.isOn?@"YES":@"NO");
    
}

- (void)setOn:(BOOL)on{
    
    CGRect endpoint = self.Knob.frame;
    if (on) {
        [self onColor];
        endpoint.origin.x = 0;
        
        self.isOn = YES;
        
    }else{
        [self offColor];
        endpoint.origin.x = -17;
        
        self.isOn = NO;
    }
    self.Knob.frame = endpoint;
}

- (void)onColor{
    self.Knob.fillColor = RGBA_COLOR(80, 210, 194, 1.0f).CGColor;
    self.background.fillColor = RGBA_COLOR(80, 210, 194, 0.5f).CGColor;
}

- (void)offColor{
    self.Knob.fillColor = RGBA_COLOR(190, 190, 190, 1.0f).CGColor;
    self.background.fillColor = RGBA_COLOR(29, 29, 38, 0.3f).CGColor;
}


@end
