//
//  SMMonthView.h
//  Blinq
//
//  Created by zsk on 2017/8/8.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMStepModel.h"

typedef void(^selectDay)(SMStepModel *day);

@interface SMMonthView : UIView

- (instancetype)initMonthViewWithFrame:(CGRect)frame;

- (SMStepModel*)setStepData:(NSArray *)stepData;

- (void)selectComplete:(selectDay)block;

@end
