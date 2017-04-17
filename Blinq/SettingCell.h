//
//  SettingCell.h
//  Blinq
//
//  Created by zsk on 16/4/22.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customSwitch.h"

@interface SettingCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *settingCellLabel;

@property (weak, nonatomic) IBOutlet customSwitch *customSwitch;


@end
