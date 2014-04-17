//
//  RunViewController.h
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface RunViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *startPoint;
@property (assign, nonatomic) CLLocationDistance totalDistance;

@property (weak, nonatomic) IBOutlet UILabel *distanceTravelledLabel;
@property (weak, nonatomic) IBOutlet UILabel *speed ;
@property (weak, nonatomic) IBOutlet UILabel *avgSpeed;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *save ;
@property (weak, nonatomic) IBOutlet UIButton *reset;
@property NSInteger secondsElapsed;
@property NSInteger seconds, minutes, hours;
@property (nonatomic, strong) NSTimer *secondsTimer;
@property NSDate *startDate;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
