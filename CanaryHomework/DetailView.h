//
//  DetailView.h
//  CanaryHomework
//
//  Created by Mustafa T. Mohammed on 6/8/21.
//  Copyright © 2021 Michael Schroeder. All rights reserved.
//

#import "Device+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DetailViewCompletionBlock)(BOOL completed,
                                         BOOL success,
                                         NSMutableDictionary<NSString *, NSNumber *> *readingsMinMaxAvgDict
                                         );

@interface DetailView : NSObject

@property(nonatomic, retain)NSString *deviceID;
@property(nonatomic, retain)NSArray<Reading *> *readings;

- (id)initWithDeviceID:(NSString *)deviceID;
- (void)fetchReadings: (DetailViewCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END