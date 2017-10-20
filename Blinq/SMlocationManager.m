//
//  SMlocationManager.m
//  SK
//
//  Created by zsk on 2016/10/24.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import "SMlocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "transform.h"
#import <UIKit/UIKit.h>

@interface SMlocationManager()<CLLocationManagerDelegate>

@property(strong,nonatomic)CLLocationManager *locationManager;

@property(nonatomic,strong)CLGeocoder *geocoder;

@property(nonatomic,strong)CLLocation *location;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,strong)NSTimer *accuracyTimer;

@property(nonatomic,strong)NSMutableArray *accuracyArray;

@property(nonatomic,copy)authoriztionBlock authoriztionStatus;

@end

static NSInteger checkCount;

@implementation SMlocationManager

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        //反编译
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (NSMutableArray *)accuracyArray{
    if (!_accuracyArray) {
        _accuracyArray = [NSMutableArray array];
    }
    return _accuracyArray;
}


// 创建单利
static SMlocationManager* _defaultLocation = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLocation = [super allocWithZone:zone];
    });
    return _defaultLocation;
}
+(SMlocationManager *)sharedLocationManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultLocation = [[self alloc]init];
    });
    return _defaultLocation;
}
-(id)copyWithZone:(NSZone*)zone{
    return _defaultLocation;
}

- (CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        // 1. 实例化定位管理器
        _locationManager = [[CLLocationManager alloc] init];
        // 2. 设置代理
        _locationManager.delegate = self;
        // 3. 定位精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = kCLDistanceFilterNone; //1.0f;
        _locationManager.pausesLocationUpdatesAutomatically = NO; //NO表示一直请求定位服务
    }
    return _locationManager;
}

// 开始定位并获得位置相关信息(如国家等)
- (void)startLocationAndGetPlaceInfo:(ReturnBlock)results
{

    
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            
            [self.accuracyArray removeAllObjects];
            // 更新用户位置
            [self.locationManager startUpdatingLocation];
            [self startTheAccuracyTimer];
            
            results(YES);
            
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        // 不能定位用户的位置
        // 1.告诉用户检查网络状况
        // 2.提醒用户打开定位开关
        results(NO);
    }
}



- (void)requestAlwaysAuthorization:(authoriztionBlock)authoriztionStatus{
    
    self.authoriztionStatus = authoriztionStatus;

    if ([CLLocationManager locationServicesEnabled]){
        [self.locationManager requestAlwaysAuthorization];
    }
    
}

// 授权回调
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (self.authoriztionStatus) {
        self.authoriztionStatus(status);
    }
    NSLog(@"定位权限%d",status);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    // if the location is older than 30s ignore
    if (fabs([newLocation.timestamp timeIntervalSinceDate:[NSDate date]]) > 30)
    {
        NSLog(@"获取的经纬度过期...");
        return;
    }
    
    if (self.isReverseGeocodeLocation == NO) {
        self.returnBlock(nil,kCLLocationCoordinate2DInvalid,YES);
        return;
    }
    
    NSLog(@"位置精度：%f，%@",newLocation.horizontalAccuracy,newLocation);
    
    if (newLocation.horizontalAccuracy <= 60 && newLocation.horizontalAccuracy != -1){
        // 停止更新位置(不用定位服务，应当马上停止定位，非常耗电)
        [self stopTheAccuracyTimer];
        [self.locationManager stopUpdatingLocation];
        //[self.locationManager startUpdatingLocation];
        
        //    if (self.isReverseGeocodeLocation == NO) {
        //        CLLocationCoordinate2D locationZero;
        //        self.returnBlock(nil,locationZero,NO);
        //        return;
        //    }
        
        self.location = newLocation;
        [self reverseGeocode:self.location];
        
    } else {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        NSInteger hAccuracy = newLocation.horizontalAccuracy;
        
        NSNumber *accnum = [NSNumber numberWithInteger:hAccuracy];
        
        dic[@"location"] = newLocation;
        dic[@"accuracy"] = accnum;
        
        [self.accuracyArray addObject:dic];
        
        NSLog(@"未能达到60米精度-记录的信息%@",dic);
        
        return;
    }
}

//反地理编码：经纬度 -> 地名
- (void)reverseGeocode:(CLLocation*)loc;
{
    // 装换国际坐标为火星坐标，确保短信附带的经纬度正确
    CLLocationCoordinate2D currentUserCoordinate = kCLLocationCoordinate2DInvalid;
    
    wgs2gcj(loc.coordinate.latitude, loc.coordinate.longitude,&currentUserCoordinate.latitude,&currentUserCoordinate.longitude);
    
    NSLog(@"转换后的坐标:纬度=%f, 经度=%f", currentUserCoordinate.latitude, currentUserCoordinate.longitude);
    
    // 开始反向编码
    [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSMutableDictionary *address = [NSMutableDictionary dictionary];
        
        if (error || placemarks.count == 0) {
            
            [self startTheTimer];
            
        } else { // 编码成功（找到了具体的位置信息）
            
            checkCount = 0;
            [self.timer invalidate];
            self.timer = nil;
            
            NSLog(@"Received placemarks: %@", placemarks);
            
            // 输出查询到的所有地标信息
            for (CLPlacemark *placemark in placemarks) {
                
                NSLog(@"国家:%@-省份:%@-城市:%@-区:%@-街道:%@-号：%@--全称:%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare,placemark.name);
                
                address[@"country"] = placemark.country;
                address[@"administrativeArea"] = placemark.administrativeArea;
                address[@"locality"] = placemark.locality;
                address[@"subLocality"] = placemark.subLocality;
                address[@"thoroughfare"] = placemark.thoroughfare;
                //address[@"subThoroughfare"] = placemark.subThoroughfare;
                address[@"name"] = placemark.subThoroughfare;
                address[@"latitude"] = [NSString stringWithFormat:@"%f",currentUserCoordinate.latitude];
                address[@"longtitude"] = [NSString stringWithFormat:@"%f",currentUserCoordinate.longitude];
            }
            
            // 显示最前面的地标信息
            CLPlacemark *placemark=[placemarks firstObject];
            //NSLog(@"详细信息:%@",placemark.addressDictionary);
            
            NSArray* addrArray = placemark
            .addressDictionary[@"FormattedAddressLines"];
            
            // 将详细地址拼接成一个字符串
            NSMutableString* ssaddress = [[NSMutableString alloc] init];
            for(int i = 0 ; i < addrArray.count ; i ++)
            {
                [ssaddress appendString:@"\n"];
                [ssaddress appendString:addrArray[i]];
            }
            
            NSLog(@"地点：%@",ssaddress);
            
            address[@"FormattedAddressLines"] = ssaddress;
            
            self.returnBlock(address,currentUserCoordinate,YES);
        }
    }];
    
}

- (void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
}

- (void)startTheTimer{
    
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(againStartUpdatingLocation) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        });
    }
}


- (void)againStartUpdatingLocation{
    
    NSTimeInterval backgroundTimeRemaining =[[UIApplication sharedApplication] backgroundTimeRemaining];
    
    NSLog(@"backgroundTaskIdentifier  剩余时间:%f",backgroundTimeRemaining);
    
    
    if (checkCount < 3) {
        NSLog(@"再次尝试定位%ld",(long)checkCount);
        [self reverseGeocode:self.location];
        checkCount++;
    }else{
        checkCount = 0;
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"无法定位");
        
        CLLocationCoordinate2D locationZero;
        self.returnBlock(nil,locationZero,NO);
    }
    
}

- (void)startTheAccuracyTimer{
    if (!self.accuracyTimer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            self.accuracyTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(checkAccuracy) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_accuracyTimer forMode:NSDefaultRunLoopMode];
        });
    }
}

- (void)stopTheAccuracyTimer{
    [self.accuracyTimer invalidate];
    self.accuracyTimer = nil;
    
}

- (void)checkAccuracy{
    [self stopTheAccuracyTimer];
    [self.locationManager stopUpdatingLocation];
    
    if (self.accuracyArray.count > 0) {
        NSDictionary *minDic = self.accuracyArray[0];
        
        for (NSDictionary *dic in self.accuracyArray) {
            
            if ([dic[@"accuracy"] integerValue] > 0 && [dic[@"accuracy"] integerValue] < [minDic[@"accuracy"] integerValue]) {
                minDic = dic;
            }
            
            NSLog(@"jingdu%ld", [dic[@"accuracy"] integerValue]);
        }
        
        NSLog(@"最终：%@",minDic);
        self.location = minDic[@"location"];
        [self reverseGeocode:minDic[@"location"]];
        
    }
    
}

@end
