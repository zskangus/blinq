//
//  SMOTAUpdateServic.m
//  SmartRing
//
//  Created by zsk on 2017/7/19.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMOTAUpdateServic.h"
#import "SKTimerManager.h"
#import "BTServer.h"
#import "SMBlinqInfo.h"
#import "Defines.h"
#import "SKConst.h"

typedef NS_ENUM(NSInteger,OTAUpdateStatus){
    OTAUpdateNormal,
    OTAUpdateing,
    OTAUpdated
};

@interface SMOTAUpdateServic()
{
    int step, nextStep;
    int expectedValue;
    int chunkSize;
    int blockStartByte;
}

@property char memoryType;
@property int memoryBank;
@property UInt16 blockSize;
@property int i2cAddress;
@property char i2cSDAAddress;
@property char i2cSCLAddress;
@property char spiMOSIAddress;
@property char spiMISOAddress;
@property char spiCSAddress;
@property char spiSCKAddress;

@property(nonatomic,strong)NSMutableData *fileData;

// 外围设备
@property(nonatomic,strong)CBPeripheral *peripherals;

@property(nonatomic,strong)updateProgress progress;

@property(nonatomic,strong)updateSuccessful successful;

@property(nonatomic,strong)updateFailure failure;

@property(nonatomic,strong)SKTimerManager *updateTimer;

@property(nonatomic)OTAUpdateStatus otaUpdateStatus;

@end

@implementation SMOTAUpdateServic

@synthesize blockSize;



- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.otaUpdateStatus = OTAUpdateNormal;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otaUpdataValue:)name:@"otaUpdataValue"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otaDataWriteValue)name:@"otaDataWriteValue"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnectStatus:) name:@"otaPagebleConnectStatus" object:nil];
        
        self.updateTimer = [[SKTimerManager alloc]init];

    }
    
    return self;
}

- (void)bleConnectStatus:(NSNotification*)status{
        
    BOOL connectState = [status.object boolValue];
    
    if (connectState && self.otaUpdateStatus == OTAUpdated) {
        self.otaUpdateStatus = OTAUpdateNormal;
        [self.updateTimer stopTimer];
        self.successful();
    }
    
    if (connectState == NO && self.otaUpdateStatus == OTAUpdateing) {
        self.otaUpdateStatus = OTAUpdateNormal;
        self.failure([self createErrorInfoWithDescription:@"连接断开" code:3]);
    }
    
    [self otaNotification:NO];
}

- (void)performOTAUpdateFromFileUrl:(NSURL *)url successful:(updateSuccessful)successful failure:(updateFailure)failure progress:(updateProgress)progress{
    
    self.successful = successful;
    
    self.failure = failure;
    
    self.progress = progress;
    
    self.fileData = [NSMutableData dataWithContentsOfURL:url];
    
    //self.fileData = [self test];
    
    if (self.fileData) {
        
        self.otaUpdateStatus = OTAUpdateing;
        
        BTServer *ble = [BTServer sharedBluetooth];
        
        self.peripherals = [ble getCBPeripheral];
        
        [self otaNotification:YES];
        
        blockSize = 240;
        expectedValue = 0;
        nextStep = 0;
        step = 1;
        [self doStep];
    }
}

- (NSMutableData*)test{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ewq" ofType:@"img"];
    
    //NSString *path= [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"qwe"];
    

    
    NSData *data=[NSData dataWithContentsOfFile:path options:0 error:NULL];
    
    return [NSMutableData  dataWithData:data];
}

- (void)otaUpdataValue:(NSNotification*)notification{
    
    CBCharacteristic *characteristic = (CBCharacteristic*) notification.object;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]]) {
        char value;
        [characteristic.value getBytes:&value length:sizeof(char)];
        
        NSString *message = [self getErrorMessage:value];
        NSLog(@"%@",message);
        
        if (expectedValue != 0) {
            // Check if value equals the expected value
            if (value == expectedValue) {
                // If so, continue with the next step
                NSLog(@"执行下一个步骤");
                step = nextStep;
                
                expectedValue = 0; // Reset
                
                [self doStep];
            } else {
                // Else display an error message
                
                dispatch_queue_t queue = dispatch_get_main_queue();
                
                dispatch_async(queue, ^{

                    // 更新错误
                    
                    self.failure([self createErrorInfoWithDescription:message code:2]);
                });
                
                expectedValue = 0; // Reset
                
            }
        }
    }
}

- (void)otaDataWriteValue{
    
    if (step) {
        [self doStep];
    }
}

- (void) doStep {
    
    switch (step) {
        case 1: {
            // 设置内存类型
            NSLog(@"设置内存类型");
            step = 0;
            expectedValue = 0x10;
            nextStep = 3;
            int MEMORY_TYPE_EXTERNAL_SPI = 0x13;
            int imageBank = 0;
            int _memDevData = MEMORY_TYPE_EXTERNAL_SPI << 24 | imageBank;
            NSData *memDevData = [NSData dataWithBytes:&_memDevData length:sizeof(int)];
            
            [self otaSetMemoryType:memDevData];
            
            break;
        }
        case 2:
            break;
        case 3: {
            // Load patch data
            
            NSLog(@"加载升级文件，%@",self.fileData);
            [self appendChecksum];
            
            // Step 3: Set patch length
            chunkSize = 20;
            blockStartByte = 0;
            
            step = 4;
            [self doStep];
            break;
        }
            
        case 4: {
            // Set patch length
            
            NSLog(@"设置长度");
            
            NSData *patchLengthData = [NSData dataWithBytes:&blockSize length:sizeof(UInt16)];
            
            step = 5;
            
            [self otaSetPatchLength:patchLengthData];
            break;
        }
        case 5: {
            // Send current block in chunks of 20 bytes
            
            NSLog(@"发送数据");
            
            step = 0;
            expectedValue = 0x02;
            nextStep = 5;
            
            int dataLength = (int) [self.fileData length];
            int chunkStartByte = 0;
            
            while (chunkStartByte < blockSize) {
                
                // Check if we have less than current block-size bytes remaining
                int bytesRemaining = blockSize - chunkStartByte;
                if (bytesRemaining < chunkSize) {
                    chunkSize = bytesRemaining;
                }
                
                //[self debug:[NSString stringWithFormat:@"Sending bytes %d to %d (%d/%d) of %d", blockStartByte + chunkStartByte, blockStartByte + chunkStartByte + chunkSize, chunkStartByte, blockSize, dataLength]];
                
                double progress = (double)(blockStartByte + chunkStartByte + chunkSize) / (double)dataLength;
                
                
                dispatch_queue_t queue = dispatch_get_main_queue();
                
                dispatch_async(queue, ^{
                    
                    self.progress(progress);
                    
                });
                
                
                // Step 4: Send next n bytes of the patch
                char bytes[chunkSize];
                [self.fileData getBytes:bytes range:NSMakeRange(blockStartByte + chunkStartByte, chunkSize)];
                NSData *byteData = [NSData dataWithBytes:&bytes length:sizeof(char)*chunkSize];
                
                // On to the chunk
                chunkStartByte += chunkSize;
                
                // Check if we are passing the current block
                if (chunkStartByte >= blockSize) {
                    // Prepare for next block
                    blockStartByte += blockSize;
                    
                    int bytesRemaining = dataLength - blockStartByte;
                    if (bytesRemaining == 0) {
                        nextStep = 6;
                        
                    } else if (bytesRemaining < blockSize) {
                        blockSize = bytesRemaining;
                        nextStep = 4; // Back to step 4, setting the patch length
                    }
                }
                
                [self otaSendUpdata:byteData];
            }
            
            break;
        }
        case 6: {
            // Send SUOTA END command
            step = 0;
            expectedValue = 0x02;
            nextStep = 7;
            int suotaEnd = 0xFE000000;
            NSData *suotaEndData = [NSData dataWithBytes:&suotaEnd length:sizeof(int)];
            [self otaEndCommand:suotaEndData];
            break;
        }
        case 7:{
            // reboot
            int suotaEnd = 0xFD000000;
            NSData *suotaEndData = [NSData dataWithBytes:&suotaEnd length:sizeof(int)];
            
            //[SKUserDefaults setBool:NO forKey:@"whetherNeedToRremindTheUserUpdate"];
            [self otaRebootSignalDevice:suotaEndData];
            self.otaUpdateStatus = OTAUpdated;
            dispatch_queue_t queue = dispatch_get_main_queue();
            
            dispatch_async(queue, ^{
                // 开启定时器
                NSLog(@"开启定时，如果30秒连接不上就跳转到失败界面");
                
                [self.updateTimer createTimerWithType:TimerType_create_open updateInterval:30 repeatCount:1 update:^(NSInteger repeatsCount) {
                    
                    self.failure([self createErrorInfoWithDescription:@"连接超时" code:1]);
                    
                }];
            });
            

            
            break;
        }
        case 8: {
            // Go back to overview of devices
            //[self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
            
    }
}

- (void)appendChecksum {
    uint8_t crc_code = 0;
    
    const char *bytes = [self.fileData bytes];
    for (int i = 0; i < [self.fileData length]; i++) {
        crc_code ^= bytes[i];
    }
    
    [self.fileData appendBytes:&crc_code length:sizeof(uint8_t)];
}

// 开启OTA
- (void)otaNotification:(BOOL)on{
    
    CBUUID *service_uuid = [self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_uuid = [CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID];
    
    CBService *service = [self findServiceFromUUID:service_uuid p:self.peripherals];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_uuid], self.peripherals.identifier);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_uuid service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_uuid],[self CBUUIDToString:service_uuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals setNotifyValue:on forCharacteristic:characteristic];
}

- (void)otaSetMemoryType:(NSData *)data{
    
    if (data == nil || data.length == 0) {
        return;
    }
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_MEM_DEV_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

- (void)otaSetPatchLength:(NSData *)data{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_PATCH_LEN_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

- (void)otaCheckForMemoryType:(NSData *)data{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_GPIO_MAP_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

- (void)otaReadValue{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_MEM_INFO_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals readValueForCharacteristic:characteristic];
    
}


- (void)otaSendUpdata:(NSData *)data{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_PATCH_DATA_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    
}

- (void)otaEndCommand:(NSData *)data{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_MEM_DEV_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

- (void)otaRebootSignalDevice:(NSData *)data{
    
    CBUUID *service_cbuuid =[self IntToCBUUID:SPOTA_SERVICE_UUID];
    CBUUID *characteristic_cbuuid = [CBUUID UUIDWithString:SPOTA_MEM_DEV_UUID];
    
    CBService *service = [self findServiceFromUUID:service_cbuuid p:self.peripherals];
    
    if (!service) {
        
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:characteristic_cbuuid service:service];
    
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:characteristic_cbuuid],[self CBUUIDToString:service_cbuuid], self.peripherals.identifier);
        return;
    }
    
    [self.peripherals writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    
}

-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}

- (CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p {
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]) return s;
    }
    //[self otabluetoothConnectState];
    return nil; //Service not found on this peripheral
}
-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    //[self otabluetoothConnectState];
    return nil; //Characteristic not found on this service
}

-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1 length: UUID1.data.length];
    [UUID2.data getBytes:b2 length: UUID2.data.length];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
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


- (NSString*)getErrorMessage:(SPOTA_STATUS_VALUES)status {
    NSString *message;
    
    switch (status) {
        case SPOTAR_SRV_STARTED:
            message = @"Valid memory device has been configured by initiator. No sleep state while in this mode";
            break;
            
        case SPOTAR_CMP_OK:
            message = @"OTA更新-SPOTA过程成功完成-SPOTA process completed successfully.";
            break;
            
        case SPOTAR_SRV_EXIT:
            message = @"OTA更新-被迫退出SPOTAR服务-Forced exit of SPOTAR service.";
            break;
            
        case SPOTAR_CRC_ERR:
            message = @"Overall Patch Data CRC failed";
            break;
            
        case SPOTAR_PATCH_LEN_ERR:
            message = @"Received patch Length not equal to PATCH_LEN characteristic value";
            break;
            
        case SPOTAR_EXT_MEM_WRITE_ERR:
            message = @"External Mem Error (Writing to external device failed)";
            break;
            
        case SPOTAR_INT_MEM_ERR:
            message = @"OTA更新-内部Mem错误(补丁没有足够的空间)-Internal Mem Error (not enough space for Patch)";
            break;
            
        case SPOTAR_INVAL_MEM_TYPE:
            message = @"OTA更新-无效的内存设备-Invalid memory device";
            break;
            
        case SPOTAR_APP_ERROR:
            message = @"OTA更新-应用程序错误-Application error";
            break;
            
            // SUOTAR application specific error codes
        case SPOTAR_IMG_STARTED:
            message = @"SPOTA started for downloading image (SUOTA application)";
            break;
            
        case SPOTAR_INVAL_IMG_BANK:
            message = @"Invalid image bank";
            break;
            
        case SPOTAR_INVAL_IMG_HDR:
            message = @"OTA更新-无效的更新文件标题-Invalid image header";
            break;
            
        case SPOTAR_INVAL_IMG_SIZE:
            message = @"OTA更新-无效的更新文件大小-Invalid image size";
            break;
            
        case SPOTAR_INVAL_PRODUCT_HDR:
            message = @"OTA更新-无效的产品标题-Invalid product header";
            break;
            
        case SPOTAR_SAME_IMG_ERR:
            message = @"OTA更新-同一个更新文件-Same Image Error";
            break;
            
        case SPOTAR_EXT_MEM_READ_ERR:
            message = @"OTA更新-未能从外部存储器读取设备-Failed to read from external memory device";
            break;
            
        default:
            message = @"OTA更新-未知的错误-Unknown error";
            break;
    }
    
    return message;
}

#pragma mark - 检查固件版本

#define SERVICE_PATH @"http://www.sharemoretech.com/update/smartjade/firmware/version_"

#define test @"http://www.sharemoretech.com/update/smartjade/test/firmware/version_"

//+ (void)checkFirmwareVersion:(void(^)(NSString *url,NSString *version))need notNeed:(void(^)(void))notNeed{
//    
//    XMLParsing *xml = [[XMLParsing alloc]init];
//    
//    NSString *hw_version = [smb deviceHardWareVersion];
//    
//    if (hw_version.length == 0 || hw_version == nil) {
//        notNeed();
//        return;
//    }
//    
//    
//    NSString *urlString = ({
//        NSString *appendStr = @".xml";
//        NSString *str = [hw_version stringByAppendingString:appendStr];
//        [SERVICE_PATH stringByAppendingString:str];
//    });
//    
//    NSLog(@"path=========:%@",urlString);
//    
//    [xml parsingXMLWith:urlString xmlInfo:^(NSString *version, NSString *name, NSString *url) {
//        NSLog(@"--info -%@--%@--%@",version,name,url);
//        
//        
//        NSString * serverVersion = version;
//        
//        NSString * localVersion =  [SMSmartRingInfo deviceFirmwareVersion];
//        
//        serverVersion = [[serverVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
//        
//        localVersion = [[localVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
//        
//        if ([serverVersion isEqualToString:localVersion]) {
//            notNeed();
//            return;
//        }
//        
//        //以"."分隔数字然后分配到不同数组
//        NSArray * serverArray = [serverVersion componentsSeparatedByString:@"."];
//        
//        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
//        
//        for (int i = 0; i < serverArray.count; i++) {
//            
//            //以服务器版本为基准，判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如服务器1.5.1 本地为1.5）
//            if(i > (localArray.count -1)){
//                NSLog(@"需要更新，当前最新版本为%@",version);
//                need(url,version);
//                break;
//            }
//            //有新版本，服务器版本对应数字大于本地
//            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
//                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
//                need(url,version);
//                break;
//            }else if([serverArray[i] intValue] < [localArray[i] intValue]){
//                notNeed();
//                break;
//            }
//        }
//    }];
//    
//}

- (NSError*)createErrorInfoWithDescription:(NSString*)description code:(NSInteger)code{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : description};
    NSError *error = [NSError errorWithDomain:@"locationError" code:code userInfo:userInfo];
    NSLog(@"%@",error);
    return error;
}


@end
