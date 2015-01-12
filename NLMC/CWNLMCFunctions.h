//
//  WebsterNLMCFunctions.h
//  NLMC
//
//  Created by Craig Webster on 05/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NLMCTest.h"
#import "CollectionMethod.h"
#import "CollectionSpecimen.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>



@interface CWNLMCFunctions : NSObject

@property (nonatomic, retain) NSManagedObjectContext* moc;

+ (NSString *)createTestNamesJSON;
+ (NSString *)createCollectionSpecimenJSON;


@end
