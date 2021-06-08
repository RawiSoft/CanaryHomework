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
@interface DetailView ()

@property(nonatomic, retain) NSMutableArray<NSNumber *> *temperatureValues;
@property(nonatomic, retain) NSMutableArray<NSNumber *> *humidityValues;
@property(nonatomic, retain) NSMutableArray<NSNumber *> *airQualityValues;
@property (strong, nonatomic) dispatch_queue_t fetchQueue;

@end

@implementation DetailView

- (id)initWithDeviceID:(NSString *)deviceID {
    
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
        _fetchQueue = dispatch_queue_create("is.canary.DetailView.fetchQueue", DISPATCH_QUEUE_SERIAL);
        self.temperatureValues = [NSMutableArray new];
        self.humidityValues = [NSMutableArray new];
        self.airQualityValues = [NSMutableArray new];
//        [self fetchReadings];
    }
    return self;
}

- (void)fetchReadings:(DetailViewCompletionBlock)completionBlock {
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.fetchQueue, ^ {
        
        [[CoreDataController sharedCache] getReadingsForDevice:self.deviceID completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
            if (success) {
                weakSelf.readings = objects;
                NSLog(@"%@%@",self.readings,@"fetchReadings Detail View");
                [weakSelf updateData];
                if (completionBlock != nil){
                    
                    completionBlock(YES, YES,[weakSelf getFinalReadingsDict] );
                }
            }else {
                NSMutableDictionary<NSString *, NSNumber *> *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
                completionBlock(YES, NO, dict);
            }
        }];
        
    });

}
- (void)updateData {
    // updating the values arrays
    for (int i = 0; i < self.readings.count; i++)
        {
        Reading *reading = self.readings[i];
        NSLog(@"%@%@%@",reading.type,@" self.updateLabelAndData ",reading.value);
        if ([reading.type isEqualToString:@"temperature"]) {
            [self.temperatureValues addObject: reading.value];
        } else if ([reading.type isEqualToString:@"humidity"]) {
            [self.humidityValues addObject: reading.value];
        } else if ([reading.type isEqualToString:@"airquality"]) {
            [self.airQualityValues addObject: reading.value];
        }
        }
    

}
- (NSMutableDictionary<NSString *, NSNumber *> *)getFinalReadingsDict {
    NSMutableDictionary<NSString *, NSNumber *> *dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [self getMinTemperature] != nil ? [dict setObject:[self getMinTemperature] forKey: MIN_TEMPERATURE_KEY] : @0 ;
    
    [self getMaxTemperature] != nil ? [dict setObject:[self getMaxTemperature] forKey: MAX_TEMPERATURE_KEY] : @0 ;
    
    [self getAverageTemperature] != nil ? [dict setObject:[self getAverageTemperature] forKey: AVERAGE_TEMPERATURE_KEY] : @0 ;
    
    [self getMinHumidity] != nil ? [dict setObject:[self getMinHumidity] forKey:MIN_HUMIDITY_KEY] : @0 ;

    [self getMaxHumidity] != nil ? [dict setObject:[self getMaxHumidity] forKey:MAX_HUMIDITY_KEY] : @0 ;

    [self getAverageHumidity] != nil ? [dict setObject:[self getAverageHumidity] forKey:AVERAGE_HUMIDITY_KEY] : @0 ;
    [self getMinAirQuality] != nil ? [dict setObject:[self getMinAirQuality] forKey:MIN_AIR_QUALITY_KEY] : @0 ;
    [self getMaxAirQuality] != nil ? [dict setObject:[self getMaxAirQuality] forKey:MAX_AIR_QUALITY_KEY] : @0 ;

    [self getAverageAirQuality] != nil ? [dict setObject:[self getAverageAirQuality] forKey:AVERAGE_AIR_QUALITY_KEY] : @0 ;
    
    return dict;
}
- (NSNumber *)getMinTemperature {
    if (self.temperatureValues.count == 0) {
        return nil;
    }
    NSNumber *temperatureMin = [self.temperatureValues valueForKeyPath:@"@min.self"];
    return temperatureMin;
}
- (NSNumber *)getMaxTemperature {
    if (self.temperatureValues.count == 0) {
        return nil;
    }
    NSNumber *temperatureMax = [self.temperatureValues valueForKeyPath:@"@max.self"];
    return temperatureMax;
}
- (NSNumber *)getAverageTemperature {
    if (self.temperatureValues.count == 0) {
        return nil;
    }
    NSNumber *temperatureAverage = [self.temperatureValues valueForKeyPath:@"@avg.self"];
    return temperatureAverage;
}

- (NSNumber *)getMinHumidity {
    if (self.humidityValues.count == 0) {
        return nil;
    }
    NSNumber *humidityMin = [self.humidityValues valueForKeyPath:@"@min.self"];
    return humidityMin;
}
- (NSNumber *)getMaxHumidity {
    if (self.humidityValues.count == 0) {
        return nil;
    }
    NSNumber *humidityMax = [self.humidityValues valueForKeyPath:@"@max.self"];
    return humidityMax;
}
- (NSNumber *)getAverageHumidity {
    if (self.humidityValues.count == 0) {
        return nil;
    }
    NSNumber *humidityAverage = [self.humidityValues valueForKeyPath:@"@avg.self"];
    return humidityAverage;
}

- (NSNumber *)getMinAirQuality {
    if (self.airQualityValues.count == 0) {
        return nil;
    }

    NSNumber *airQualityMax = [self.airQualityValues valueForKeyPath:@"@max.self"];
    return airQualityMax;
}
- (NSNumber *)getMaxAirQuality {
    if (self.airQualityValues.count == 0) {
        return nil;
    }
    NSNumber *airQualityMin = [self.airQualityValues valueForKeyPath:@"@min.self"];
    return airQualityMin;
}
- (NSNumber *)getAverageAirQuality {
    if (self.airQualityValues.count == 0) {
        return nil;
    }
    NSNumber *airQualityAverage = [self.airQualityValues valueForKeyPath:@"@avg.self"];
    return airQualityAverage;
}
@end
