//
//  UITextField+Extension.h
//  Blinq
//
//  Created by zsk on 2017/9/12.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

- (NSRange)selectedCursorRange;
- (void) setSelectedRange:(NSRange) range;

@end
