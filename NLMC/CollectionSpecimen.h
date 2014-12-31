//
//  CollectionSpecimen.h
//  NLMC
//
//  Created by Craig Webster on 31/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CollectionMethod, NLMCTest;

@interface CollectionSpecimen : NSManagedObject

@property (nonatomic, retain) NSString * morphologyRequired;
@property (nonatomic, retain) NSString * snomedConceptID;
@property (nonatomic, retain) NSString * topographyRequired;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *collectionMethodsRelationship;
@property (nonatomic, retain) NLMCTest *nlmcTestRelationship;
@end

@interface CollectionSpecimen (CoreDataGeneratedAccessors)

- (void)addCollectionMethodsRelationshipObject:(CollectionMethod *)value;
- (void)removeCollectionMethodsRelationshipObject:(CollectionMethod *)value;
- (void)addCollectionMethodsRelationship:(NSSet *)values;
- (void)removeCollectionMethodsRelationship:(NSSet *)values;

@end
