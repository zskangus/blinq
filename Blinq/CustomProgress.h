//
//  CustomProgress.h
//  customProgress
//
//  Created by zsk on 16/4/20.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomProgress : UIView

@property(nonatomic, retain)UIImageView *background;
@property(nonatomic, retain)UIImageView *bar;
@property(nonatomic)float maxValue;
-(void)setProgressValue:(NSInteger)value;

@end
