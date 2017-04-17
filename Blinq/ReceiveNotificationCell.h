//
//  ReceiveNotificationCell.h
//  Blinq
//
//  Created by zsk on 16/3/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "customSmallSwitch.h"
typedef void(^receiveBlockButton)(void);

@interface ReceiveNotificationCell : UITableViewCell

@property (nonatomic, copy)receiveBlockButton button;

- (void)handlerButtonAction:(receiveBlockButton)block;

@property (weak, nonatomic) IBOutlet customSmallSwitch *customSmallSwitch;

@end
