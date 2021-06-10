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
#import "DetailView.h"
#import "Constants.h"

@interface DetailViewController ()

/** UILabel for Device Info */
@property(nonatomic, retain) UILabel *deviceInfoTitleLabel;
@property(nonatomic, retain) UILabel *deviceIDLabel;
@property(nonatomic, retain) UILabel *deviceNameLabel;

/** UILabel for displaying Temperature Readings */
@property(nonatomic, retain) UILabel *temperatureTitleLabel;
@property(nonatomic, retain) UILabel *temperatureMinLabel;
@property(nonatomic, retain) UILabel *temperatureMaxLabel;
@property(nonatomic, retain) UILabel *temperatureAverageLabel;

/** UILabel for displaying Humidity Readings */
@property(nonatomic, retain) UILabel *humidityTitleLabel;
@property(nonatomic, retain) UILabel *humidityMinLabel;
@property(nonatomic, retain) UILabel *humidityMaxLabel;
@property(nonatomic, retain) UILabel *humidityAverageLabel;

/** UILabel for displaying Air Quality Readings */
@property(nonatomic, retain) UILabel *airQualityTitleLabel;
@property(nonatomic, retain) UILabel *airQualityMinLabel;
@property(nonatomic, retain) UILabel *airQualityMaxLabel;
@property(nonatomic, retain) UILabel *airQualityAverageLabel;

/** Stack View to stack each group of labels into one stack*/
@property(nonatomic, retain) UIStackView *deviceInfoStackView;
@property(nonatomic, retain) UIStackView *temperatureStackView;
@property(nonatomic, retain) UIStackView *humidityStackView;
@property(nonatomic, retain) UIStackView *airQualityStackView;

/** using top constrains as a guide */
@property (nonatomic, weak) NSLayoutConstraint *deviceInfoTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *airQualityTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *humidityTopConstraint;
@property (nonatomic, weak) NSLayoutConstraint *temperatureTopConstraint;

// DetailView to handle process the readings logic
@property (nonatomic, strong) DetailView* detailView;

@end

@implementation DetailViewController

- (id)initWithDeviceID:(NSString *)deviceID andName:(NSString *)deviceName {
    
    self = [super init];
    if (self) {
        self.deviceID = deviceID;
        self.deviceName = deviceName;
        self.detailView = [[DetailView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"About Device";
    self.view.backgroundColor = [UIColor whiteColor];

    [[self detailView] fetchReadingsForDeviceID:self.deviceID
                                 withCompletion:^(BOOL completed,
                                                  BOOL success,
                                                  NSMutableDictionary<NSString *,NSNumber *> * _Nonnull readingsMinMaxAvgDict) {
        // coming back to the main thread from
        // processReadingsQueue
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateLabelsFromDictionary:readingsMinMaxAvgDict ];
        });
    }];
    [self setupUI];
    [self updateDeviceInfoLabels];
}
- (void)updateDeviceInfoLabels {
    self.deviceNameLabel.text = [NSString stringWithFormat:@"Name: %@",
                                 self.deviceName];
    self.deviceIDLabel.text = [NSString stringWithFormat:@"ID: %@",
                               self.deviceID];
}
/**
 *  updating the labels after getting the
 *  dictionary that has the Min, Max and Average readings for
 *  each sensor type.
 *  if there is no reading (nil) the label will display "N/A"
 */
- (void)updateLabelsFromDictionary:(NSDictionary<NSString *, NSNumber *> *)readingsMinMaxAvgDict {
    
    self.temperatureMinLabel.text = [NSString stringWithFormat:@"Min: %@",
                                     readingsMinMaxAvgDict[MIN_TEMPERATURE_KEY] == nil ?
                                     @"N/A": [readingsMinMaxAvgDict[MIN_TEMPERATURE_KEY] stringValue]];
    
    self.temperatureMaxLabel.text = [NSString stringWithFormat:@"Max: %@",
                                     readingsMinMaxAvgDict[MAX_TEMPERATURE_KEY] == nil ?
                                     @"N/A": [readingsMinMaxAvgDict[MAX_TEMPERATURE_KEY] stringValue]];
    self.temperatureAverageLabel.text = [NSString stringWithFormat:@"Average: %@",
                                         readingsMinMaxAvgDict[AVERAGE_TEMPERATURE_KEY] == nil ?
                                         @"N/A": [readingsMinMaxAvgDict[AVERAGE_TEMPERATURE_KEY] stringValue]];
    
    self.humidityMinLabel.text = [NSString stringWithFormat:@"Min: %@",
                                  readingsMinMaxAvgDict[MIN_HUMIDITY_KEY] == nil ?
                                  @"N/A": [readingsMinMaxAvgDict[MIN_HUMIDITY_KEY] stringValue]];
    self.humidityMaxLabel.text = [NSString stringWithFormat:@"Max: %@",
                                  readingsMinMaxAvgDict[MAX_HUMIDITY_KEY] == nil ?
                                  @"N/A": [readingsMinMaxAvgDict[MAX_HUMIDITY_KEY] stringValue]];
    self.humidityAverageLabel.text = [NSString stringWithFormat:@"Average: %@",
                                      readingsMinMaxAvgDict[AVERAGE_HUMIDITY_KEY] == nil ?
                                      @"N/A": [readingsMinMaxAvgDict[AVERAGE_HUMIDITY_KEY] stringValue]];
    
    self.airQualityMinLabel.text = [NSString stringWithFormat:@"Min: %@",
                                    readingsMinMaxAvgDict[MIN_AIR_QUALITY_KEY] == nil ?
                                    @"N/A": [readingsMinMaxAvgDict[MIN_AIR_QUALITY_KEY] stringValue]];
    self.airQualityMaxLabel.text = [NSString stringWithFormat:@"Max: %@",
                                    readingsMinMaxAvgDict[MAX_AIR_QUALITY_KEY] == nil ?
                                    @"N/A": [readingsMinMaxAvgDict[MAX_AIR_QUALITY_KEY] stringValue]];
    self.airQualityAverageLabel.text = [NSString stringWithFormat:@"Average: %@",
                                        readingsMinMaxAvgDict[AVERAGE_AIR_QUALITY_KEY] == nil ?
                                        @"N/A": [readingsMinMaxAvgDict[AVERAGE_AIR_QUALITY_KEY] stringValue]];
}

- (void)initilizeLabels {
    
    self.deviceInfoTitleLabel = [UILabel new];
    self.deviceInfoTitleLabel.text = @"Device Info";
    self.deviceNameLabel = [UILabel new];
    self.deviceIDLabel = [UILabel new];
    self.deviceInfoTitleLabel.textColor = [UIColor labelColor];
    self.deviceNameLabel.textColor = [UIColor darkGrayColor];
    self.deviceIDLabel.textColor = [UIColor darkGrayColor];
    self.deviceInfoTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    self.temperatureTitleLabel = [UILabel new];
    self.temperatureTitleLabel.text = @"Temperature";
    self.temperatureMinLabel = [UILabel new];
    self.temperatureMaxLabel = [UILabel new];
    self.temperatureAverageLabel = [UILabel new];
    self.temperatureTitleLabel.textColor = [UIColor labelColor];
    self.temperatureMinLabel.textColor = [UIColor darkGrayColor];
    self.temperatureMaxLabel.textColor = [UIColor darkGrayColor];
    self.temperatureAverageLabel.textColor = [UIColor darkGrayColor];
    self.temperatureTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    self.humidityTitleLabel = [UILabel new];
    self.humidityTitleLabel.text = @"Humidity";
    self.humidityMinLabel = [UILabel new];
    self.humidityMaxLabel = [UILabel new];
    self.humidityAverageLabel = [UILabel new];
    self.humidityTitleLabel.textColor = [UIColor labelColor];
    self.humidityMinLabel.textColor = [UIColor darkGrayColor];
    self.humidityMaxLabel.textColor = [UIColor darkGrayColor];
    self.humidityAverageLabel.textColor = [UIColor darkGrayColor];
    self.humidityTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    self.airQualityTitleLabel = [UILabel new];
    self.airQualityTitleLabel.text = @"Air Quality";
    self.airQualityMinLabel = [UILabel new];
    self.airQualityMaxLabel = [UILabel new];
    self.airQualityAverageLabel = [UILabel new];
    self.airQualityTitleLabel.textColor = [UIColor labelColor];
    self.airQualityMinLabel.textColor = [UIColor darkGrayColor];
    self.airQualityMaxLabel.textColor = [UIColor darkGrayColor];
    self.airQualityAverageLabel.textColor = [UIColor darkGrayColor];
    self.airQualityTitleLabel.font = [UIFont boldSystemFontOfSize:20];
}
/**
 *  setting up the UI by creating stackViews and
 *  assign constrains
 */
- (void)setupUI {
    
    [self initilizeLabels];
    self.deviceInfoStackView = [self buildStackViewWithTitleLabel:self.deviceInfoTitleLabel
                                topLabel:self.deviceNameLabel
                                midLabel:self.deviceIDLabel
                                bottomLabel:nil];

    self.temperatureStackView = [self buildStackViewWithTitleLabel:self.temperatureTitleLabel
                                 topLabel:self.temperatureMinLabel
                                 midLabel:self.temperatureMaxLabel
                                 bottomLabel:self.temperatureAverageLabel];
    self.humidityStackView = [self buildStackViewWithTitleLabel:self.humidityTitleLabel
                              topLabel:self.humidityMinLabel
                              midLabel:self.humidityMaxLabel
                              bottomLabel:self.humidityAverageLabel];
    self.airQualityStackView = [self buildStackViewWithTitleLabel:self.airQualityTitleLabel
                                topLabel:self.airQualityMinLabel
                                midLabel:self.airQualityMaxLabel
                                bottomLabel:self.airQualityAverageLabel];
    self.deviceInfoTopConstraint = [self.deviceInfoStackView.topAnchor
                                    constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor
                                    constant:K_PADDING];
    self.temperatureTopConstraint = [self.temperatureStackView.topAnchor
                                     constraintEqualToAnchor:self.deviceInfoStackView.bottomAnchor
                                     constant:K_PADDING];
    self.humidityTopConstraint = [self.humidityStackView.topAnchor
                                  constraintEqualToAnchor:self.temperatureStackView.bottomAnchor
                                  constant:K_PADDING];
    self.airQualityTopConstraint = [self.airQualityStackView.topAnchor
                                    constraintEqualToAnchor:self.humidityStackView.bottomAnchor
                                    constant:K_PADDING];
    
    [NSLayoutConstraint activateConstraints:@[
        // assigning constrains to each stackView
        self.deviceInfoTopConstraint,
        [self.deviceInfoStackView.leadingAnchor
         constraintEqualToAnchor:self.view.leadingAnchor
         constant:K_PADDING],
        [self.deviceInfoStackView.trailingAnchor
         constraintEqualToAnchor:self.view.trailingAnchor
         constant: -K_PADDING],
        
        self.temperatureTopConstraint,
        [self.temperatureStackView.leadingAnchor
         constraintEqualToAnchor:self.view.leadingAnchor constant:K_PADDING],
        [self.temperatureStackView.trailingAnchor
         constraintEqualToAnchor:self.view.trailingAnchor constant: -K_PADDING],
        
        self.humidityTopConstraint,
        [self.humidityStackView.leadingAnchor
         constraintEqualToAnchor:self.view.leadingAnchor constant:K_PADDING],
        [self.humidityStackView.trailingAnchor
         constraintEqualToAnchor:self.view.trailingAnchor constant: -K_PADDING],
        
        self.airQualityTopConstraint,
        [self.airQualityStackView.leadingAnchor
         constraintEqualToAnchor:self.view.leadingAnchor constant:K_PADDING],
        [self.airQualityStackView.trailingAnchor
         constraintEqualToAnchor:self.view.trailingAnchor constant: -K_PADDING],
       
    ]];
}
/**
 *  building a StackView that consist of a Title Label and
 *  up to three labels
 *  topLabel, midLabel and bottomLabel
 *  so you will have less constraint to worry about :)
 */
- (UIStackView *)buildStackViewWithTitleLabel:(UILabel *)titleLabel
                                     topLabel:(UILabel *)topLabel
                                     midLabel:(UILabel*)midLabel
                                     bottomLabel:(UILabel *)bottomLabel {
    
    UIStackView *stackView = [UIStackView new];
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.spacing = 8;
    
    [stackView addArrangedSubview:titleLabel];
    [stackView addArrangedSubview:topLabel];
    [stackView addArrangedSubview:midLabel];
    [stackView addArrangedSubview:bottomLabel];
    
    [self.view addSubview:stackView];
    
    return stackView;
}
@end
