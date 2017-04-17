//
//  SMContactSosSelectViewController.h
//  Blinq
//
//  Created by zsk on 16/4/11.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMContactSosSelectViewController : UITableViewController

@property(nonatomic,copy)void(^infoBlock)(NSString *name,NSData *image,NSString *phoneNum);

@end
