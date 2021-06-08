//
//  DetailViewController.h
//  CanaryHomework
//
//  Created by Michael Schroeder on 9/24/19.
//  Copyright © 2019 Michael Schroeder. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController

@property(nonatomic, retain)NSString *deviceID;
@property(nonatomic, retain)NSString *deviceName;
@property(nonatomic, retain)NSArray<Reading *> *readings;

- (id)initWithDeviceID:(NSString *)deviceID andName: (NSString *) deviceName;

@end

NS_ASSUME_NONNULL_END
