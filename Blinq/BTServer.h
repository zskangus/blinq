//
//
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "FirmwareInfoModule.h"
#import "Utils.h"
#import "SMSOSCheckAlgorithmService.h"


@class BTServer;

@protocol BTServerDelegate<NSObject>

- (void)bleConnectStatus:(BTServer*)BTServer;

- (void)bleBatteryState:(BTServer*)BTServer;

@end



@interface BTServer : NSObject

@property (nonatomic,assign)NSUInteger batteryStatus;
@property (nonatomic,assign)NSInteger batteryLevel;

@property(nonatomic,weak)id<BTServerDelegate>delegate;

@property(nonatomic,strong)SMSOSCheckAlgorithmService *sosCheckService;


// 单例方法
+(BTServer*)sharedBluetooth;

// 蓝牙初始化方法
-(void)initBLE;

- (void)removeBinding;

// 断开连接
- (void)disConnect;

// 手动连接
- (void)ConnectPeripheral;

- (void)reConnectPeripheral;

- (BOOL)isNeedReConnect;

- (void)scan;

// 写数据
-(void)writedidWriteData:(NSData *)data;

- (CBPeripheral*)getCBPeripheral;

- (BOOL)isBatteryLevelLoading;

- (void)readBatteryLevel;
- (void)readBatteryState;
- (void)readFirmwareVersion;

- (void)connectDeviceFromBluetoothlList;

@end
