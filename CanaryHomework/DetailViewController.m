//
//  DetailViewController.m
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import "CoreDataController.h"
#import "DetailViewController.h"
#import "Device+CoreDataProperties.h"
#import "Reading+CoreDataProperties.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithDeviceID:(NSString *)deviceID {
    
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About Device";
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchReadings];

}

- (void)fetchReadings{
    [[CoreDataController sharedCache] getReadingsForDevice:self.deviceID completionBlock:^(BOOL completed, BOOL success, NSArray * _Nonnull objects) {
        if (success) {
            self.readings = objects;
            NSLog(@"%@%@",self.readings,@"fetchReadings");
        }
    }];
}

@end
