//
//  SKViewTransitionManager.m
//  integration
//
//  Created by zsk on 2016/11/10.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SKViewTransitionManager.h"

@implementation SKViewTransitionManager

+ (void)presentModalViewControllerFrom:(UIViewController *)FromVc to:(UIViewController *)ToVc duration:(CFTimeInterval)duration transitionType:(TransitionType)transitionType directionType:(DirectionType)directionType{
    
    CATransition * animation = [CATransition animation];
    
    animation.duration = duration;//  时间
    
    animation.type = [self getTransitionType:transitionType];
    
    animation.subtype = [self getDirectionType:directionType];
    
    [FromVc.view.window.layer addAnimation:animation forKey:nil];
    
    [FromVc presentViewController:ToVc animated:NO completion:nil];
}

+ (void)dismissViewController:(UIViewController *)vc duration:(CFTimeInterval)duration transitionType:(TransitionType)transitionType directionType:(DirectionType)directionType{
    
    CATransition * animation = [CATransition animation];
    
    animation.duration = duration;//  时间
    
    animation.type = [self getTransitionType:transitionType];
    
    animation.subtype = [self getDirectionType:directionType];
    
    [vc.view.window.layer addAnimation:animation forKey:nil];
    
    [vc dismissViewControllerAnimated:NO completion:nil];

}

+ (NSString*)getTransitionType:(TransitionType)transitionType{
    switch (transitionType) {
        case TransitionFade:    return kCATransitionFade;       break;
        case TransitionMoveIn:  return kCATruncationMiddle;     break;
        case TransitionReveal:  return kCATransitionReveal;     break;
        case TransitionPush:    return kCATransitionPush;       break;
        default:
            break;
    }
}

+ (NSString*)getDirectionType:(DirectionType)directionType{
    switch (directionType) {
        case TransitionFromTop:     return kCATransitionFromTop;        break;
        case TransitionFromBottom:  return kCATransitionFromBottom;     break;
        case TransitionFromLeft:    return kCATransitionFromLeft;       break;
        case TransitionFromRight:   return kCATransitionFromRight;      break;
        default:
            break;
    }
}

@end
