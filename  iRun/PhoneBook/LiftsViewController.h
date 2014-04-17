//
//  LiftsViewController.h
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
@interface LiftsViewController : UIViewController <UIAccelerometerDelegate>

    

@property (weak, nonatomic) IBOutlet UILabel *liftsLabel;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;


@end
