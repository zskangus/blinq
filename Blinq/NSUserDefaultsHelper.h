//
//  NSUserDefaultsHelper.h
//  cjj
//
//  Created by 聂晶 on 16/1/19.
//  Copyright © 2016年 cjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaultsHelper : NSObject {

}

+(NSString*)getStringForKey:(NSString*)key;
+(NSInteger)getIntForkey:(NSString*)key;
+(NSDictionary*)getDictForKey:(NSString*)key;
+(NSArray*)getArrayForKey:(NSString*)key;
+(BOOL)getBoolForKey:(NSString*)key;
+(void)setStringForKey:(NSString*)value :(NSString*)key;
+(void)setIntForKey:(NSInteger)value :(NSString*)key;
+(void)setDictForKey:(NSDictionary*)value :(NSString*)key;
+(void)setArrayForKey:(NSArray*)value :(NSString*)key;
+(void)setBoolForKey:(BOOL)value :(NSString*)key;

+(void)removeStringForKey:(NSString*)key;

@end
