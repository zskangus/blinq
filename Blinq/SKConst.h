//
//  SKConst.h
//
//
//  Created by zsk on 16/7/28.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
        [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
        __LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

#define NSLogRect(rect) NSLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define NSLogSize(size) NSLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height)
#define NSLogPoint(point) NSLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y)

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGB_COLORA(R, G, B, A) [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define RGB_FromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define GCD_GLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCD_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define SKUserDefaults [NSUserDefaults standardUserDefaults]

#define SKNotificationCenter [NSNotificationCenter defaultCenter]

//获取temp
#define SKPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define SKPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define SKPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

extern NSInteger screenWidth;
extern NSInteger screenHeight;

// 通知
extern NSString *bluetoothConnectState;

extern NSString *popupSidebar;

extern NSString *packupSidebar;

extern NSString *beginEditing;

// NSUserDefaults
extern NSString *isBinding;

extern NSString *LastPeriphrealIdentifierConnectedKey;

extern NSString *battery;

extern NSString *batteryStatus;

extern NSString *version;

//typedef NS_ENUM(NSInteger,action){
//    
//    FromSosSwitch = 0,
//    FromAddButton,
//    FromNormal
//};
//
//action popVcAction = FromNormal;
