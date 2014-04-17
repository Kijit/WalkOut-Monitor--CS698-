//
//  RunViewController.m
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import "RunViewController.h"
#import "Place.h"
#import "Record.h"
#import "AppDelegate.h"

@interface RunViewController ()

@property (strong,nonatomic) NSMutableArray *averageSpeed ;
@property (readwrite,nonatomic) double *average ;
@property (weak, nonatomic) IBOutlet UILabel *caloriesLabel;

@property float calories;
@end

@implementation RunViewController

-(NSMutableArray *)averageSpeed
{
    if (!_averageSpeed) {
        _averageSpeed = [[NSMutableArray alloc]init];
    }
    return _averageSpeed ;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //1
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;

	// Do any additional setup after loading the view.
    _mapView.showsUserLocation = YES;
    //Custom COde below to enbed image view in a label
    [_testLabel setOpaque:NO];
    [_testLabel setBackgroundColor:[UIColor clearColor]];
    UIImageView *testImageView = [[UIImageView alloc] initWithFrame:_testLabel.frame];
    [testImageView setImage:[UIImage imageNamed:@"broadcastBtn.png"]];
    [self.view insertSubview:testImageView belowSubview:_testLabel];
 //   [testImageView release];
}
- (IBAction)runButton:(id)sender
{
    
    
    
    NSString *title=self.runButton.titleLabel.text;
    if ([title isEqualToString:@"Run !"])
    {
        //For Timer
        self.secondsTimer = [NSTimer
                             scheduledTimerWithTimeInterval:1.0
                             target:self
                             selector:@selector(timerFireMethod:)
                             userInfo:nil
                             repeats:YES];
        self.seconds = 0;
        self.minutes = 0;
        self.hours = 0;
        _startDate=[NSDate date];
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate= self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [_locationManager startUpdatingLocation];
        [self.runButton setTitle:@"Stop" forState:UIControlStateNormal];
    }else
    {
        [_locationManager stopUpdatingLocation];
        [_secondsTimer invalidate];
        [self.runButton setTitle:@"Run !" forState:UIControlStateNormal];
        _save.hidden=false;
        _startPoint = nil ;
    }

    
}
- (IBAction)backButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark ClLocationManagerDelegateMethods
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
   
    
    // aspeed is current speed
    NSString *aspeed = [NSString stringWithFormat:@"%.02f",[newLocation speed]];
    _speed.text = aspeed ;
    
    double avspeed = newLocation.speed ;
    NSLog(@"speed :%.02f",avspeed);
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSNumber *num = [NSNumber numberWithDouble:avspeed];
    NSLog(@"num : %@",num);
    [_averageSpeed addObject:num];
    
    
    NSNumber *averageValue = [self.averageSpeed valueForKeyPath:@"@avg.self"];
    
    
    
    NSString *avg2 = [fmt stringFromNumber:averageValue];
    NSLog(@"array  = %@", _averageSpeed.description);
    _avgSpeed.text = avg2;
    
    
    
    if( newLocation.verticalAccuracy<0 || newLocation.horizontalAccuracy<0){
        return;
    }
    if (newLocation.horizontalAccuracy>100 || newLocation.verticalAccuracy>50){
        return;
    }
    //float d;
    if (_startPoint ==nil)
    {
        self.startPoint= newLocation;
        self.totalDistance=0;
        
        Place *start = [[Place alloc] init];
        start.coordinate=newLocation.coordinate;
        start.title=@"Start Point";
        start.subtitle=@"This is where we started";
        
        [_mapView addAnnotation:start];
        MKCoordinateRegion region;
        region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100);
        [_mapView setRegion:region animated:YES];
    }else{
        self.totalDistance+=[newLocation distanceFromLocation:oldLocation];
        self.totalDistance = self.totalDistance;
    }
    NSString *distanceString = [NSString stringWithFormat:@"%gm",_totalDistance];
    _distanceTravelledLabel.text = distanceString;
    NSLog(@"Distance Travelled: %@",distanceString);
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    NSString *weight = [fetchDefaults objectForKey:@"MessageKey"];
    int weightinint= [weight intValue];
    // d is the distance in km
    NSInteger k = 1.25 * newLocation.speed;
    _calories= (weightinint * (_secondsElapsed*0.000277) * k);
    _caloriesLabel.text = [NSString stringWithFormat:@"%.02f",_calories];
    
}

- (IBAction)saveToDB:(id)sender {
   
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    //  1
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    
    
    newEntry.avgspeed= self.avgSpeed.text;
    newEntry.distance= self.distanceTravelledLabel.text;
    newEntry.date= dateString;
    newEntry.lifts = [NSString stringWithFormat:@"None"];
   
    NSString *myString = [NSString stringWithFormat: @"%0.2f", _calories];
    newEntry.calories= myString;
    NSError *error;
    
    newEntry.seconds= [NSString stringWithFormat:@"%@:%@:%@",_hoursLabel.text,_minutesLabel.text,_secondsLabel.text];
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    
    
    [self.view endEditing:YES];
}


- (void) timerFireMethod:(NSTimer *) theTimer
{
    
    NSInteger secondsSinceStart = (NSInteger)[[NSDate date] timeIntervalSinceDate:_startDate];
    _secondsElapsed = secondsSinceStart;
    self.seconds++;
    if (self.seconds == 60) {
        self.minutes++;
        self.seconds = 0;
    }
    if (self.minutes == 60){
        self.hours++;
        self.minutes = 0;
    }
    
    self.secondsLabel.text = [NSString
                              stringWithFormat:@"%02ld", (long)self.seconds];
    self.minutesLabel.text = [NSString
                              stringWithFormat:@"%02ld", (long)self.minutes];
    self.hoursLabel.text = [NSString
                            stringWithFormat:@"%02ld", (long)self.hours];
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSString *errorType = (error.code ==kCLErrorDenied) ? @"ACCESS DENIED": @"Unknown Erroe";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error Getting Location" message:errorType delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}


@end
