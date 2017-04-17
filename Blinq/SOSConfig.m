//
//  SOSConfig.m
//  cjj
//
//  Created by 聂晶 on 16/1/20.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import "SOSConfig.h"
#import "NSUserDefaultsHelper.h"

@implementation SOSConfig

-(void) encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeBool:self.Power forKey:@"Power"];
    [aCoder encodeInteger:self.Operate forKey:@"Operate"];
    [aCoder encodeInteger:self.Color forKey:@"Color"];
    [aCoder encodeInteger:self.RemindCount forKey:@"RemindCount"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]) {
        self.Power = [aDecoder decodeBoolForKey:@"Power"];
        self.Operate = [aDecoder decodeIntegerForKey:@"Operate"];
        self.Color = [aDecoder decodeIntegerForKey:@"Color"];
        self.RemindCount = [aDecoder decodeIntegerForKey:@"RemindCount"];
    }
    return self;
}


+(SOSConfig *)sosBuild:(int)config{
    SOSConfig *Config = [[SOSConfig alloc]init];
    Config.Power = ((config & SOS_MASK_POWER) == SOS_MASK_POWER);
    Config.Operate = (NSInteger) ((config & SOS_MASK_OPERATE) >> 27);
    Config.Color = (NSInteger) ((config & SOS_MASK_COLOR) >> 24);
    Config.RemindCount = (NSInteger) ((config & SOS_MASK_REMINDCOUNT));
    return Config;
}


-(int)convert {
    int res = 0;
    if (self.Power)
        res |= 1L << 31;
    
    res |= ((self.Operate & 0x0FL) << 27);
    res |= ((self.Color & 0x07L) << 24);
    res |= (self.RemindCount & 0xFFFFL);
    
    return res;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@,%p>{Power:%d,Operate:%d,Color:%d,RemindCount:%d}",[self class], self, self.Power,self.Operate,self.Color,self.RemindCount];
}

@end
