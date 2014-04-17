//
//  MainViewController.h
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UIButton *liftsButton;
@property (weak, nonatomic) IBOutlet UIButton *compareButton;
@property (weak, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UIButton *saveWeight;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
