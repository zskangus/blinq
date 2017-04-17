 //
//  SmartRemindConfig.m
//  cjj
//
//  Created by 聂晶 on 15/11/25.
//  Copyright © 2015年 cjj. All rights reserved.
//

#import "SmartRemindConfig.h"



@implementation SmartRemindConfig

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.Power forKey:@"Power"];
    [aCoder encodeBool:self.SedentaryPower forKey:@"SedentaryPower"];
    [aCoder encodeBool:self.EmergencyPower forKey:@"EmergencyPower"];
    [aCoder encodeBool:self.AntilostPower forKey:@"AntilostPower"];
    [aCoder encodeBool:self.NotificationPower forKey:@"NotificationPower"];
    [aCoder encodeInteger:self.NtfAmount forKey:@"NtfAmount"];
    [aCoder encodeInteger:self.RemindCount forKey:@"RemindCount"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]) {
        self.Power = [aDecoder decodeBoolForKey:@"Power"];
        self.SedentaryPower = [aDecoder decodeBoolForKey:@"SedentaryPower"];
        self.EmergencyPower = [aDecoder decodeBoolForKey:@"EmergencyPower"];
        self.AntilostPower = [aDecoder decodeBoolForKey:@"AntilostPower"];
        self.NotificationPower = [aDecoder decodeBoolForKey:@"NotificationPower"];
        self.NtfAmount = [aDecoder decodeIntegerForKey:@"NtfAmount"];
        self.RemindCount = [aDecoder decodeIntegerForKey:@"RemindCount"];
    }
    return self;
}

+(SmartRemindConfig *)build:(UInt64) config{
    SmartRemindConfig *Config = [[SmartRemindConfig alloc]init];
    
    Config.Power =((config & SmartRemind_MASK_POWER) == SmartRemind_MASK_POWER);
    
    Config.NotificationPower = ((config & SmartRemind_MASK_NOTIFICATIONPOWER) == SmartRemind_MASK_NOTIFICATIONPOWER);
    Config.AntilostPower = ((config & SmartRemind_MASK_ANTILOSTPOWER) == SmartRemind_MASK_ANTILOSTPOWER);
    Config.EmergencyPower = ((config & SmartRemind_MASK_EMERGENCYPOWER) == SmartRemind_MASK_EMERGENCYPOWER);
    Config.SedentaryPower = ((config & SmartRemind_MASK_SEDENTARYPOWER) == SmartRemind_MASK_SEDENTARYPOWER);
    
    Config.NtfAmount = (int) ((config & SmartRemind_MASK_NFTAMOUNT) >> 48);
    Config.RemindCount = (int) (config & SmartRemind_MASK_REMINDCOUNT);
    
    
    //--------------
    Config.DisVib = ((config & SmartRemind_MASK_DISVIB) == SmartRemind_MASK_DISVIB);
    Config.DisFlash = ((config & SmartRemind_MASK_DISFLASH) == SmartRemind_MASK_DISFLASH);
    
    
    return Config;
}

-(UInt64) convert {
    UInt64 res = 0;
    //UInt64 res = SmartRemind_MASK_ANTILOSTPOWER;
    if (self.Power)
        res |= SmartRemind_MASK_POWER;
    if (self.NotificationPower)
        res |= SmartRemind_MASK_NOTIFICATIONPOWER;
    if (self.AntilostPower)
        res |= SmartRemind_MASK_ANTILOSTPOWER;
    if (self.EmergencyPower)
        res |= SmartRemind_MASK_EMERGENCYPOWER;
    if (self.SedentaryPower)
        res |= SmartRemind_MASK_SEDENTARYPOWER;
    if (self.DisVib)
        res |= SmartRemind_MASK_DISVIB;
    if (self.DisFlash)
        res |= SmartRemind_MASK_DISFLASH;
    
    if (self.NtfAmount) {
        res |= (self.NtfAmount & SmartRemind_MASK_NFTAMOUNT);
    }
    if (self.RemindCount) {
        res |= (self.RemindCount & SmartRemind_MASK_REMINDCOUNT);
    }
    NSLog(@"---------res%llu",res);
    
    return res;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@,%p>{Power:%d,NotificationPower:%d,AntilostPower:%d,EmergencyPower:%d,SedentaryPower:%d,NtfAmount:%d,RemindCount:%d}",[self class], self, self.Power,self.NotificationPower,self.AntilostPower,self.EmergencyPower,self.SedentaryPower,self.NtfAmount,self.RemindCount];
}

@end
