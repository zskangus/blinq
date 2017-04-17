//
//  SMContactsDescriptionViewController.h
//  Blinq
//
//  Created by zsk on 2016/11/7.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMBaseViewController.h"

typedef void(^CReturnBlock)(void);

@interface SMContactsDescriptionViewController : SMBaseViewController

@property(nonatomic,strong)NSString *entrance;

@property(nonatomic,copy)CReturnBlock returnBlock;

@end
