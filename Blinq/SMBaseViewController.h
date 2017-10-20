//
//  SMBaseViewController.h
//  Blinq
//
//  Created by zsk on 16/8/3.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMBlinqInfo.h"
#import "SKConst.h"
#import "SKAttributeString.h"
#import "SKViewTransitionManager.h"

@interface SMBaseViewController : UIViewController

- (void)setupNavigationTitle:(NSString *)string isHiddenBar:(BOOL)hidden;

- (void)viewTransform;

- (void)autoDetectionRingVersion;

- (void)autoCheckAppVersion;

- (CGRect)getScreenSize;

- (BOOL)isBlankString:(NSString *)string;

- (void)showAlertController:(NSString*)string type:(NSString*)type;

- (NSMutableAttributedString*)setAlertControllerWithStrring:(NSString*)string fontSize:(NSInteger)size spacing:(NSInteger)spacing;

- (NSDateComponents*)getCurrentDate;

@end
