//
//  SMViewSelectButton.h
//  Blinq
//
//  Created by zsk on 2017/8/2.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,btnType){
    btn_steps,
    btn_calories,
    btn_distance,
    btn_normal
};

typedef void(^clickEventBlock)(UIColor *pathBackColor,UIColor *pathFillColor,UIColor *pointColor,NSString *valueString,NSString *targetValueString,NSString *remainderValueString);

@interface SMViewSelectButton : UIView

- (instancetype)createWithFrame:(CGRect)frame type:(btnType)type event:(clickEventBlock)event;

- (void)cancelClick;

- (void)setProgressWith:(double)steps targetSteps:(double)targetSteps animation:(BOOL)animation;

- (void)setUserInteraction:(BOOL)boolValue;


@end
