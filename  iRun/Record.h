//
//  Record.h
//  Project
//
//  Created by Nanda Kishore on 12/8/13.
//  Copyright (c) 2013 Codigator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Record : NSManagedObject

@property (nonatomic, retain) NSNumber * seconds;
@property (nonatomic, retain) NSString * calories;

@end
