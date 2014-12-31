//
//  NLMCTest.h
//  NLMC
//
//  Created by Craig Webster on 31/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CollectionSpecimen;

@interface NLMCTest : NSManagedObject

@property (nonatomic, retain) NSString * catalogueVersion;
@property (nonatomic, retain) NSString * discipline;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * firstPublishedVersion;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * nlmcID;
@property (nonatomic, retain) NSString * nlmcRecommendedDescription;
@property (nonatomic, retain) NSString * snomedConceptID;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSString * alternateTestNames;
@property (nonatomic, retain) NSSet *collectionSpecimen;
@end

@interface NLMCTest (CoreDataGeneratedAccessors)

- (void)addCollectionSpecimenObject:(CollectionSpecimen *)value;
- (void)removeCollectionSpecimenObject:(CollectionSpecimen *)value;
- (void)addCollectionSpecimen:(NSSet *)values;
- (void)removeCollectionSpecimen:(NSSet *)values;

@end
