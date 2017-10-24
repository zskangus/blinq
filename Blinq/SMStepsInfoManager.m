//
//  SMStepsInfoManager.m
//  Blinq
//
//  Created by zsk on 2017/8/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepsInfoManager.h"
#import "SMStepService.h"
#import "NSDate+Tool.h"
#import "SMBlinqInfo.h"
@interface SMStepsInfoManager()

@property(nonatomic,strong)SMStepService *stepSerVice;

@end

@implementation SMStepsInfoManager

- (void)startPedometer:(void(^)(SMStepModel *step))event{

    [self.stepSerVice startPedometer:^(NSInteger value) {
        SMStepModel *step = [SMStepDB stepInfos].lastObject;
        
        step.steps = value;
        
        [SMStepDB updataStepsInfo:step];
        
        event(step);
    }];

}

- (void)stopPedometer{
    [self.stepSerVice stopPedometer];
}

- (void)getPedometerPowerState:(void(^)(BOOL state))state{
    [self.stepSerVice getCurrentSteps:^(NSInteger steps, NSInteger distance, NSDate *date) {
        state(YES);
    } error:^(NSError *error) {
        state(NO);
    }];
}

- (void)getCurrentSteps:(void(^)(SMStepModel *step))completion error:(void(^)(NSError *error))errorInfo{
    
    SMStepModel *lastObj = [SMStepDB stepInfos].lastObject;

    [self.stepSerVice getCurrentSteps:^(NSInteger steps, NSInteger distance, NSDate *date) {
        
        NSString *dateString = [NSDate stringFormDate:date withDateFormat:@"yyyy-MM-dd"];
        
        NSArray *array = [dateString componentsSeparatedByString:@"-"]; //从字符-中分隔成3个元素的数组
        
        SMStepModel *stepInfo = [[SMStepModel alloc]init];
        
        stepInfo.date = dateString;
        
        stepInfo.year = [array[0]integerValue];
        
        stepInfo.month = [array[1]integerValue];
        
        stepInfo.day = [array[2]integerValue];
        
        stepInfo.steps = steps;
        
        stepInfo.targetSteps = [SMBlinqInfo targetSteps];
        
        if (lastObj.date.length <= 0) {
            [SMStepDB addStepsInfo:stepInfo];
        }else{
            switch ([self compare:lastObj.date withdateB:date]) {
                case NSOrderedSame:
                    NSLog(@"两个日期相同");
                {
                    [SMStepDB updataStepsInfo:stepInfo];
                }
                    break;
                case NSOrderedAscending:
                    NSLog(@"A日期比B小");
                {
                    [SMStepDB addStepsInfo:stepInfo];
                }
                    break;
                case NSOrderedDescending:
                    NSLog(@"A日期比B大");
                    
                    break;
                default:
                    break;
            }
        }

        completion(stepInfo);
        
    } error:^(NSError *error) {
        errorInfo(error);
    }];
}

- (void)getSevenSteps:(void(^)(void))completion error:(void(^)(NSError *error))errorInfo{
    
    [self.stepSerVice getSevenDaySteps:^(NSDate *date, NSInteger value, NSError *error) {
        
        if (error) {
            errorInfo(error);
        }else{
            NSString *dateString = [NSDate stringFormDate:date withDateFormat:@"yyyy-MM-dd"];
            
            NSArray *array = [dateString componentsSeparatedByString:@"-"]; //从字符-中分隔成3个元素的数组
            
            SMStepModel *stepInfo = [[SMStepModel alloc]init];
            
            stepInfo.date = dateString;
            
            stepInfo.year = [array[0]integerValue];
            
            stepInfo.month = [array[1]integerValue];
            
            stepInfo.day = [array[2]integerValue];
            
            stepInfo.steps = value;
            
            stepInfo.targetSteps = [SMBlinqInfo targetSteps];
            
            [SMStepDB addStepsInfo:stepInfo];
        }
        
    } completion:^{
        completion();
    }];
}

- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion{
    [self.stepSerVice authorizeHealthKit:^(BOOL success, NSError *error) {
        compltion(success,error);
    }];
}

- (void)getAllStepDataStart:(void(^)(void))start completion:(void(^)(void))completion error:(void(^)(NSError *error))errorInfo{

    [self.stepSerVice authorizeHealthKit:^(BOOL success, NSError *error) {
        
        if (error) {
            errorInfo(error);
        }
        
        if (success) {
            start();
            
            NSString * lastLoadTime = [SMBlinqInfo stepDataLastLoadTime];
            
            [self.stepSerVice getAllStepCount:^(NSDate *date, NSInteger value, NSError *error) {
                if (error) {
                    NSLog(@"错误:%@",error);
                    errorInfo(error);
                    return ;
                }
                NSString *dateString = [NSDate stringFormDate:date withDateFormat:@"yyyy-MM-dd"];
                
                NSArray *array = [dateString componentsSeparatedByString:@"-"]; //从字符-中分隔成3个元素的数组
                
                SMStepModel *stepInfo = [[SMStepModel alloc]init];
                
                stepInfo.date = dateString;
                
                stepInfo.year = [array[0]integerValue];
                
                stepInfo.month = [array[1]integerValue];
                
                stepInfo.day = [array[2]integerValue];
                
                stepInfo.steps = value;
                
                if ([SMBlinqInfo isloadedAllData] == NO) {
                    stepInfo.targetSteps = 3000;
                }else{
                    stepInfo.targetSteps = [SMBlinqInfo targetSteps];
                }
                
                if ([SMStepDB checkInfoWith:stepInfo]) {
                    
                    if ([lastLoadTime isEqualToString:dateString]) {
                        [SMStepDB updataStepsInfo:stepInfo];
                    }
                    
                    //NSLog(@"shijian --- %@--%@",lastLoadTime,dateString);
                    
                }else{
                    //NSLog(@"添加数据");
                    [SMStepDB addStepsInfo:stepInfo];
                }
                
//                NSLog(@"时间：%@ -- 步数：%ld",dateString,(long)value);
//                NSLog(@"%@",array);
//                NSLog(@"%ld",stepInfo.month);
                
            } completion:^{
                [SMBlinqInfo setStepDataLastLoadTime:[NSDate stringFormDate:[NSDate getEarlyMorningTime] withDateFormat:@"yyyy-MM-dd"]];
                completion();
            }];
        }
    }];
}

- (void)getHealthPowerState:(void(^)(BOOL power))state{
    
    [self.stepSerVice getStepCountFromHealth:^(double value, NSDate *date, NSError *error) {
        
        if (value > 0) {
            state(YES);
        }else{
            state(NO);
        }
    }];

}


- (NSComparisonResult)compare:(id)dateA withdateB:(id)dateB{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateAString = [[NSString alloc]init];
    
    NSString *dateBString = [[NSString alloc]init];
    
    if ([dateA isKindOfClass:[NSDate class]]) {
        dateAString = [dateFormatter stringFromDate:dateA];
    }
    
    if ([dateB isKindOfClass:[NSDate class]]) {
        dateBString = [dateFormatter stringFromDate:dateB];
    }
    
    if ([dateA isKindOfClass:[NSString class]]) {
        dateAString = dateA;
    }
    
    if ([dateB isKindOfClass:[NSString class]]) {
        dateBString = dateB;
    }
    
    // compare 两个日期的比较
    NSComparisonResult result = [[dateFormatter dateFromString:dateAString] compare:[dateFormatter dateFromString:dateBString]];
    
    //    switch (result) {
    //        case NSOrderedSame:
    //            NSLog(@"两个日期相同");
    //
    //            break;
    //        case NSOrderedAscending:
    //            NSLog(@"A日期比B小");
    //
    //
    //            break;
    //        case NSOrderedDescending:
    //            NSLog(@"A日期比B大");
    //
    //            break;
    //        default:
    //            break;
    //    }
    
    NSLog(@"处理过的日期---dateA:%@--dateB:%@",[dateFormatter dateFromString:dateAString],[dateFormatter dateFromString:dateBString]);
    
    return result;
}


#pragma mark - 懒加载 -
- (SMStepService *)stepSerVice{
    if (!_stepSerVice) {
        _stepSerVice = [SMStepService shareService];
    }
    return _stepSerVice;
}

@end
