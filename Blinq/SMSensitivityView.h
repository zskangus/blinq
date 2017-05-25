//
//  SMSensitivityView.h
//  integration
//
//  Created by zsk on 2017/5/24.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sensitivityLevelBlock)(NSInteger sensitivityLevel);

@interface SMSensitivityView : UIView

- (instancetype)createWithFrame:(CGRect)frame sensitivity:(sensitivityLevelBlock)sensitivity;

- (void)setCount:(NSInteger)countLevel;

@end
