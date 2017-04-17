//
//  SMSOSCheckAlgorithmService.m
//  Blinq
//
//  Created by zsk on 2017/4/12.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMSOSCheckAlgorithmService.h"

typedef struct {
    uint64_t time;
    int count;
}Event;

@interface SMSOSCheckAlgorithmService()

@property(nonatomic) SOSLevel mLevel;

@property(nonatomic) double mDoubleTapPercent;

@property(nonatomic) int mCount;

@property(nonatomic) uint64_t mEventInterval;

@property(nonatomic) NSMutableArray *mEventList;


@end

@implementation SMSOSCheckAlgorithmService

- (NSMutableArray *)mEventList{
    if (!_mEventList) {
        _mEventList = [NSMutableArray array];
    }
    return _mEventList;
    
}

// 创建单利
static SMSOSCheckAlgorithmService* _defaultSMSOSCheckAlgorithmService = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultSMSOSCheckAlgorithmService = [super allocWithZone:zone];
    });
    return _defaultSMSOSCheckAlgorithmService;
}
+(SMSOSCheckAlgorithmService *)sharedSMSOSCheckAlgorithmService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultSMSOSCheckAlgorithmService = [[self alloc]init];
    });
    return _defaultSMSOSCheckAlgorithmService;
}
-(id)copyWithZone:(NSZone*)zone{
    return _defaultSMSOSCheckAlgorithmService;
}

- (bool)putEvent:(int)count{
    
    Event event;
    // 敲击时间
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    event.time = (uint64_t)([date timeIntervalSince1970]*1000);
    event.count = count;
    
    
    NSValue *value = [NSValue valueWithBytes:&event objCType:@encode(Event)];
    
    [self.mEventList insertObject:value atIndex:0];
    
    for (NSValue *val in self.mEventList) {
        Event eve;
        [val getValue:&eve];
        NSLog(@"时间：%llu-----单双击：%d",eve.time,eve.count);
    }
    
    self.mCount = 0;
    self.mDoubleTapPercent = 1.0;
    NSLog(@"=====================SOS CHECK START======================");
    
    bool res = [self check:0];
    NSLog(@"=====================SOS CHECK END:(%@)========================",res?@"YES":@"NO");
    
    

    return res;
}

- (bool)check:(int)index{
    if (_mEventList.count < _mLevel.Count/2) {
        NSLog(@"check less event data.");
        return false;
    }
    
    if (index >= self.mEventList.count) {
        NSLog(@"check over failed:%d",index);

        return false;
    }
    
    
    Event event ;
    [self.mEventList[index] getValue: &event];
    
    uint64_t time = event.time;
    int count = event.count;
    
    if(index < self.mEventList.count - 1){
        [self.mEventList[index + 1] getValue: &event];
        
        self.mEventInterval = time - event.time;
        
        if(self.mEventInterval < self.mLevel.TWindow || self.mEventInterval > self.mLevel.TLimit){
            
            NSArray *array = [self.mEventList subarrayWithRange:NSMakeRange(0, index+1)];
            self.mEventList = [NSMutableArray arrayWithArray:array];
            
            NSLog(@"check failed because interval not in [window, limit]:%d",index);
            return false;
        }
    }
    
    if(count != 2){
        self.mDoubleTapPercent -= 1.0 / self.mLevel.Count;
    }
    if(self.mDoubleTapPercent < self.mLevel.DPercent){
        NSArray *array = [self.mEventList subarrayWithRange:NSMakeRange(0, index+1)];
        self.mEventList = [NSMutableArray arrayWithArray:array];
        
        NSLog(@"check failed because DoubleTapPercent less than predefined.%d",index);
        return false;
    }
    
    self.mCount += count;
    
    if(self.mCount >= self.mLevel.Count){
        [self.mEventList removeAllObjects];
        return true;
    }
    
    return [self check:index+1];
}

- (void)setLevel:(SOSLevel)level{
    self.mLevel = level;
}



@end
