//
//  CollectionMethod.h
//  NLMC
//
//  Created by Craig Webster on 18/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NLMCTest;

@interface CollectionMethod : NSManagedObject

@property (nonatomic, retain) NSString * snomedConceptID;
@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NLMCTest *nlmcRelationship;

@end
