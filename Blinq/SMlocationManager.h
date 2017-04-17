//
//  SMlocationManager.h
//  SK
//
//  Created by zsk on 2016/10/24.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SMlocationManager : NSObject

typedef void(^ReturnBlock)(BOOL results);

//定位成功回调
typedef void(^ReturnLocation)(NSMutableDictionary *address,CLLocationCoordinate2D currentUserCoordinate,BOOL isSuccessful);

// 单例
+ (SMlocationManager *)sharedLocationManager;

/// 开始定位并获得位置相关信息
- (void)startLocationAndGetPlaceInfo:(ReturnBlock)results;

@property(nonatomic,copy)ReturnLocation  returnBlock;

@property(nonatomic,assign)BOOL isReverseGeocodeLocation;

- (void)startUpdatingLocation;



@end
