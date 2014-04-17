//
//  Record.h
//  iRun
//
//  Created by Nanda Kishore on 12/15/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSString * calories;
@property (nonatomic, retain) NSString * seconds;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * avgspeed;
@property (nonatomic, retain) NSString * lifts;
@property (nonatomic, retain) NSString * distance;
@end
