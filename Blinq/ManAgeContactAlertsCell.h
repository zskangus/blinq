//
//  ManAgeContactAlertsCell.h
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockButton)(NSString *str);

@interface ManAgeContactAlertsCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIButton *manButton;

@property (nonatomic, copy)BlockButton button;

- (void)handlerButtonAction:(BlockButton)block;

@end
