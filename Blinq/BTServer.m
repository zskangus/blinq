#import "BTServer.h"
#import "NSData+HexDump.h"
#import "CharacteristicInfo.h"
#import "AppConstant.h"
#import "Message.h"
#import "TopPlayModule.h"
#import "SmartRemindManager.h"
#import "TopPlayManager.h"
#import "SMAppTool.h"
#import "Defines.h"

#import "logMessage.h"

#import "SMMessageManager.h"

#import "SMPlayViewController.h"

#import "SMContactTool.h"

#import "SMInstructionsClass.h"

#import <UIKit/UIKit.h>


// 敲击时间
#define AC 800
// 等待时间
#define SC 700
// 次数（值为敲击次数减1）
#define HARDLEVEL 6

#define percentage 0.85

@interface BTServer()<CBCentralManagerDelegate, CBPeripheralDelegate>

// 中心设备管理者
@property(nonatomic,strong)CBCentralManager *centralManager;

// -----------保存扫描到的外围设备及读写特征值

// 外围设备
@property(nonatomic,strong)CBPeripheral *peripherals;

// 写的特征值
@property(nonatomic,strong)CBCharacteristic *writeCharacteristic;

// 读的特征值
@property(nonatomic,strong)CBCharacteristic *readCharacteristic;

// 电量特征值
@property(nonatomic,strong)CBCharacteristic *batteryCharacteristic;

@property(nonatomic,strong)CBCharacteristic *batteryStateCharacteristic;

@property(nonatomic,strong)CBCharacteristic *ringFirmwareCharacteristic;

// 搜索时找到的外设数组
@property(nonatomic,strong)NSMutableArray *peripheralArray;
//
@property(nonatomic,strong)NSMutableArray *peripheralRss;

//定时器
@property(nonatomic,strong)NSTimer *timer;

//连接状态定时
@property(nonatomic,strong)NSTimer *bleConnectStateTimer;

@property(nonatomic,strong)SMPlayViewController *changColor;

@property(nonatomic,assign)NSInteger connectTime;

@property(nonatomic,strong)NSTimer *checkBatteryTimer;

@property(nonatomic,strong)NSMutableArray *clickEventTimeList;


@end

static BOOL isConnect = NO;

static BOOL isUserDisConnect = NO;



CBCentralManagerState SMCBCentralManagerStatePowered;

@implementation BTServer

- (SMSOSCheckAlgorithmService *)sosCheckService{
    if (!_sosCheckService) {
        _sosCheckService = [SMSOSCheckAlgorithmService sharedSMSOSCheckAlgorithmService];
    }
    return _sosCheckService;
}

- (NSMutableArray *)clickEventTimeList{
    if (!_clickEventTimeList) {
        _clickEventTimeList = [NSMutableArray array];
    }
    return _clickEventTimeList;
}

- (NSMutableArray *)peripheralArray{
    if (!_peripheralArray) {
        _peripheralArray = [NSMutableArray array];
    }
    return _peripheralArray;
}

- (SMPlayViewController *)changColor{
    if (!_changColor) {
        _changColor = [[SMPlayViewController alloc]init];
    }
    return _changColor;
}

// 创建单利
static BTServer* _defaultBTServer = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultBTServer = [super allocWithZone:zone];
    });
    return _defaultBTServer;
}
+(BTServer *)sharedBluetooth{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultBTServer = [[self alloc]init];
    });
    return _defaultBTServer;
}
-(id)copyWithZone:(NSZone*)zone{
    return _defaultBTServer;
}

// 懒加载
-(CBCentralManager *)centralManager{
    
    /*
     设置主设备的代理,CBCentralManagerDelegate
     必须实现的：
     - (void)centralManagerDidUpdateState:(CBCentralManager *)central;//主设备状态改变调用的代理方法，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
     其他选择实现的代理中比较重要的：
     - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //发现外设
     - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功
     - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败
     - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设链接
     */
    
    if (!_centralManager) {
        // 创建中心设备管理者，用来管理中心设备
        //_centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
        
        //
        
        //dispatch_queue_t centralQueue = dispatch_queue_create("com.myco.cm", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_t centralQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 //蓝牙power没打开时alert提示框
                                 [NSNumber numberWithBool:YES],CBCentralManagerOptionShowPowerAlertKey,
                                 //重设centralManager恢复的IdentifierKey
                                 @"myCentralManagerIdentifier",CBCentralManagerOptionRestoreIdentifierKey,
                                 nil];
        
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue options:options];
        
        // options:
        // NSString *const CBCentralManagerOptionShowPowerAlertKey;用该参量出事中央管理器时，当蓝牙开关未打开时会弹出警告框。
        // NSString *const CBCentralManagerOptionRestoreIdentifierKey;该参量包含一个指定中央管理器的uid
        
    }
    return _centralManager;
}


-(void)initBLE
{
    [self centralManager];
    NSLog(@"初始化中心设备管理者");
}

- (void)removeBinding{
    
    isUserDisConnect = NO;
    
    SMPlayViewController *play = [[SMPlayViewController alloc]init];
    [play stopFlashAndVib];
    
    // 停止扫描
    [self.timer invalidate];
    
    [self.centralManager stopScan];
    
    [self.peripheralArray removeAllObjects];
    
    if (self.peripherals) {
        // 断开连接
        [self.centralManager cancelPeripheralConnection:self.peripherals];
        
        NSLog(@"解除绑定--");
    }
    
    
    self.peripherals = nil;
    
    // 清除应用通知界面的配置信息
    //[SMAppTool deleteTableData];
    
    //[SMContactTool deleteContactData];
    
    //[sosContactTool deleteContactData];
    
    // 清除所有用NSUserDefaults储存的信息
    //    NSLog(@"解除绑定-清空除日志以外的所有数据");
    //    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //
    //    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    //    for (id  key in dic) {
    //        [userDefaults removeObjectForKey:key];
    //    }
    //    [userDefaults synchronize];
    
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    
    NSArray *array =@[@"isHaveBeenBound",@"LastPeriphrealIdentifierConnectedKey",@"sensitivityTurnedOn",@"sosVcTurnedOn",@"socialTurnedOn",@"notification_contactVcTurnedOn",@"main_contactVcTurnedOn",@"firstName",@"lastName",@"isUploadSuccessful",@"sendMessagePower",@"locationPower"];
    
    NSMutableArray *array1 = [NSMutableArray array];
    NSString *string = [[NSString alloc]init];
    
    for (id  key in dic) {
        string = key;
        [array1 addObject:string];
    }
    
    NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",array];
    //过滤数组
    NSArray * reslutFilteredArray = [array1 filteredArrayUsingPredicate:filterPredicate];
    NSLog(@"Reslut Filtered Array = %@",reslutFilteredArray);
    
    for (NSString *string in reslutFilteredArray) {
        NSLog(@"要删除的%@",string);
        [userDefaults removeObjectForKey:string];
    }
    
    [userDefaults synchronize];
}

- (CBPeripheral*)getCBPeripheral{
    return self.peripherals;
}


#pragma mark - CBCentralManagerDelegate
// 只要中心管理者初始化，就会触发此代理方法
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
        {
            SMCBCentralManagerStatePowered = CBCentralManagerStatePoweredOff;
            
            BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
            
            if (isBinding) {
                [self setBleConnectStatus:NO error:nil];
            }
            
        }
            break;
        case CBCentralManagerStatePoweredOn:
            // 蓝牙打开
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            SMCBCentralManagerStatePowered = CBCentralManagerStatePoweredOn;

            BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
            
            if (isUserDisConnect == NO) {

                if (isBinding) {
                    
                    [self reConnectPeripheral];
                
                }
            }
            
            [SKNotificationCenter postNotificationName:@"CBCentralManagerStatePoweredOn" object:nil];
            
            break;
        default:
            break;
    }
}



- (void)scan
{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithBool:NO],CBCentralManagerScanOptionAllowDuplicatesKey,
                          [NSNumber numberWithBool:YES],CBCentralManagerRestoredStateScanOptionsKey,nil];
    
    [self.centralManager scanForPeripheralsWithServices:nil options:dic];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(connectRing:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    });
    
    //[CBUUID UUIDWithString:kCBAdvDataServceUUID]@[[CBUUID UUIDWithString:@"Apple Notification Center"]]
    
    NSLog(@"开始扫描");
}

// 断开连接
- (void)disConnect{
    
    isUserDisConnect = YES;
    
    if (self.peripherals) {
        // 停止扫描
        [self.centralManager stopScan];
        // 断开连接
        [self.centralManager cancelPeripheralConnection:self.peripherals];
        
        [self.peripheralArray removeAllObjects];
        
        [self setBleConnectStatus:NO error:nil];
        
        NSLog(@"主动断开连接");
        }
}

// 手动连接
- (void)ConnectPeripheral{
    [self reConnectPeripheral];
}


- (void)reConnectPeripheral{
    
    if (self.peripherals) {
        // 停止扫描
        [self.centralManager stopScan];
        // 断开连接
        [self.centralManager cancelPeripheralConnection:self.peripherals];
    }
    
    // 取出上次连接成功后，存的 peripheral identifier
    NSString *lastPeripheralIdentifierConnected = [[NSUserDefaults standardUserDefaults] objectForKey:LastPeriphrealIdentifierConnectedKey];
    
    // 查看上次存入的 identifier 还能否找到 peripheral
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:lastPeripheralIdentifierConnected];
    NSArray *peripherals = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]];

    for (CBPeripheral *peripheral in peripherals) {
        if ([peripheral.identifier.UUIDString isEqualToString:lastPeripheralIdentifierConnected]) {
            
            self.peripherals = peripheral;
            
            [self.centralManager connectPeripheral:peripheral options:nil];
            return;
        }
        
    }
    
    

}


/**
 *  发现外设备后调用的方法
 */
- (void)centralManager:(CBCentralManager *)central // 中心管理者
 didDiscoverPeripheral:(CBPeripheral *)peripheral //外设
     advertisementData:(NSDictionary *)advertisementData //外设携带的数据
                  RSSI:(NSNumber *)RSSI // 外设发出的蓝牙信号强度
{
    NSLog(@"发现设备");
    
    NSData *string = advertisementData[@"kCBAdvDataManufacturerData"];
    NSString *result = [[NSString alloc] initWithData:string  encoding:NSUTF8StringEncoding];
    if ([result containsString:@"SM"]) {// && (ABS(RSSI.integerValue) > 30)
        NSLog(@"是小木公司的戒指");
        NSLog(@"%s, line = %d, per外设为 = %@, data = %@, rssi信号强度 = %@", __FUNCTION__, __LINE__, peripheral, advertisementData, RSSI);
        
        NSDictionary *dic = @{
                            @"peripheral":peripheral,
                            @"RSSI":RSSI
                              };

        [self.peripheralArray addObject:dic];
    }
    
//    // 判断设备号是否扫描到
//    if ([peripheral.name isEqualToString:@"SHAREMORE RING"] && (ABS(RSSI.integerValue) > 40)) {
//        
//        /*
//         一个主设备最多能连7个外设，每个外设最多只能给一个主设备连接,连接成功，失败，断开会进入各自的代理方法
//         - (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral;//连接外设成功
//         - (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//外设连接失败
//         - (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;//断开外设
//         */
//        // 保存外设,否则方法结束就销毁
//        self.peripherals = peripheral;
//        
//        // 保存外设标识符
//        [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:LastPeriphrealIdentifierConnectedKey];
//        
//        // 链接外设
//        [self.centralManager connectPeripheral:self.peripherals options:nil];
//        
//        /*
//         options中可以设置一些连接设备的初始属性键值如下
//         //对应NSNumber的bool值，设置当外设连接后是否弹出一个警告
//         NSString *const CBConnectPeripheralOptionNotifyOnConnectionKey;
//         //对应NSNumber的bool值，设置当外设断开连接后是否弹出一个警告
//         NSString *const CBConnectPeripheralOptionNotifyOnDisconnectionKey;
//         //对应NSNumber的bool值，设置当外设暂停连接后是否弹出一个警告
//         NSString *const CBConnectPeripheralOptionNotifyOnNotificationKey;
//         */
//        
//    }
}

- (void)connectRing:(NSTimer*)timer{
    
    NSInteger rssi = UINT16_MAX;
    
    NSLog(@"---charMAx %ld",(long)rssi);
    
    if (self.peripheralArray.count>0) {
        for (NSDictionary *dic in self.peripheralArray) {
            NSLog(@"dic:%@-rssi%@",dic[@"peripheral"],dic[@"RSSI"]);
            NSString * rssiString = dic[@"RSSI"];
            CBPeripheral *peripheral = dic[@"peripheral"];
            
            if (rssi > ABS(rssiString.integerValue)) {
                rssi = ABS(rssiString.integerValue);
                // 保存外设,否则方法结束就销毁
                self.peripherals = peripheral;
            }
        }
        
        if (self.peripherals) {
            NSLog(@"信号最小的是%@--信号%ld",self.peripherals,(long)rssi);
            // 保存外设标识符
            [[NSUserDefaults standardUserDefaults] setObject:self.peripherals.identifier.UUIDString forKey:LastPeriphrealIdentifierConnectedKey];
            // 链接外设
            [self.centralManager connectPeripheral:self.peripherals options:nil];
        }
        
    }else{
        [self scan];
    }
    

}

// 外设连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    // 停止扫描
    [self.centralManager stopScan];
    
    // 释放定时器
    [self.timer invalidate];
    
    // 主线程执行：
    // 停止定时器
    [self.bleConnectStateTimer invalidate];
    self.bleConnectStateTimer = nil;
    
    isUserDisConnect = NO;
    
    //NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    NSLog(@">>>连接到名称为（%@）的设备-成功--%@",peripheral.name,peripheral);
    //连接成功之后,可以进行服务和特征的发现
    //连接成功后获取外设的服务
    //设置外设的代理
    [self.peripherals setDelegate:self];
    
    //发现外设的服务，参数传nil代表不对服务进行过滤
    //这里会触发外设代理方法-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error；
    [self.peripherals discoverServices:nil];
    
    NSUInteger serviceUUIDIndex = [peripheral.services indexOfObjectPassingTest:^BOOL(CBService *obj, NSUInteger index, BOOL *stop) {
        return [obj.UUID isEqual:kCBAdvDataServceUUID];
    }];
    
    if (serviceUUIDIndex == NSNotFound) {
        [peripheral discoverServices:@[kCBAdvDataServceUUID]];
        NSLog(@"discoverServices执行");
    }
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    self.connectTime = [dat timeIntervalSince1970];
}

// 外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%s, line = %d, %@=连接失败", __FUNCTION__, __LINE__, peripheral.name);
    
    BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
    
    if (isUserDisConnect == NO && peripheral != nil) {
        
        if (isBinding) {
            
            [self.centralManager connectPeripheral:peripheral options:nil];
            
            
            
        }
    }
    
    [self setBleConnectStatus:NO error:nil];
}

#pragma mark - 断开连接
// 断开连接(丢失连接) 程序断开会自动调用
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    
    BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
    
    NSLog(@"蓝牙连接已断开,错误：%@",error);
    
    if (isUserDisConnect == NO) {// 如果不是用户自己解除就执行重连
        
        NSLog(@"重新连接外设");
        
        if (isBinding) {
            
            [self.centralManager connectPeripheral:peripheral options:nil];
    
        }
        
    }else{
        self.peripherals = nil;
    }
    [self setBleConnectStatus:NO error:error];
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary *)state {
    
    NSArray *peripherals = state[CBCentralManagerRestoredStatePeripheralsKey];
    
    NSLog(@"恢复状态-%@",peripherals);
    
        BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
    
    for (CBPeripheral *peripheral in peripherals) {
        if (isBinding) {
            
            [self.centralManager connectPeripheral:peripheral options:nil];
            
        }
    }
}

- (BOOL)isNeedReConnect{

    // 取出上次连接成功后，存的 peripheral identifier
    NSString *lastPeripheralIdentifierConnected = [[NSUserDefaults standardUserDefaults] objectForKey:LastPeriphrealIdentifierConnectedKey];
    
    CBUUID *service_uuid = [self IntToCBUUID:SPOTA_SERVICE_UUID];
    NSUUID *UUID1 = [[NSUUID alloc] initWithUUIDString:kCBAdvDataServceUUID];
    CBUUID *CBUUID1 = [CBUUID UUIDWithNSUUID:UUID1];
    
    NSArray *array = [[NSArray alloc]initWithObjects:CBUUID1,service_uuid, nil];
    NSArray *peripherals =[self.centralManager retrieveConnectedPeripheralsWithServices:array];
    
    for (CBPeripheral *peripheral in peripherals) {
        if ([peripheral.identifier.UUIDString isEqualToString:lastPeripheralIdentifierConnected]) {
            return YES;
        }

    }
    
    return NO;
   
}

// 从蓝牙列表里查已配对过的外设
- (void)retrieveConnectedPeripherals{
    
    // 取出上次连接成功后，存的 peripheral identifier
    NSString *lastPeripheralIdentifierConnected = [[NSUserDefaults standardUserDefaults] objectForKey:LastPeriphrealIdentifierConnectedKey];
    // 如果没有，则不做任何操作，说明需要用户点击开始扫描的按钮，进行手动搜索
    if (lastPeripheralIdentifierConnected == nil || lastPeripheralIdentifierConnected.length == 0) {
        NSLog(@"未连接过外设，启动扫描");
        [self scan];
        return;
    }
    
    
    
    // 查看上次存入的 identifier 还能否找到 peripheral
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:lastPeripheralIdentifierConnected];
    NSArray *peripherals = [self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
//    if (peripherals.count>0) {
//        
//        // 如果能找到则开始建立连接
//        CBPeripheral *peripheral = [peripherals firstObject];
//        
//        // 注意保留 Peripheral 的引用
//        self.peripherals = peripheral;
//        NSLog(@"连接已绑定过的外设:%@",peripheral);
//        
//        [self.centralManager connectPeripheral:peripheral options:nil];
//        
//        [logMessage generateTheLogRecords:[NSString stringWithFormat:@"连接已绑定过的外设:%@",peripheral]];
//    }else {
//        
//        NSLog(@"fail");
//    }
    
    CBUUID *service_uuid = [self IntToCBUUID:SPOTA_SERVICE_UUID];
    NSUUID *UUID1 = [[NSUUID alloc] initWithUUIDString:kCBAdvDataServceUUID];
    CBUUID *CBUUID1 = [CBUUID UUIDWithNSUUID:UUID1];
    
    NSArray *array = [[NSArray alloc]initWithObjects:CBUUID1,service_uuid, nil];
    NSArray *peripherals2 =[self.centralManager retrieveConnectedPeripheralsWithServices:array];
    
        if (peripherals2.count>0) {
    
            // 如果能找到则开始建立连接
            CBPeripheral *peripheral = [peripherals firstObject];
            
            if ([peripheral.identifier.UUIDString isEqualToString:lastPeripheralIdentifierConnected]) {
                // 注意保留 Peripheral 的引用
                self.peripherals = peripheral;
                NSLog(@"连接已绑定过的外设:%@",peripheral);
                
                [self.centralManager connectPeripheral:peripheral options:nil];
                
            }

        }else {
            [self scan];
            NSLog(@"fail");
        }
}


-(CBUUID *) IntToCBUUID:(UInt16)UUID {
    UInt16 cz = [self swap:UUID];
    NSData *cdz = [[NSData alloc] initWithBytes:(char *)&cz length:2];
    CBUUID *cuz = [CBUUID UUIDWithData:cdz];
    return cuz;
}
- (UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}
#pragma mark - 外设的代理方法
// 发现外设的服务(service后调用的方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"%s, line = %d", __FUNCTION__, __LINE__);
    // 判断是否成功
    if (error)
    {
        NSLog(@">>>发现的服务%@ 错误%@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services) {
        // 发现服务后，再让设备去发现每个服务里的特征 并触发
        //- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
        
        // 寻找指定的特征--不能按指定寻找，不然会影响到OTA功能
        //if ([service.UUID isEqual:[CBUUID UUIDWithString:kCBAdvDataServceUUID]]) {
        //}
        
        [peripheral discoverCharacteristics:nil forService:service];
        
        NSLog(@"service.UUID = %@", service.UUID);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"找到的特征--%@",characteristic.UUID);
        
        //读数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMDATAREAD]]) {
            
            // 找读的特征值
            self.readCharacteristic = characteristic;
            
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
        }
        
        //写数据
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMDATAWRITE]]) {
            
            self.writeCharacteristic = characteristic;
            NSLog(@"找到写的特征--%@",characteristic.UUID);
            
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            
            [self didConnectSuccess];
            
        }
        
        
        //电量状态（充电还是未充电）
        if([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERYSTATUS]]){
            //读取
            [peripheral readValueForCharacteristic:characteristic];
            
            self.batteryStateCharacteristic = characteristic;
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        //电量信息(服务UUID:180F,特征UUID:2A19)
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERYLEVEL]]) {
            //读取
            [peripheral readValueForCharacteristic:characteristic];
            
            //电量的特征值
            self.batteryCharacteristic = characteristic;
            
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        
        //固件的硬件版本
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERY_SMARTDEVICE_HW_REVISION_UUID]]) {
            //读取
            [peripheral readValueForCharacteristic:characteristic];
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        
        //固件的软件版本
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERY_SMARTDEVICE_SW_REVISION_UUID]]) {
            //读取
            [peripheral readValueForCharacteristic:characteristic];
            
            self.ringFirmwareCharacteristic = characteristic;
            
            //监听特征
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
        }
        
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSLog(@"9.didUpdateValueForCharacteristic中正确读出数据");
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]]) {
        //ota
        [[NSNotificationCenter defaultCenter] postNotificationName:@"otaUpdataValue" object:characteristic];
    }
    
    //读
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMDATAREAD]]) {
        NSData *data = characteristic.value;
        Message *msg = [[Message alloc]init];
        FirmwareInfoModule* mFirwareInfo = [[FirmwareInfoModule alloc]init];
        SmartRemindManager *smartRemindManager = [[SmartRemindManager alloc]init];
        TopPlayManager *topManager = [[TopPlayManager alloc]init];
        msg = [msg parseMessage:data];
        switch (msg.head.mod_id) {
            case ModID_deviceInfo:
            {
                [Utils printfData2Byte:msg.body and:@"固件信息解析："];
                
                if([msg.body length] >= 3){
                    Byte *buff = (Byte *)[msg.body bytes];
                    if (buff != nil && buff[0] == 0xE0) {
                        
                        // 敲击数
                        int tapCount = buff[2];
                        NSLog(@"%d",tapCount);
                        
                        //Notification click Event
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"onUserClickEvent" object:[NSNumber numberWithInt:tapCount]];
                    }
                }
                
                [self sosTriggerToMonitor:msg.body successful:^{
                    BOOL emergencyPower = [SKUserDefaults boolForKey:@"emergencyPower"];
                    
                    NSLog(@"符合SOS求救触发条件，是否发送求救信息%@",emergencyPower?@"YES":@"NO");
                    
                    if (emergencyPower == YES) {
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_SOS" object:nil];
                        
                        [SMInstructionsClass notificationAlertModType:MODTYPE_TAG_INDICATIONS indication:INDICATION_TYPE_NORMAL_V_TWO_SEC];
                        NSLog(@"SOS Happend!!!");
                    }
                }];
                
               //__block BOOL isConnect;
                
                [mFirwareInfo parse:msg.body strBlock:^(NSString *string) {
                    if ([string isEqualToString:AUTH_ERRCODEFAILED]) {
                        
                        NSLog(@"认证失败，重新认证");
                        
                        isConnect = NO;
                    
                        //请求绑定
                        [mFirwareInfo bindDevice];
                        //写数据--确定绑定
                        [mFirwareInfo confrimBindState];
                        
                        //写数据--请求验证
                        [mFirwareInfo takeAutho];
                        
                    }else{
                        NSLog(@"认证成功");
                        
                        NSLog(@"认证成功的线程%@",[NSThread currentThread]);
                        
                        [SKNotificationCenter postNotificationName:@"connectNotification" object:nil];
                        
                        isConnect = YES;
                        
                        [self setBleConnectStatus:YES error:nil];
                        
                        BOOL isBinding = [SKUserDefaults boolForKey:@"isBinding"];
                        
                        
                        if (isBinding == NO) {
                            //存储数据
                            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                            [userDefaults setBool:YES forKey:@"isBinding"];
                            [userDefaults setBool:YES forKey:@"isFirstTime"];
                            
                            
                            if ([userDefaults boolForKey:@"isHaveBeenBound"] == NO) {
                                [userDefaults setBool:YES forKey:@"sendMessagePower"];
                                [userDefaults setBool:YES forKey:@"locationPower"];
                            }
                            
                            // 记录程序是否被绑定过
                            [userDefaults setBool:YES forKey:@"isHaveBeenBound"];
                            //强制保存到硬盘中
                            [userDefaults synchronize];
                            
                            [SMInstructionsClass notificationAlertModType:MODTYPE_TAG_INDICATIONS indication:INDICATION_TYPE_NORMAL_VF_ALL];
                            
                            // 开始配置戒指的应用通知信息
                            [SMMessageManager setupNotificationInfo];
                            
                            [SMMessageManager requestAllData];
                            
                            
                        }else{
                            
                            // 开始配置戒指的应用通知信息
                            //[SMMessageManager setupNotificationInfo];
                            
                            // 取得 在链接成功页面里获取到的APP配置信息
                            NSMutableArray *apps = [NSMutableArray arrayWithArray:[SMAppTool Apps]];
                            
                            if (apps.count == 0) {
                                [SMMessageManager againSetupNotificationInfo];
                            }
                            
                            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                            
                            dispatch_async(queue, ^{
                                
                                
                            [SMMessageManager requestAllData];
                                
                            });
                        
                        }
                        
                    };
                    
                    dispatch_queue_t queue = dispatch_get_main_queue();
                    dispatch_async(queue, ^{
                        NSNumber *boolNum = [NSNumber numberWithBool:isConnect];
                        
                        // 通知连接页面跳转到连接成功或者连接失败界面
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"connectStateNotifcation" object:boolNum];
                    });
                    
                }];
                
                break;
            }
            case ModID_Play:
                [Utils printfData2Byte:msg.body and:@"玩一玩解析:"];
                [topManager parseMsgDataForTopPlay:msg.body];
                
                break;
            case ModID_Remind:
                NSLog(@"开始解析智能提醒模块的信息");
                [Utils printfData2Byte:msg.body and:@"提醒解析:"];
                [smartRemindManager parseMsgDataForSmartRemind:msg.body];
                break;
            default:
                break;
        }
        
    }
    // 电池电量
    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:@"2A19"]]){
        
        NSData *batteryData = characteristic.value;
        Byte *batteryByte = (Byte *)[batteryData bytes];
        if (batteryData != nil) {
            
            NSInteger batteryInt = batteryByte[0];
                        
            NSLog(@"电池电量%ld",batteryInt);
            
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval nowtime=[date timeIntervalSince1970];
            
            NSUserDefaults *batteryDefaults = [NSUserDefaults standardUserDefaults];
            
            NSInteger old = [[SKUserDefaults objectForKey:@"defaultBattery"] integerValue];
            
            // 连接上一分钟之内
            if (nowtime - self.connectTime <= 60) {
                
                [self checkConnectTheBattery:batteryInt returns:^(BOOL isThrough, NSInteger batterylevel) {
                    
                    NSLog(@"电量：%ld，是否通过检查%@",(long)batterylevel,isThrough?@"YES":@"NO");
                    
                    
                    if (isThrough) {// 如果电量检查通过
                        // 替换旧电量
                        NSNumber *num = [NSNumber numberWithInteger:batterylevel];
                        [batteryDefaults setObject:num forKey:@"defaultBattery"];
                        
                    }
                    
                    
                    [self batteryNotificationFunc:old newBattery:batterylevel isThrough:isThrough];
                    
                    
                }];
                
            }else{// 连上一分钟以后
                [self checkTheBattery:batteryInt returns:^(BOOL isThrough, NSInteger batterylevel) {
                    
                    if (isThrough) {// 如果电量确定不需要检查了
                        [self batteryNotificationFunc:old newBattery:batteryInt isThrough:YES];
                    }
                    
                }];
            }
            
        }else{
            [self readBatteryLevel];
        }
    }
    
    // 电量状态-检查是否在充电
    if ([[characteristic UUID] isEqual:[CBUUID UUIDWithString:SMBATTERYSTATUS]]){
        
        NSString * battery ;
        const void *state = [characteristic.value bytes];
        if (!state) {
            battery = [NSString stringWithFormat:@"%02x", 0];
            NSLog(@"电池状态异常");
            [self performSelector:@selector(readBatteryState) withObject:nil afterDelay:1];
        }else{
            battery = [NSString stringWithFormat:@"%02x", *(Byte*)state];
        }

        
        BOOL batteryStatus = [battery integerValue];
        
        NSLog(@"电池是否在充电%@",batteryStatus?@"YES":@"NO");
        
        NSUserDefaults *batteryDefaults = [NSUserDefaults standardUserDefaults];
        [batteryDefaults setBool:batteryStatus forKey:@"batteryStatus"];
        [batteryDefaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SKNotificationCenter postNotificationName:@"batteryChargerStateChanged" object:nil];
        });
    }
    
    
    if (error){
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    //version
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERY_SMARTDEVICE_HW_REVISION_UUID]]) {
        NSData *data = characteristic.value;
        if (data!=nil) {
            NSString* currentVersion = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"HW_VERSION"];
        }
    }
    
    //固件的软件版本
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SMBATTERY_SMARTDEVICE_SW_REVISION_UUID]]) {
        
        NSData *data = characteristic.value;
        if (data) {
            NSString* currentVersion = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
            NSLog(@"固件版本为%@",currentVersion);
            [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:@"version"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SKNotificationCenter postNotificationName:@"firmwareVersion" object:nil];
            });
        }else{
            [self readFirmwareVersion];
        }
    }
}

#pragma mark - sos紧急求救触发判断方法
- (void)sosTriggerToMonitor:(NSData*)data successful:(void(^)(void))block{
    
    Byte *buff = (Byte *)[data bytes];
    if (buff != nil && buff[0] == 0xE0) {
        
        // 敲击数
        int tapCount = buff[2];
        NSLog(@"%d",tapCount);
        
        if ([self.sosCheckService putEvent:tapCount]) {
            block();
        };
//        
//        
//        dispatch_queue_t queue = dispatch_get_main_queue();
//        dispatch_async(queue, ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"takingPictures" object:nil];
//        });
//        
//        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//        uint64_t recordTime = (uint64_t)([dat timeIntervalSince1970]*1000);
//        
//        //[self LogKnockDateAndData:msg.body];
//        
//        NSLog(@"触发的时间%lld",recordTime);
//        
//        NSNumber *num = [NSNumber numberWithLongLong:recordTime];
//        
//        NSDictionary *dictionary = @{@"tapCount":[NSNumber numberWithInt:tapCount],
//                                     @"recordTime":num};
//        
//        [self.clickEventTimeList insertObject:dictionary atIndex:0];
//        
//        if ([self SOSCheck:0 count:HARDLEVEL]) {
//            
//            block();
//            
//        }
    }
}

- (bool) SOSCheck:(int)index count:(int)count{
    NSLog(@"Index: %d, count: %d", index, count);
    
    if (count == 0) {
        
        int doubleTap = 0;
        
        for (NSDictionary *dic in self.clickEventTimeList) {
            int tap = [dic[@"tapCount"]intValue];
            if (tap == 2) {
                doubleTap++;
            }
        }
        
        if ((doubleTap / self.clickEventTimeList.count) > percentage) {
            NSLog(@"双击次双");
            
            //            [self.clickEventTimeList removeAllObjects];
            //
            //            return true;
        }
        
        [self.clickEventTimeList removeAllObjects];
        
        return true;
        
    }
    
    if (count > 0 && index < self.clickEventTimeList.count) {
        
        //uint64_t currClickTime = [self.clickEventTimeList[index]longLongValue];
        
        uint64_t currClickTime = [self.clickEventTimeList[index][@"recordTime"]longLongValue];
        
        NSLog(@"Index: %d, Time: %lld", index, currClickTime);
        
        index++;
        while (index < self.clickEventTimeList.count) {
            uint64_t temp = [self.clickEventTimeList[index][@"recordTime"]longLongValue];
            NSLog(@"Index: %d, Time: %lld", index, temp);
            
            if (currClickTime - temp > AC) {
                currClickTime = [self.clickEventTimeList[index-1][@"recordTime"]longLongValue];
                NSLog(@"First Click out of AC");
                break;
            }
            index++;
        }
        
        if (index >= self.clickEventTimeList.count) {
            NSLog(@"All Click has invalid.");
            return false;
        }
        if (currClickTime - [self.clickEventTimeList[index][@"recordTime"]longLongValue] >= SC
            && currClickTime - [self.clickEventTimeList[index][@"recordTime"]longLongValue] <= SC + AC) {
            NSLog(@"The Current Check OK.");
            
            NSLog(@"通过的时间点%lld",[self.clickEventTimeList[index][@"recordTime"]longLongValue]);
            
            return [self SOSCheck:index count:count -1];
            
        } else {
            NSLog(@"The Current Check Failed, Clear next List.");
            [self.clickEventTimeList removeObjectsInRange:NSMakeRange(index, self.clickEventTimeList.count - index)];
            return false;
        }
    }
    
    NSLog(@"We Check all click time of list.");
    return false;
}

#pragma mark - 电池电量的检查方法
static NSInteger checkCount;

- (void)checkConnectTheBattery:(NSInteger)batteryLevel returns:(void(^)(BOOL isThrough,NSInteger batterylevel))block{
    
    if (batteryLevel < 10 && checkCount < 10 ) {
        
        if (!self.checkBatteryTimer) {
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                self.checkBatteryTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(readBatteryLevel) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:self.checkBatteryTimer forMode:NSDefaultRunLoopMode];
            });
        }
        
        NSLog(@"读取电量%ld--次数%ld",batteryLevel,checkCount);
        block(NO,batteryLevel);
    }else{
        checkCount = 0;
        [self.checkBatteryTimer invalidate];
        self.checkBatteryTimer = nil;
        block(YES,batteryLevel);
    }
}

- (void)checkTheBattery:(NSInteger)batteryLevel returns:(void(^)(BOOL isThrough,NSInteger batterylevel))block{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *num = [userDefaults objectForKey:@"defaultBattery"];
    NSInteger defaultBattery = [num integerValue];
    
    if (ABS(batteryLevel - defaultBattery) > 10  && checkCount < 12 ) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(readBatteryLevel) withObject:nil afterDelay:5.0f];
        });
        
        NSLog(@"读取电量%ld--次数%ld",batteryLevel,checkCount);
        block(NO,batteryLevel);
    }else{
        checkCount = 0;
        [userDefaults setObject:[NSNumber numberWithInteger:batteryLevel] forKey:@"defaultBattery"];
        [userDefaults synchronize];
        NSLog(@"获取电量完成，并更新defaultBattert电量值");
        block(YES,batteryLevel);
    }
}

- (void)batteryNotificationFunc:(NSInteger)oldBattery newBattery:(NSInteger)newBattery isThrough:(BOOL)isThrough{
    
    NSArray *array = @[@20,@10,@0];
    
    BOOL chargerState = [SKUserDefaults boolForKey:@"batteryStatus"];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        
        if (isThrough == NO) {// 如果电量没通过还在检查状态--通知电量loading
            [SKUserDefaults setBool:isThrough forKey:@"batteryCheckState"];
            [SKNotificationCenter postNotificationName:@"batteryNotification" object:@"loading"];
            [SKNotificationCenter postNotificationName:@"batteryLevelUpdated" object:nil];
            return;
        }else{
            [SKUserDefaults setBool:isThrough forKey:@"batteryCheckState"];
        }
        
        NSLog(@"isThrough:%@",isThrough?@"YES":@"NO");
        
        // 判断是否冲点完成及是否低电量符合则发送相应通知
        if (chargerState) {// 在充电状态
            
            // 判断电量是否充满
            if (oldBattery < 100 && newBattery >= 100) {
                //TODO notf full showAlertController battery_charge_completion
                [SKNotificationCenter postNotificationName:@"batteryNotification" object:@"full"];
            }
            
        }else{// 不是充电状态
            
            // 判断是否进行低电量
            for (NSNumber *num in array) {
                if (oldBattery > [num integerValue] && newBattery <= [num integerValue]) {
                    [SKNotificationCenter postNotificationName:@"batteryNotification" object:@"low"];
                    break;
                }
            }
        }
        
        // 通知电电池状态更新
        [SKNotificationCenter postNotificationName:@"batteryLevelUpdated" object:nil];
        
    });
    
}

- (void)setBleConnectStatus:(BOOL)status error:(NSError*)error{

    NSUserDefaults *connectStatus = [NSUserDefaults standardUserDefaults];
    [connectStatus setBool:status forKey:@"connectStatus"];
    
    if (status == NO) {
        [connectStatus setBool:NO forKey:@"batteryCheckState"];
    }
    
    
    [connectStatus synchronize];
    
    
    
    NSLog(@"连接状态保存的BOOL值%@",status?@"YES":@"NO");
    
    if (error == nil) {
        error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:999 userInfo:nil];
    }
    
    NSDictionary *dic = @{@"status":[NSNumber numberWithBool:status],
                          @"error":error};
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [SKNotificationCenter postNotificationName:bluetoothConnectState object:dic];
    });
}

- (void)batteryState:(NSInteger)oldbattery newBattery:(NSInteger)newBattry flag:(BOOL)flag{
    
    NSArray *array = @[@20,@10,@0];
    
    
    BOOL chargerState = [SKUserDefaults boolForKey:@"batteryStatus"];

    //TODO notf ui with flag
    
    NSNumber *numBool = [NSNumber numberWithBool:flag];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        [SKNotificationCenter postNotificationName:@"batteryLevelUpdated" object:numBool];
    });

    
    if (chargerState) {
        if (oldbattery < 100 && newBattry >= 100) {
            //TODO notf full showAlertController battery_charge_completion
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                [SKNotificationCenter postNotificationName:@"batteryNotification" object:@"full"];
            });

        }
        
    }else{
        for (NSNumber *num in array) {
            if (oldbattery > [num integerValue] && newBattry <= [num integerValue]) {
                //TODO notf low battery_low
                dispatch_queue_t queue = dispatch_get_main_queue();
                dispatch_async(queue, ^{
                    [SKNotificationCenter postNotificationName:@"batteryNotification" object:@"low"];
                });

                break;
            }
        }
    
    
    }
    


}

- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"retrive connected peripheral %@",peripherals);
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    for (CBPeripheral *peripheral in peripherals) {
        NSDictionary* connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
        [self.centralManager connectPeripheral:peripheral options:connectOptions];
    }
}

//8.在didDiscoverCharacteristicsForService找到特征后 对这个特征进行读取操作


-(void)didConnectSuccess{
    
    FirmwareInfoModule* mFirmwareInfo = [[FirmwareInfoModule alloc]init];

    BOOL isBinding = [[NSUserDefaults standardUserDefaults] boolForKey:@"isBinding"];
    
    if (isBinding) {
        NSLog(@"已绑定过-请求验证");
        
        //写数据--请求验证
        [mFirmwareInfo takeAutho];
        
    }else{
        NSLog(@"未绑定过-请求绑定");
        //请求绑定
        [mFirmwareInfo bindDevice];
        //写数据--确定绑定
        [mFirmwareInfo confrimBindState];
        
        //写数据--请求验证
        [mFirmwareInfo takeAutho];
        
    }
}

- (void)readBatteryLevel{
        if (self.peripherals && self.batteryCharacteristic) {
            [self.peripherals readValueForCharacteristic:self.batteryCharacteristic];
            checkCount++;
        }
}

- (void)readBatteryState{
    
    if (self.peripherals && self.batteryStateCharacteristic) {
        [self.peripherals readValueForCharacteristic:self.batteryStateCharacteristic];

    }
}

- (void)readFirmwareVersion{
    if (self.peripherals && self.ringFirmwareCharacteristic) {
        [self.peripherals readValueForCharacteristic:self.ringFirmwareCharacteristic];
        
    }
}

#pragma mark 写数据 -- 测试
-(void)writedidWriteData:(NSData *)data{
    
    
    if (self.peripherals && self.writeCharacteristic) {
        //执行完写入操作后会回调 didWriteValueForCharacteristic
        [self.peripherals writeValue:data // 写入的数据
                   forCharacteristic:self.writeCharacteristic // 写给哪个特征
                                type:CBCharacteristicWriteWithoutResponse];// 通过此响应记录是否成功写入
        
        NSLog(@"发送的数据%@",data);
    }
    
    // 注意 如果出现写入错误的情况(Writing is not permitted)有可能是type的类型不正确
    // CBCharacteristicWriteWithoutResponse
    // CBCharacteristicWriteWithResponse
}

#pragma mark 写数据后回调
- (void)peripheral:(CBPeripheral *)peripheral
didWriteValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    if (error) {
        NSLog(@"错误的写作特征值: %@",
              [error localizedDescription]);
        return;
    }
    NSLog(@"写入%@成功",characteristic);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"otaDataWriteValue" object:nil];
}



@end
