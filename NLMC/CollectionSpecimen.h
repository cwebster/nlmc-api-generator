//
//  CollectionSpecimen.h
//  NLMC
//
//  Created by Craig Webster on 18/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLMCTest;

@interface CollectionSpecimen : NSManagedObject

@property (nonatomic, retain) NSString * morphologyRequired;
@property (nonatomic, retain) NSString * snomedConceptID;
@property (nonatomic, retain) NSString * topographyRequired;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NLMCTest *nlmcTest;

@end
