//
//  SMStepCounterInterface.m
//  Blinq
//
//  Created by zsk on 2017/11/20.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepCounterInterface.h"

@interface SMStepCounterInterface ()

@end

@implementation SMStepCounterInterface

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setStepCounterRightButton];

}

- (void)setStepCounterRightButton{
    
    
    UIButton *historyBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,25, 25)];
    [historyBtn setImage:[UIImage imageNamed:@"histogram"] forState:UIControlStateNormal];
    historyBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [historyBtn setContentMode:UIViewContentModeScaleAspectFill];
    [historyBtn addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *historyBtnItem = [[UIBarButtonItem alloc] initWithCustomView:historyBtn];
    
    
    UIButton *settingBtn = [[UIButton alloc]initWithFrame:CGRectMake(0 , 0,25, 25)];
    [settingBtn setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    settingBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [settingBtn setContentMode:UIViewContentModeScaleAspectFill];
    [settingBtn addTarget:self action:@selector(goSetting) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.navigationItem.rightBarButtonItems  = @[settingBtnItem,historyBtnItem];
}

@end
