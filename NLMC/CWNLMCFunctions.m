//
//  WebsterNLMCFunctions.m
//  NLMC
//
//  Created by Craig Webster on 05/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWNLMCFunctions.h"

@implementation CWNLMCFunctions

- (id)init
{
    if (self == [super init]) {

        self.moc = [NSManagedObjectContext MR_contextForCurrentThread];
        self.collectionMethodSet = [[NSMutableSet alloc] init];
        self.collectionSpecimenSet = [[NSMutableSet alloc] init];
    }

    return self;
}

- (void)parseXMLFile:(NSURL*)pathToFile
{
    _parser = [[NSXMLParser alloc] initWithContentsOfURL:pathToFile];
    [_parser setDelegate:self];

    [_parser parse];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName
       namespaceURI:(NSString*)namespaceURI
      qualifiedName:(NSString*)qualifiedName
         attributes:(NSDictionary*)attributeDict
{
    if ([elementName isEqualToString:@"nlmc:NLMC_Catalogue"]) {

        [self processNLMCCatalogueDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"NLMC_Test"]) {
        // after 1st line will need to create a new test entity here
        //create a new NLMC test entity
        if (self.currentTest == nil) {
            NLMCTest* newTest = [NLMCTest MR_createInContext:self.moc];
            self.currentTest = newTest;
        }

    }

    //process the elements in the NLMC catalog

    if ([elementName isEqualToString:@"SNOMEDCT"]) {
        [self processSNOMEDCTAttributeDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"CollectedSpecimen"]) {
        [self processCollectionSpecimenAttributeDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"CollectionMethod"]) {

        [self processCollectionMethodsAttributeDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"NLMC_TestMetaData"]) {
        [self processTestMetaDataAttributeDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"MetaTestNames"]) {

        [self processTestNamesAttributeDictionary:attributeDict];
    }

    if ([elementName isEqualToString:@"Discipline"]) {
        [self processDisciplinesAttributeDictionary:attributeDict];
    }
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName
     namespaceURI:(NSString*)namespaceURI
    qualifiedName:(NSString*)qName
{

    if ([elementName isEqualToString:@"FullName"]) {

        // set the full name of the test
        _currentTest.FullName = _currentNodeContent;
    }

    if ([elementName isEqualToString:@"NLMC_ID"]) {

        // set the ID of the test
        _currentTest.nlmcID = _currentNodeContent;
    }

    // Discipline is the last element of an NLMC test so ending this will create object
    if ([elementName isEqualToString:@"Discipline"]) {
        // Need to do something?
        self.currentTest.catalogueVersion = self.catalogueVersion;
        self.currentTest.collectionSpecimen = self.collectionSpecimenSet;

        //[self.moc MR_saveOnlySelfAndWait];

        //empty all objects form collection and specimen set
//        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
//        [processInfo disableSuddenTermination];
//        [processInfo disableAutomaticTermination:@"Application is currently saving to persistent store"];
//        
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        
//            
//        } completion:^(BOOL success, NSError *error) {
//            [processInfo enableSuddenTermination];
//            [processInfo enableAutomaticTermination:@"Application has finished saving to the persistent store"];
//        }];
        
        [self.collectionMethodSet removeAllObjects];
        [self.collectionSpecimenSet removeAllObjects];
        self.currentTest = nil;
    }
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string
{
    _currentNodeContent = (NSMutableString*)[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSMutableDictionary*)getTestNamesJSON:(NSURL*)jsonFileUrl
{
    NSData* jsonData = [[NSData alloc] initWithContentsOfURL:jsonFileUrl];

    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSDictionary* nlmcCatalog = [json objectForKey:@"nlmc:NLMC_Catalogue"];
    NSArray* nlmcTests = [nlmcCatalog objectForKey:@"NLMC_Test"];

    NSMutableDictionary* entry = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* apiTests = [[NSMutableDictionary alloc] init];

    [nlmcTests enumerateObjectsUsingBlock:^(NSDictionary* object, NSUInteger idx, BOOL* stop) {
        // do something with object
        
        NSDictionary *sno = [object objectForKey:@"SNOMEDCT"];
        NSDictionary *met = [object objectForKey:@"NLMC_TestMetaData"];
        NSDictionary *alt = [met objectForKey:@"MetaTestNames"];
        NSArray *collection = [object objectForKey:@"CollectedSpecimen"];
        
        [entry setValue:[object objectForKey:@"FullName"] forKey:@"FullName"];
        [entry setValue:[object objectForKey:@"NLMC_ID"] forKey:@"NLMC_ID"];
        [entry setValue:[sno objectForKey:@"-Concept_ID"] forKey:@"SNOMED_CONCEPT_ID"];
        [entry setValue:[sno objectForKey:@"-NLMC_RecommendedDescription"] forKey:@"NLMC_RecommendedDescription"];
        [entry setValue:[alt objectForKey:@"-displayName"] forKey:@"displayName"];
        [entry setValue:[alt objectForKey:@"AlternateTestName"] forKey:@"AlternateTestName"];
        [entry setValue:collection forKey:@"CollectionSpecimens"];
        
        //deep copy of entry
        NSDictionary* newDict = [NSKeyedUnarchiver unarchiveObjectWithData:
                                [NSKeyedArchiver archivedDataWithRootObject:entry]];
        
        [apiTests setValue:newDict forKey:[object objectForKey:@"FullName"]] ;

    }];

    return apiTests;
}

#pragma mark -
#pragma mark - ==== Process XML Attribute Dictionary ===
#pragma mark -

- (void)processNLMCCatalogueDictionary:(NSDictionary*)nlmcCatalogueDictionary
{
    self.catalogueVersion = [nlmcCatalogueDictionary valueForKey:@"catalogueVersion"];
}

- (void)processSNOMEDCTAttributeDictionary:(NSDictionary*)snomedctAttributeDictionary
{
    self.currentTest.nlmcRecommendedDescription = [snomedctAttributeDictionary valueForKey:@"NLMC_RecommendedDescription"];
    self.currentTest.snomedConceptID = [snomedctAttributeDictionary valueForKey:@"Concept_ID"];
}

- (void)processTestMetaDataAttributeDictionary:(NSDictionary*)testMetaDataAttributeDictionary
{

    NSString* dateString = [testMetaDataAttributeDictionary valueForKey:@"lastModified"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];

    self.currentTest.firstPublishedVersion = [testMetaDataAttributeDictionary valueForKey:@"firstPublishedVersion"];

    self.currentTest.lastModified = dateFromString;

    self.currentTest.status = [testMetaDataAttributeDictionary valueForKey:@"status"];

    self.currentTest.version = [testMetaDataAttributeDictionary valueForKey:@"version"];
}

- (void)processDisciplinesAttributeDictionary:(NSDictionary*)disciplinesAttributeDictionary
{

    self.currentTest.discipline = [disciplinesAttributeDictionary valueForKey:@"name"];
}

- (void)processCollectionSpecimenAttributeDictionary:(NSDictionary*)collectionSpecimensAttributeDictionary
{
 
    NSEntityDescription* newCollectionSpecimenEntityDescription = [NSEntityDescription entityForName:@"CollectionSpecimen" inManagedObjectContext:self.moc];
    
    CollectionSpecimen* newCollectionSpecimen = [[CollectionSpecimen alloc] initWithEntity:newCollectionSpecimenEntityDescription insertIntoManagedObjectContext:self.moc];
    
    // set the relevant data
    newCollectionSpecimen.snomedConceptID = [collectionSpecimensAttributeDictionary valueForKey:@"SNOMEDCT_Concept_ID"];
    newCollectionSpecimen.morphologyRequired = [collectionSpecimensAttributeDictionary valueForKey:@"morphologyRequired"];
    newCollectionSpecimen.topographyRequired = [collectionSpecimensAttributeDictionary valueForKey:@"topographyRequired"];
    newCollectionSpecimen.type = [collectionSpecimensAttributeDictionary valueForKey:@"type"];
    
    [self.collectionSpecimenSet addObject:newCollectionSpecimen];
    
}

- (void)processCollectionMethodsAttributeDictionary:(NSDictionary*)collectionMethodsAttributeDictionary
{
    NSEntityDescription* newCollectionMethodEntityDescription = [NSEntityDescription entityForName:@"CollectionMethod" inManagedObjectContext:self.moc];

    CollectionMethod* newCollectionMethod = [[CollectionMethod alloc] initWithEntity:newCollectionMethodEntityDescription insertIntoManagedObjectContext:self.moc];

    // set the relevant data
    newCollectionMethod.snomedConceptID = [collectionMethodsAttributeDictionary valueForKey:@"SNOMEDCT_Concept_ID"];
    newCollectionMethod.method = [collectionMethodsAttributeDictionary valueForKey:@"method"];

    [self.collectionMethodSet addObject:newCollectionMethod];
}

- (void)processTestNamesAttributeDictionary:(NSDictionary*)metaTestNamesAttributeDictionary
{

    self.currentTest.displayName = [metaTestNamesAttributeDictionary valueForKey:@"displayName"];

    NSLog(@"Test: %@", [metaTestNamesAttributeDictionary valueForKey:@"displayName"]);
}

@end
