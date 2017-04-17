//
//  SMSOSCheckAlgorithmService.h
//  Blinq
//
//  Created by zsk on 2017/4/12.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    int Count;
    double DPercent;
    long TWindow;
    long TLimit;
}SOSLevel;

@interface SMSOSCheckAlgorithmService : NSObject

+(SMSOSCheckAlgorithmService *)sharedSMSOSCheckAlgorithmService;

- (bool)putEvent:(int)count;

- (void)setLevel:(SOSLevel)level;


@end
