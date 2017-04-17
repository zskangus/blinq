//
//  CustomProgress.m
//  customProgress
//
//  Created by zsk on 16/4/20.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "CustomProgress.h"

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]

@implementation CustomProgress

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.background.layer.borderColor = [UIColor clearColor].CGColor;
//        self.background.layer.borderWidth =  1; //边框
//        self.background.layer.cornerRadius = 5; //圆角
//        [self.background.layer setMasksToBounds:YES];// 遮盖
        
        [self addSubview:self.background];
        self.bar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
        self.bar.layer.borderColor = [UIColor clearColor].CGColor;

        [self addSubview:self.bar];
        
    }
    return self;
}
-(void)setProgressValue:(NSInteger)value
{
    //presentlab.text = [NSString stringWithFormat:@"%d％",present];
    self.bar.frame = CGRectMake(0, 0, self.frame.size.width/self.maxValue*value, self.frame.size.height);
    
    self.background.backgroundColor = [UIColor clearColor];
    
    UIColor *color = [[UIColor alloc]init];
    
    if (value >= 40) {
        color = RGB_COLOR(68, 219, 94);
    }else if (value<40 && value>20){
        color = RGB_COLOR(222, 222, 60);
    }else{
        color = RGB_COLOR(219, 68, 68);
    }
    
    self.bar.backgroundColor = color;
}



@end
