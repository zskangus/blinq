//
//  otaUpgradeViewController.m
//  cjj
//
//  Created by zsk on 16/6/29.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "otaUpgradeViewController.h"
#import "BTServer.h"
#import "Defines.h"
#import "XMLParsing.h"
#import "otaUpdateProgress.h"
#import "otaUpdateSuccessfulViewController.h"
#import "otaUpdateFaildViewController.h"

// OTA升级状态
typedef NS_ENUM(NSInteger,OTAUpdateStatus){
    OTAUpdateing,
    OTAUpdated
};

//
typedef NS_ENUM(NSInteger,DisconnectType){
    DisconnectTypeOther,
    DisconnectTypeOTA
};

@interface otaUpgradeViewController ()
{
    int step, nextStep;
    int expectedValue;
    
    int chunkSize;
    int blockStartByte;
}

@property(nonatomic,strong)BTServer *ble;

@property(nonatomic,strong)NSMutableData *fileData;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIView *progressView;

@property(nonatomic,strong)UILabel *progressLabel;

// 外围设备
@property(nonatomic,strong)CBPeripheral *peripherals;


@property(nonatomic,strong)XMLParsing *xml;

// 进度条的四个圈
@property(nonatomic,strong)otaUpdateProgress *progress1;
@property(nonatomic,strong)otaUpdateProgress *progress2;
@property(nonatomic,strong)otaUpdateProgress *progress3;
@property(nonatomic,strong)otaUpdateProgress *progress4;

@property(nonatomic)OTAUpdateStatus otaUpdateStatus;

@property(nonatomic,strong)NSTimer *timer;

@end

static NSString *_url;

@implementation otaUpgradeViewController

@synthesize blockSize;

- (CBPeripheral *)peripherals{
    if (!_peripherals) {
        _peripherals = [self.ble getCBPeripheral];
    }
    return _peripherals;
}

- (void)viewWillAppear:(BOOL)animated{
    blockSize = 240;
    
    [SKNotificationCenter addObserver:self selector:@selector(otabluetoothConnectState:) name:bluetoothConnectState object:nil];
    
    [self downloadUpgradeFile];
    
    self.otaUpdateStatus = OTAUpdateing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUi];
    
    [self setupotaUpdateProgressUi];
    
    //[self setOtaProgressValue:0.5];
    
    self.ble = [BTServer sharedBluetooth];
    

}

- (void)setupUi{
    
    
    [SKAttributeString setLabelFontContent:self.titleLabel title:@"UPDATING JEWELRY" font:Avenir_Black Size:32 spacing:5.4 color:[UIColor whiteColor]];
    
    [SKAttributeString setLabelFontContent:self.label title:@"PLEASE LEAVE THE RING ON THE CHARGER UNTIL ALL OF THE UPDATES ARE COMPLETE." font:Avenir_Heavy Size:14 spacing:4.2 color:[UIColor whiteColor]];
}

- (void)setupotaUpdateProgressUi{
    
    CGFloat progressSize = 215;
    
    self.progress1 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize, progressSize)];
    self.progress1.progresscolor = RGB_COLOR(80, 210, 194);
    [self.progressView addSubview:self.progress1];
    
    self.progress2 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.8, progressSize*0.8)];
    self.progress2.progresscolor = RGB_COLOR(210, 80, 170);
    self.progress2.center = self.progress1.center;
    [self.progressView addSubview:self.progress2];
    
    self.progress3 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.6, progressSize*0.6)];
    self.progress3.progresscolor = RGB_COLOR(74, 144, 226);
    self.progress3.center = self.progress1.center;
    [self.progressView addSubview:self.progress3];
    
    self.progress4 = [[otaUpdateProgress alloc]initWithFrame:CGRectMake(0, 0, progressSize*0.4, progressSize*0.4)];
    self.progress4.progresscolor = RGB_COLOR(206, 139, 212);
    self.progress4.center = self.progress1.center;
    [self.progressView addSubview:self.progress4];
}

- (void)setOtaProgressValue:(double)value{
    self.progress1.progressvalue = value*1.7;
    self.progress2.progressvalue = value*1.5;
    self.progress3.progressvalue = value*1.3;
    self.progress4.progressvalue = value;
}

#pragma mark - OTA 相关

- (void)openOta{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otaUpdataValue:)name:@"otaUpdataValue"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(otaDataWriteValue)name:@"otaDataWriteValue"
                                               object:nil];
    
    [self otaNotification:YES];
    
    step = 1;
    [self doStep];
}

- (void)otabluetoothConnectState:(NSNotification*)notification{
    
    BOOL status = [[notification object][@"status"]boolValue];
    
    NSError *error = [notification object][@"error"];
    
    NSLog(@"OTA界面连接状态:%@,与戒指的连接已断开,弹出更新失败界面",status?@"YES":@"NO");
    
    if (status == NO && self.otaUpdateStatus == OTAUpdateing) {
        // 如果在升级过程中与外设断开连接
        otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
        
        [self presentViewController:failed animated:NO completion:nil];
        
        expectedValue = 0; // Reset
    }else if (status == YES && self.otaUpdateStatus == OTAUpdated){
        // 如果连接成功并且已更新完成
        
        
        [self cancelTheTimer];
        
        otaUpdateSuccessfulViewController *otaUpdateSuccessful = [[otaUpdateSuccessfulViewController alloc] initWithNibName:@"otaUpdateSuccessfulViewController" bundle:nil];
        
        [self presentViewController:otaUpdateSuccessful animated:YES completion:nil];
    
    }else if (status == NO && self.otaUpdateStatus == OTAUpdated){
        
//        if (error.code == 7) {
//
//        }
//        
//        if (error.code == 6) {
//            NSLog(@"连接超时");
//        }
    }

}

- (void)goOtaUpdateFaildViewController{
    
    [self cancelTheTimer];
    NSLog(@"升级成功重连失败");
    otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
    
    [self presentViewController:failed animated:NO completion:nil];
}

- (void)otaUpdataValue:(NSNotification*)notification{
    
    CBCharacteristic *characteristic = (CBCharacteristic*) notification.object;
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPOTA_SERV_STATUS_UUID]]) {
        char value;
        [characteristic.value getBytes:&value length:sizeof(char)];
        
        NSString *message = [self getErrorMessage:value];
        NSLog(@"-升级状态：%@",message);
        
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
                    otaUpdateFaildViewController *failed = [[otaUpdateFaildViewController alloc]initWithNibName:@"otaUpdateFaildViewController" bundle:nil];
                    [NSThread sleepForTimeInterval:3];
                    [self presentViewController:failed animated:NO completion:nil];
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
                
                NSString *string = [NSString stringWithFormat:@"%d%%",(int)(100 * progress)];
                
                NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:string];
                
                // 设置文字颜色
                [attribute addAttribute:NSForegroundColorAttributeName value:RGB_COLOR(229, 168, 25) range:NSMakeRange(0,string.length)];
                
                // 设置字体及字体大小
                [attribute addAttribute: NSFontAttributeName value:[UIFont systemFontOfSize:45]range:NSMakeRange(0,string.length-1)];
                
                dispatch_queue_t queue = dispatch_get_main_queue();
                
                dispatch_async(queue, ^{
                    [self setOtaProgressValue:progress];
                    self.progressLabel.attributedText = attribute;
                    
//                    if ([string isEqualToString:@"100%"]) {
//                        [NSThread sleepForTimeInterval:1];
//                        self.otaTitle.text = @"更新完成";
//                        self.prompt.hidden = YES;
//                        self.progress.hidden = YES;
//                        self.progressLabel.hidden = YES;
//                        self.successIcon.hidden = NO;
//                    }
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
            [SKUserDefaults setBool:NO forKey:@"whetherNeedToRremindTheUserUpdate"];
            [self otaRebootSignalDevice:suotaEndData];
            self.otaUpdateStatus = OTAUpdated;
            
            
            // 开启定时器
            NSLog(@"开启定时，如果30秒连接不上就跳转到失败界面");
            [self startTheTimer];
            
            break;
        }
        case 8: {
            // Go back to overview of devices
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        }
            
    }
}

- (void)startTheTimer{
    NSLog(@"开启定时器");
    if (!self.timer) {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:15.0f target:self selector:@selector(goOtaUpdateFaildViewController) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        });
    }
}

- (void)cancelTheTimer{
        NSLog(@"关闭定时器");
    [self.timer invalidate];
    self.timer = nil;
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

#define SERVICE_PATH @"http://www.sharemoretech.com/update/blinq/firmware/version_"

#define test @"http://www.sharemoretech.com/update/blinq/test/firmware/version_"
#define test1 @"http://www.sharemoretech.com/update/sharemorering/test/firmware/version_"

#define SSSERVICE_PATH @"http://www.sharemoretech.com/update/sharemorering/firmware/version_"

#pragma mark -检测是否需要升级-

+ (BOOL)detectionRingVersion{
    
    __block BOOL isUpdata = NO;
    
    XMLParsing *xml = [[XMLParsing alloc]init];
    
    NSString *hw_version = [[NSUserDefaults standardUserDefaults]objectForKey:@"HW_VERSION"];
    
    if (!hw_version) {
        return NO;
    }
    
    NSString* appendStr = @".xml";
    NSString* str = [hw_version stringByAppendingString:appendStr];
    NSString *urlString = [SERVICE_PATH stringByAppendingString:str];
    
    //urlString = @"http://www.sharemoretech.com/update/blinq/firmware/version_SMPRO_1.5.0.xml";
    
    NSLog(@"path=========:%@",urlString);

    [xml parsingXMLWith:urlString xmlInfo:^(NSString *version, NSString *name, NSString *url) {
        NSLog(@"--info -%@--%@--%@",version,name,url);
        
        _url = url;
        NSString * serverVersion = version;
        
        NSString * localVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"version"];
        
        serverVersion = [[serverVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        localVersion = [[localVersion componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet]] componentsJoinedByString:@""];
        
        //以"."分隔数字然后分配到不同数组
        NSArray * serverArray = [serverVersion componentsSeparatedByString:@"."];
        
        NSArray * localArray = [localVersion componentsSeparatedByString:@"."];
        
        NSLog(@"软件版本为%@，当前最新版本为%@",localVersion,version);
        
        for (int i = 0; i < serverArray.count; i++) {
            
            NSLog(@"%d--%d",[serverArray[i] intValue],[localArray[i] intValue]);
            
            //以服务器版本为基准，判断本地版本位数小于服务器版本时，直接返回（并且判断为新版本，比如服务器1.5.1 本地为1.5）
            if(i > (localArray.count -1)){
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
                isUpdata = YES;
                _url = url;
                break;
            }
            //有新版本，服务器版本对应数字大于本地
            if ( [serverArray[i] intValue] > [localArray[i] intValue]) {
                NSLog(@"需要更新，软件版本为%@，当前最新版本为%@",localVersion,version);
                isUpdata = YES;
                _url = url;
                break;
            }else if([serverArray[i] intValue] < [localArray[i] intValue]){
                isUpdata = NO;
                break;
            }
        }
    }];
    
    if (isUpdata) {
        NSLog(@"需要更新戒指固件");
    }else{
        NSLog(@"不需要更新戒指固件");
    }
    
    return isUpdata;
}

- (void)downloadUpgradeFile{
    
    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"升级文件%@----url地址%@",data,_url);
        
        self.fileData = [NSMutableData dataWithData:data];
        
        [self openOta];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
