//
//  CollectionMethod.h
//  NLMC
//
//  Created by Craig Webster on 31/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CollectionSpecimen;

@interface CollectionMethod : NSManagedObject

@property (nonatomic, retain) NSString * method;
@property (nonatomic, retain) NSString * snomedConceptID;
@property (nonatomic, retain) CollectionSpecimen *collectionSpecimenRelationship;

@end
