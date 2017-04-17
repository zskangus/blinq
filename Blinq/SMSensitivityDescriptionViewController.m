//
//  SMSensitivityDescriptionViewController.m
//  Blinq
//
//  Created by zsk on 2017/4/12.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMSensitivityDescriptionViewController.h"

@interface SMSensitivityDescriptionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation SMSensitivityDescriptionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"SENSITIVITY" font:Avenir_Black Size:30 spacing:4.5 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent2:self.label1 title:@"BLINQ’S SOS MODE IS ACTIVATED BY VIBRATIONS TO THE RING ITSELF. HIGH LEVELS OF ACTIVITY HAVE BEEN KNOWN TO FALSELY TRIGGER THE RING’S ALERT." font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label2 title:@"CERTAIN ACTIVITIES SUCH AS BIKING, RUNNING AND FAST TYPING HAVE BEEN KNOW TO SET OFF FALSE ALARMS. IF YOU ARE EXPERIENCING THIS PLEASE TURN LOW SENSITIVITY MODE ON." font:Avenir_Heavy Size:10 spacing:3 color:[UIColor whiteColor]];
    
    [SKAttributeString setButtonFontContent:self.nextButton title:@"NEXT" font:Avenir_Light Size:20 spacing:3 color:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)nextButton:(id)sender {
    
    [SKUserDefaults setBool:YES forKey:@"sensitivityTurnedOn"];
//    
//    CATransition * animation = [CATransition animation];
//    
//    animation.duration = 0.3;    //  时间
//    
//    /**  type：动画类型
//     *  pageCurl       向上翻一页
//     *  pageUnCurl     向下翻一页
//     *  rippleEffect   水滴
//     *  suckEffect     收缩
//     *  cube           方块
//     *  oglFlip        上下翻转
//     */
//    //animation.type = @"pageCurl";
//    
//    /**  type：页面转换类型
//     *  kCATransitionFade       淡出
//     *  kCATransitionMoveIn     覆盖
//     *  kCATransitionReveal     底部显示
//     *  kCATransitionPush       推出
//     */
//    animation.type = kCATransitionPush;
//    
//    //PS：type 更多效果请 搜索： CATransition
//    
//    /**  subtype：出现的方向
//     *  kCATransitionFromRight       右
//     *  kCATransitionFromLeft        左
//     *  kCATransitionFromTop         上
//     *  kCATransitionFromBottom      下
//     */
//    animation.subtype = kCATransitionFromLeft;
//    
//    [self.view.window.layer addAnimation:animation forKey:nil];
//    
//    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
