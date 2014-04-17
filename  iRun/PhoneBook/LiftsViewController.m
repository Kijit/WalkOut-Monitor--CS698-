//
//  LiftsViewController.m
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//
#import "LiftsViewController.h"
#import "Record.h"
#import "AppDelegate.h"
#define X_DIR  0
#define Y_DIR  1
#define Z_DIR  2
#define HIGHPASS_FILTER 0.5
#define kFilteringFactor 0.6

@interface LiftsViewController ()


@end
static int lifts;
@implementation LiftsViewController
    UIAccelerationValue accelerationArray[3], accelX, accelY, accelZ;


UIAccelerometer *accelerometer;
@synthesize liftsLabel;
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
	// Do any additional setup after loading the view.
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)btnClick:(id)sender{
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = 1/600;
    accelerometer.delegate = self;
}
-(IBAction)saveButton:(id)sender{
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    newEntry.lifts = [NSString stringWithFormat:@"%d",lifts];
    newEntry.date  = dateString;
    newEntry.avgspeed = [NSString stringWithFormat:@"0"];
    newEntry.calories = [NSString stringWithFormat:@"0"];
    newEntry.distance = [NSString stringWithFormat:@"0"];
    newEntry.seconds = [NSString stringWithFormat:@"00:00:00"];
    NSError *error;
    
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [self.view endEditing:YES];
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    float z =0,y=0;
    float x=0;
    // High pass filter
    accelerationArray[X_DIR] = acceleration.x - ((acceleration.x * HIGHPASS_FILTER) + (accelerationArray[X_DIR] * (1.0 - HIGHPASS_FILTER)));
    accelerationArray[Y_DIR] = acceleration.y - ((acceleration.y * HIGHPASS_FILTER) + (accelerationArray[Y_DIR] * (1.0 - HIGHPASS_FILTER)));
    accelerationArray[Z_DIR] = acceleration.z - ((acceleration.z * HIGHPASS_FILTER) + (accelerationArray[Z_DIR] * (1.0 - HIGHPASS_FILTER)));
    
    // Was the device moved away or toward you...
    if (z - accelZ > 0.5 || z -accelZ < -0.5)
    {
        // steps=steps+1;
    }
    // Was the device moved up or down
    else if (y - accelerationArray[Y_DIR] > 0.9 || y - accelerationArray[Y_DIR] < -0.9)
    {
        
    }
    
    // Was the device moved left or right
    else if (x - accelerationArray[X_DIR] > 0.2)// || x - accelerationArray[X_DIR] < -0.2)
    {
        lifts=lifts+1;
        
    }
    liftsLabel.text = [NSString stringWithFormat:@"%d",lifts];
}
-(IBAction)backBtn:(id)sender{
    self.liftsLabel.text=0;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:lifts forKey:@"IntegerKey"];
    [defaults synchronize];
    [self dismissViewControllerAnimated:YES completion:Nil];
    [UIAccelerometer sharedAccelerometer].delegate = nil;
}

@end
