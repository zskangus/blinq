//
//  PeriperalInfo.h
//  DarkBlue
//
//  Created by chenee on 14-3-26.
//  Copyright (c) 2014年 chenee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface PeriperalInfo : NSObject<NSCoding>
@property (strong,nonatomic)CBPeripheral* peripheral;

@property (strong,nonatomic)NSString* uuid;
@property (strong,nonatomic)NSString* name;
@property (strong,nonatomic)NSString* state;

//advertisement
@property (strong,nonatomic)NSString* channel;
@property (strong,nonatomic)NSString* isConnectable;
@property (strong,nonatomic)NSString* localName;

@property (strong,nonatomic)NSString* manufactureData;
@property (strong,nonatomic)NSString* serviceUUIDS;

@property (strong,nonatomic)NSString* nsuuid;

//rssi
@property (strong,nonatomic)NSNumber *RSSI;

-(void)encodeWithCoder:(NSCoder *)aCoder;

-(id)initWithCoder:(NSCoder *)aDecoder;
@end
