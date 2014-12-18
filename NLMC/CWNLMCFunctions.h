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



@interface CWNLMCFunctions : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSXMLParser* parser;
@property (nonatomic, retain) NLMCTest* currentTest;
@property (nonatomic, retain) NSMutableString* currentNodeContent;
@property (nonatomic, retain) NSManagedObjectContext* moc;
@property (nonatomic, retain) NSMutableSet *collectionMethodSet;
@property (nonatomic, retain) NSMutableSet *collectionSpecimenSet;
@property (nonatomic, retain) NSString *catalogueVersion;

+ (NSMutableDictionary* )getTestNamesJSON:(NSURL*)jsonFileUrl;
- (void)parseXMLFile:(NSURL*)pathToFile;

@end
