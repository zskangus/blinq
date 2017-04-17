//
//  SMDataPackageManager.h
//  Blinq
//
//  Created by zsk on 2016/12/1.
//  Copyright © 2016年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMDataPackageManager : NSObject

- (NSData*)buildDataFrom:(NSInteger)moduleId and:(NSData *)bodyData;

@end
