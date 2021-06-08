//
//  StringToNumber.h
//  CanaryHomework
//
//  Created by Mustafa T. Mohammed on 6/8/21.
//  Copyright © 2021 Michael Schroeder. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StringToNumberConverter : NSObject

+ (StringToNumberConverter *)sharedConverter;
-(NSNumber *) numberFromString:(NSString *)dateString;

@end

NS_ASSUME_NONNULL_END
