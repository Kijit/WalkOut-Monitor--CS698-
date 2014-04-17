//
//  MainViewController.m
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import "MainViewController.h"
#import "Record.h"
#import "AppDelegate.h"
#import "LiftsViewController.h"
@class LiftsViewController;
@interface MainViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber1;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber2;
@property (weak, nonatomic) IBOutlet UITextField *cityTextfield;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (weak ,nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak ,nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak ,nonatomic) IBOutlet UILabel *henceLabel;
@property (nonatomic, strong) NSTimer *secondsTimer;
@property NSDate *startDate;
@property float calories;
@property NSString *calo;
@property NSInteger secondsElapsed;
- (IBAction)startBtn:(id)sender;
-(IBAction)stopBtn:(id)sender;
- (IBAction)addPhoneBookEntry:(id)sender;
- (IBAction)showPhoneBook:(id)sender;
@property NSInteger seconds, minutes, hours;
@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _weightField.hidden=true;
    _saveWeight.hidden=true;
    _weightLabel.hidden=true ;
    //1
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    //2
    self.managedObjectContext = appDelegate.managedObjectContext;
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *fetchDefaults = [NSUserDefaults standardUserDefaults];
    NSString *weight = [fetchDefaults objectForKey:@"MessageKey"];
    
    if(weight ==nil){
        _compareButton.hidden=true;
        _runButton.hidden=true;
        _liftsButton.hidden=true;
        _weightField.hidden=false;
        _saveWeight.hidden=false;
        _weightLabel.hidden = false ;
    }
    else{
        _compareButton.hidden=false;
        _runButton.hidden=false;
        _liftsButton.hidden=false;
        _weightField.hidden=true;
        _saveWeight.hidden=true;
        _weightLabel.hidden=true;
    }
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
                                stringWithFormat:@"%02d", self.seconds];
    self.minutesLabel.text = [NSString
                                stringWithFormat:@"%02d", self.minutes];
    self.hoursLabel.text = [NSString
                              stringWithFormat:@"%02d", self.hours];

}
- (IBAction)saveTheButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *weight = _weightField.text;
    [defaults setObject:weight forKey:@"MessageKey"];
    [defaults synchronize];
    _compareButton.hidden=false;
    _runButton.hidden=false;
    _liftsButton.hidden=false;
    _weightField.hidden=true;
    _saveWeight.hidden=true;
    [_weightField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)startBtn:(id)sender{
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
}
-(IBAction)stopBtn:(id)sender{
    [_secondsTimer invalidate];
   // _henceLabel.text = [NSString stringWithFormat:@"%d", _secondsElapsed];
    float k = 1.25 * 25;
    _calories = (50 * 0.5 * k);
    _calo= [NSString stringWithFormat:@"%f",_calories];
    _henceLabel.text = [NSString stringWithFormat:@"%f", _calories];
}

- (IBAction)addPhoneBookEntry:(id)sender
{
        //  1
    Record * newEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                                      inManagedObjectContext:self.managedObjectContext];
    //  2
    //newEntry.firstname = self.firstNameTextfield.text;
    //newEntry.lastname = self.lastNameTextfield.text;
    //newEntry.city= self.secondsLabel.text;
    
   // newEntry.seconds=self.secondsLabel.text;
    //newEntry.seconds=;
    newEntry.calories=self.henceLabel.text;
    
    //  3
    
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    //  4
    self.firstNameTextfield.text = @"";
    self.lastNameTextfield.text = @"";
    self.cityTextfield.text = @"";
    self.phoneNumber1.text = @"";
    self.phoneNumber2.text = @"";
    //  5
    
    [self.view endEditing:YES];
    
}

- (IBAction)showPhoneBook:(id)sender
{
  
}


#pragma  mark - UITextfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([textField isEqual:self.firstNameTextfield]) {
    [self.lastNameTextfield becomeFirstResponder];
  } else if ([textField isEqual:self.lastNameTextfield]) {
    [self.cityTextfield becomeFirstResponder];
  } else if ([textField isEqual:self.cityTextfield]) {
    [self.phoneNumber1 becomeFirstResponder];
  } else if ([textField isEqual:self.phoneNumber1]) {
    [self.phoneNumber2 becomeFirstResponder];
  } else if ([textField isEqual:self.phoneNumber2]) {
    [self.phoneNumber2 resignFirstResponder];
    [self addPhoneBookEntry:Nil];
  } 
  return YES;
}
@end
