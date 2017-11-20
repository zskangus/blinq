//
//  SMPersonalModel.m
//  SmartRing
//
//  Created by zsk on 2017/7/5.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMPersonalModel.h"

@implementation SMPersonalModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.name forKey:@"c_name"];
    [aCoder encodeObject:self.familyName forKey:@"c_familyName"];
    [aCoder encodeObject:self.givenName forKey:@"c_givenName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.sex] forKey:@"c_sex"];
    [aCoder encodeObject:self.birthday forKey:@"c_birthday"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.age] forKey:@"c_age"];
    [aCoder encodeObject:self.heightDic forKey:@"c_heightString"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.heightRow] forKey:@"c_heightRow"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.heightComponent] forKey:@"c_heightComponent"];
    [aCoder encodeObject:[NSNumber numberWithDouble:self.weight] forKey:@"c_weight"];
    [aCoder encodeObject:self.weightDic forKey:@"c_weightString"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.weightRow] forKey:@"c_weightRow"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.weightComponent] forKey:@"c_weightComponent"];
    [aCoder encodeObject:self.organizationName forKey:@"c_organizationName"];
    [aCoder encodeObject:self.phoneNumber forKey:@"c_phoneNumber"];
    [aCoder encodeObject:self.photo forKey:@"c_photo"];
    [aCoder encodeObject:self.countryCode forKey:@"c_countryCode"];
    [aCoder encodeObject:self.countryName forKey:@"c_countryName"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.colorId] forKey:@"c_colorId"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.name = [aDecoder decodeObjectForKey:@"c_name"];
        self.familyName = [aDecoder decodeObjectForKey:@"c_familyName"];
        self.givenName = [aDecoder decodeObjectForKey:@"c_givenName"];
        self.sex = [[aDecoder decodeObjectForKey:@"c_sex"]integerValue];
        self.birthday = [aDecoder decodeObjectForKey:@"c_birthday"];
        self.age = [[aDecoder decodeObjectForKey:@"c_age"]integerValue];
        self.heightDic = [aDecoder decodeObjectForKey:@"c_heightString"];
        self.heightRow = [[aDecoder decodeObjectForKey:@"c_heightRow"]integerValue];
        self.heightComponent = [[aDecoder decodeObjectForKey:@"c_heightComponent"]integerValue];
        self.weight = [[aDecoder decodeObjectForKey:@"c_weight"]doubleValue];
        self.weightDic = [aDecoder decodeObjectForKey:@"c_weightString"];
        self.weightRow = [[aDecoder decodeObjectForKey:@"c_weightRow"]integerValue];
        self.weightComponent = [[aDecoder decodeObjectForKey:@"c_weightComponent"]integerValue];
        self.organizationName = [aDecoder decodeObjectForKey:@"c_organizationName"];
        self.phoneNumber = [aDecoder decodeObjectForKey:@"c_phoneNumber"];
        self.photo = [aDecoder decodeObjectForKey:@"c_photo"];
        self.countryCode = [aDecoder decodeObjectForKey:@"c_countryCode"];
        self.countryName = [aDecoder decodeObjectForKey:@"c_countryName"];
        self.colorId = [[aDecoder decodeObjectForKey:@"c_colorId"]integerValue];
        
    }
    return self;
}

@end
