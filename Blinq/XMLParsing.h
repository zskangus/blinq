//
//  XMLParsing.h
//  XML解析
//
//  Created by zsk on 16/4/29.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^xmlBlock)(NSString *version,NSString *name, NSString *url);

@interface XMLParsing : NSObject

- (void)parsingXMLWith:(NSString *)fileName xmlInfo:(xmlBlock)info;

@end
