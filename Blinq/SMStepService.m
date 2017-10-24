//
//  SMStepService.m
//  Blinq
//
//  Created by zsk on 2017/8/15.
//  Copyright © 2017年 zsk. All rights reserved.
//

#import "SMStepService.h"
#import "NSDate+Tool.h"

@interface SMStepService()

@property(nonatomic,strong)HKHealthStore *healthStore;

@property(nonatomic,strong)CMPedometer *pedometer;

@property(nonatomic,assign)BOOL isRuning;

@end

@implementation SMStepService

- (void)startPedometer:(void(^)(NSInteger value))event{
    // 2. 开启计步器
    [self.pedometer startPedometerUpdatesFromDate:[NSDate getEarlyMorningTime] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
        NSLog(@"距离%@+步数%@",pedometerData.distance, pedometerData.numberOfSteps);
        event([pedometerData.numberOfSteps integerValue]);
    }];
}

- (void)stopPedometer{
    [self.pedometer stopPedometerUpdates];
}

// 获取当天的步数 - CMPedometer
- (void)getCurrentSteps:(void(^)(NSInteger steps,NSInteger distance,NSDate *date))info error:(void(^)(NSError *error))errorInfo{
    
    if (self.isRuning) {
        return;
    }
    self.isRuning = YES;

    
    NSDate *startDate = [NSDate getEarlyMorningTime];
    
    NSDate *nowDate = [NSDate date];
    
    //判断记步功能
    if ([CMPedometer isStepCountingAvailable]) {
        
        [self.pedometer queryPedometerDataFromDate:startDate toDate:nowDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            self.isRuning = NO;
            if (error && error.code == CMErrorMotionActivityNotAuthorized) {
                NSLog(@"获取%@的步数时出错%@",startDate,error);
                errorInfo(error);
            }else {
                NSLog(@"获取%@的步数:%@---距离:%@",startDate,pedometerData.numberOfSteps,pedometerData.distance);
                info([pedometerData.numberOfSteps integerValue],[pedometerData.distance integerValue],startDate);
            }
        }];
    }else{
        //errorInfo(error);
        NSLog(@"记步功能不可用");
    }
}

- (void)getSevenDaySteps:(void(^)(NSDate *date,NSInteger value, NSError *error))stepsInfo completion:(void(^)(void))completion{
    
    if (self.isRuning) {
        return;
    }
    self.isRuning = YES;

    
    if ([CMPedometer isStepCountingAvailable]) { // 判断能否计步
        for (int i = 6; i >= 0; i --) {   // for循环 取出每天的步数
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            NSDate *now = [NSDate date];
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            
            NSDate *nowDate = [calendar dateFromComponents:components];
            
            NSDate * startTempDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:-i toDate:nowDate options:0];
            
            // 结束日期
            
            NSDate *endTempDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startTempDate options:0];
            
            NSDate * startDate = [NSDate getStartTimeWithDate:startTempDate];  // 将日期转为某年某月某天00：00：00
            
            NSDate * endDate = [NSDate getStartTimeWithDate:endTempDate];
            NSLog(@"从%@-----至%@",startDate,endDate);
            
            // 从开始时间到结束时间的总步数
            
            [self.pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
                
                stepsInfo(startDate,[pedometerData.numberOfSteps integerValue],error);
                
            }];
            
            
            
        }
        self.isRuning = NO;
        completion();
    }else{
    
    }
}

// 检查权限及数据是否可用 - HKHealthStore
- (void)authorizeHealthKit:(void(^)(BOOL success, NSError *error))compltion
{
    if (![HKHealthStore isHealthDataAvailable]) {
        NSError *error = [NSError errorWithDomain: @"com.raywenderlich.tutorials.healthkit" code: 2 userInfo: [NSDictionary dictionaryWithObject:@"HealthKit is not available in th is Device"                                                                      forKey:NSLocalizedDescriptionKey]];
        if (compltion != nil) {
            compltion(false, error);
        }
        return;
    }
    if ([HKHealthStore isHealthDataAvailable]) {
        if(self.healthStore == nil)
            self.healthStore = [[HKHealthStore alloc] init];
        /*
         组装需要读写的数据类型
         */
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesRead];
        
        /*
         注册需要读写的数据类型，也可以在“健康”APP中重新修改
         */
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            
            if (compltion != nil) {
                NSLog(@"error->%@", error.localizedDescription);
                compltion (success, error);
            }
        }];
        
        
    }else{
    
    }
    
}

// 获取步数 - HKHealthStore
- (void)getStepCountFromHealth:(void(^)(double value,NSDate *date, NSError *error))completion{
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    if (self.isRuning) {
        return;
    }
    self.isRuning = YES;
    
    NSDate *startDate = [NSDate getEarlyMorningTime];
    
    NSDate *nowDate = [NSDate date];

    
    // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:stepType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        self.isRuning = NO;
        if(error)
        {
            completion(0,startDate,error);
        }
        else
        {
            NSInteger totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *heightUnit = [HKUnit countUnit];
                double usersHeight = [quantity doubleValueForUnit:heightUnit];
                totleSteps += usersHeight;
            }
            NSLog(@"当天行走步数 = %ld",(long)totleSteps);
            completion(totleSteps,startDate,error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

// 获取所有步数 - HKHealthStore
- (void)getAllStepCount:(void(^)(NSDate *date,NSInteger value, NSError *error))stepsInfo completion:(void(^)(void))completion{
    
    if (self.isRuning) {
        return;
    }
    self.isRuning = YES;
    
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 1;
    
    HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:nil options: HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:[NSDate dateWithTimeIntervalSince1970:0] intervalComponents:dateComponents];
    
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        for (HKStatistics *statistic in result.statistics) {
            //NSLog(@"\n%@ 至 %@", statistic.startDate, statistic.endDate);
            for (HKSource *source in statistic.sources) {
                
                NSLog(@"+++++%ld",statistic.sources.count);
                
                if ([source.name isEqualToString:[UIDevice currentDevice].name]) {
                    NSLog(@"%@ -- .%f",source, [[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]]);
                    
                    //日期格式化
                    NSDateFormatter *formater1=[[NSDateFormatter alloc]init];
                    formater1.dateFormat=@"yyyy-MM-dd";
                    
                    stepsInfo(statistic.startDate,[[statistic sumQuantityForSource:source] doubleValueForUnit:[HKUnit countUnit]],error);
                }
            }
        }
        self.isRuning = NO;
        completion();
    };
    [self.healthStore executeQuery:collectionQuery];
}



// 获取公里数 - HKHealthStore
- (void)getDistance:(void(^)(double value, NSError *error))completion
{
    HKQuantityType *distanceType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:distanceType predicate:[self predicateForSamplesToday] limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if(error)
        {
            completion(0,error);
        }
        else
        {
            double totleSteps = 0;
            for(HKQuantitySample *quantitySample in results)
            {
                HKQuantity *quantity = quantitySample.quantity;
                HKUnit *distanceUnit = [HKUnit meterUnitWithMetricPrefix:HKMetricPrefixKilo];
                double usersHeight = [quantity doubleValueForUnit:distanceUnit];
                totleSteps += usersHeight;
            }
            NSLog(@"当天行走距离 = %.2f",totleSteps);
            completion(totleSteps,error);
        }
    }];
    [self.healthStore executeQuery:query];
}


/**@brief 写的权限*/
- (NSSet *)dataTypesToWrite
{
    //HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //HKQuantityType *temperatureType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    //HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    HKQuantityType *nilType;
    //return [NSSet setWithObjects:heightType, temperatureType, weightType,activeEnergyType,nil];
    return [NSSet setWithObjects:nilType,nil];
}

/**@brief 读的权限*/
- (NSSet *)dataTypesRead
{
    //HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    //HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    //HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    //HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
    //HKCharacteristicType *sexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
    HKQuantityType *stepCountType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    //HKQuantityType *distance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    //HKQuantityType *activeEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
    
    //return [NSSet setWithObjects:heightType, temperatureType,birthdayType,sexType,weightType,stepCountType, distance, activeEnergyType,nil];
    return [NSSet setWithObjects:stepCountType,nil];
}

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond: 0];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    return predicate;
}


#pragma mark - 单例方法 -
// 创建单利
static SMStepService* _stepService = nil;
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stepService = [super allocWithZone:zone];
    });
    return _stepService;
}
+(instancetype)shareService{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stepService = [[self alloc]init];
    });
    return _stepService;
}

#pragma mark - 懒加载 -
- (CMPedometer *)pedometer{
    if (!_pedometer) {
        _pedometer = [[CMPedometer alloc]init];
    }
    return _pedometer;
}

@end
