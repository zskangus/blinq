//
//  SMSSidebarViewController.h
//  Blinq
//
//  Created by zsk on 16/3/25.
//  Copyright © 2016年 zsk. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SMSSidebarViewController : UIViewController

// 左边菜单视图
@property(nonatomic,strong,readonly)UIViewController *leftController;

// 主要视图
@property(nonatomic,strong,readonly)UIViewController *centerController;

- (instancetype)initWithCenterController:(UIViewController *)centerController leftController:(UIViewController *)leftController;

-(void)open;

-(void)close;

@end
