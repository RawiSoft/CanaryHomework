//
//  DetailView.m
//  CanaryHomework
//
//  Created by Mustafa T. Mohammed on 6/8/21.
//  Copyright © 2021 Michael Schroeder. All rights reserved.
//

#import "CoreDataController.h"
#import "DetailView.h"
#import "Device+CoreDataProperties.h"
#import "Reading+CoreDataProperties.h"
#import "Constants.h"
/**
 * This will handle all the logic from fetching readings to
 * process Min, Max and Average for each sensor type
 */
@interface DetailView ()


@property (strong, nonatomic) dispatch_queue_t processReadingsQueue;

@end

@implementation DetailView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        // a private  queue for processing the readings
        // for each sensor and get the Min, Max and Average
        _processReadingsQueue = dispatch_queue_create("is.canary.DetailView.processReadingsQueue",
                                            DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

 - (void)fetchReadingsForDeviceID: (NSString *)deviceID
                       withCompletion:(DetailViewCompletionBlock)completionBlock {
    __weak typeof(self) weakSelf = self;
        
        [[CoreDataController sharedCache]
         getReadingsForDevice:deviceID
         completionBlock:^(BOOL completed,
                           BOOL success,
                           NSArray * _Nonnull objects) {
            dispatch_async(self.processReadingsQueue, ^ {
            if (success) {
                weakSelf.readings = objects;
                NSDictionary<NSString *,NSArray<NSNumber *> *> * dict =  [weakSelf extractSensorTypeValuesFrom: objects];
                if (completionBlock != nil){
                    completionBlock(YES, YES,[weakSelf getFinalReadingsDictFromDictionary:dict]);
                }
            }else {
                NSMutableDictionary<NSString *, NSNumber *> *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                completionBlock(YES, NO, dict);
            }
            });
        }];
}
/**
 * Distribute the readings into three different arrays
 * temperatureValues, humidityValues and airQualityValues
 * that will use "processReadingsQueue"
 */
- (NSDictionary<NSString *,NSArray<NSNumber *> *> *)extractSensorTypeValuesFrom: (NSArray<Reading *> *) readings {
    // updating the values arrays
    NSMutableArray<NSNumber *> *temperatureValues = [NSMutableArray new];
    NSMutableArray<NSNumber *> *humidityValues = [NSMutableArray new];
    NSMutableArray<NSNumber *> *airQualityValues = [NSMutableArray new];
    
    for (int i = 0; i < readings.count; i++)
    {
        Reading *reading = readings[i];
        if ([reading.type isEqualToString:@"temperature"]) {
            [ temperatureValues addObject: reading.value];
        } else if ([reading.type isEqualToString:@"humidity"]) {
            [humidityValues addObject: reading.value];
        } else if ([reading.type isEqualToString:@"airquality"]) {
            [ airQualityValues addObject: reading.value];
        }
    }
    
    NSMutableDictionary<NSString *,NSMutableArray *>  * readingsDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys: temperatureValues, @"temperatureValues", humidityValues, @"humidityValues", airQualityValues, @"airQualityValues", nil];
    return  readingsDictionary;
}
/**
 *  process the final readings in"processReadingsQueue" by
 *  getting the Min, Max and  Average values from the
 *  three arrays temperatureValues, humidityValues and airQualityValues
 *  and then add all the results into a dictionary
 */
- (NSMutableDictionary<NSString *, NSNumber *> *)
                                     getFinalReadingsDictFromDictionary:
                                    (NSDictionary<NSString *,NSArray<NSNumber *> *> *)
                                    sensorTypeValuesDict
{
    
    NSMutableDictionary<NSString *, NSNumber *> *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    NSArray<NSNumber *> *temperatureValues = sensorTypeValuesDict[@"temperatureValues"];
    if (temperatureValues != nil ){
    [self getMinValueFrom: temperatureValues] != nil ?
    [dict setObject:[self getMinValueFrom: temperatureValues] forKey: MIN_TEMPERATURE_KEY] : @0 ;
    [self getMaxValueFrom: temperatureValues] != nil ?
    [dict setObject:[self getMaxValueFrom: temperatureValues] forKey: MAX_TEMPERATURE_KEY] : @0 ;
    [self getAverageValueFrom: temperatureValues] != nil ?
    [dict setObject:[self getAverageValueFrom: temperatureValues] forKey: AVERAGE_TEMPERATURE_KEY] : @0 ;
    }
    NSArray<NSNumber *> *humidityValues = sensorTypeValuesDict[@"humidityValues"];
    if (humidityValues != nil ){
    [self getMinValueFrom: humidityValues] != nil ?
    [dict setObject:[self getMinValueFrom: humidityValues] forKey:MIN_HUMIDITY_KEY] : @0 ;
    [self getMaxValueFrom: humidityValues] != nil ?
    [dict setObject:[self getMaxValueFrom: humidityValues] forKey:MAX_HUMIDITY_KEY] : @0 ;
    [self getAverageValueFrom: humidityValues] != nil ?
    [dict setObject:[self getAverageValueFrom: humidityValues] forKey:AVERAGE_HUMIDITY_KEY] : @0 ;
    }
    NSArray<NSNumber *> *airQualityValues = sensorTypeValuesDict[@"airQualityValues"];
    if (humidityValues != nil ){
    [self getMinValueFrom: airQualityValues] != nil ?
    [dict setObject:[self getMinValueFrom: airQualityValues] forKey:MIN_AIR_QUALITY_KEY] : @0 ;
    [self getMaxValueFrom: airQualityValues] != nil ?
    [dict setObject:[self getMaxValueFrom: airQualityValues] forKey:MAX_AIR_QUALITY_KEY] : @0 ;
    [self getAverageValueFrom: airQualityValues] != nil ?
    [dict setObject:[self getAverageValueFrom: airQualityValues] forKey:AVERAGE_AIR_QUALITY_KEY] : @0 ;
    }
    return dict;
}

- (NSNumber *)getMinValueFrom: (NSArray<NSNumber *> *) values {
    if (values.count == 0) {
        return nil;
    }
    NSNumber *minValue = [values valueForKeyPath:@"@min.self"];
    return minValue;
}

- (NSNumber *)getMaxValueFrom: (NSArray<NSNumber *> *) values {
    if (values.count == 0) {
        return nil;
    }
    NSNumber *maxValue = [values valueForKeyPath:@"@max.self"];
    return maxValue;
}

- (NSNumber *)getAverageValueFrom: (NSArray<NSNumber *> *) values {
    if (values.count == 0) {
        return nil;
    }
    NSNumber *avgValue = [values valueForKeyPath:@"@avg.self"];
    return avgValue;
}
@end
