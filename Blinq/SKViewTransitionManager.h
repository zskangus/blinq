//
//  SKViewTransitionManager.h
//  integration
//
//  Created by zsk on 2016/11/10.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 页面转换类型
typedef NS_ENUM(NSUInteger, TransitionType) {
    TransitionFade,      //淡出
    TransitionMoveIn,    //覆盖
    TransitionReveal,    //底部显示
    TransitionPush       //推出
};

// 页面转换类型
typedef NS_ENUM(NSUInteger, DirectionType) {
    TransitionFromRight,  //右
    TransitionFromLeft,   //左
    TransitionFromTop,    //上
    TransitionFromBottom  //下
};

@interface SKViewTransitionManager : NSObject

+ (void)presentModalViewControllerFrom:(UIViewController*)FromVc to:(UIViewController*)ToVc duration:(CFTimeInterval)duration transitionType:(TransitionType)transitionType directionType:(DirectionType)directionType;

+ (void)dismissViewController:(UIViewController*)vc duration:(CFTimeInterval)duration transitionType:(TransitionType)transitionType directionType:(DirectionType)directionType;

@end
