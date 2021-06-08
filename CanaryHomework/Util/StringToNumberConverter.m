//
//  StringToNumber.m
//  CanaryHomework
//
//  Created by Mustafa T. Mohammed on 6/8/21.
//  Copyright © 2021 Michael Schroeder. All rights reserved.
//

#import "StringToNumberConverter.h"

@interface StringToNumberConverter ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation StringToNumberConverter

+ (StringToNumberConverter *)sharedConverter {
    static StringToNumberConverter *sharedConverter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
    sharedConverter = [self new];
    });
    return sharedConverter;
}

-(instancetype) init    {
    self = [super init];
    
    if (self) {
        _numberFormatter = [[NSNumberFormatter alloc] init];
        _numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    }
    return self;
}


- (NSNumber *)numberFromString:(NSString *)string {
    return [self.numberFormatter numberFromString:string];
}
@end
