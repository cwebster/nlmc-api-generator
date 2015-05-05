//
//  CWNLMCXMLParser.m
//  NLMC
//
//  Created by Craig Webster on 30/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWNLMCXMLParser.h"
#import "CWImportWindowController.h"

@implementation CWNLMCXMLParser

// Constants for the XML element names that will be considered during the parse.
// Declaring these as static constants reduces the number of objects created during the run
// and is less prone to programmer error.
static NSString *kName_NLMC_Test = @"NLMCTest";
static NSString *kName_NLMC_Catalog_version = @"catalogueVersion";
static NSString *kName_NLMC_Requestables = @"NLMCRequestables";
static NSString *kName_NLMC_ID = @"NLMC_ID";
static NSString *kName_FullName = @"FullName";
static NSString *kName_SNOMEDCT = @"SnomedCT";
static NSString *kName_Concept_ID = @"conceptID";
static NSString *kName_SNOMEDCT_NLMC_RecommendedDescription = @"NLMC_RecommendedDescription";
static NSString *kName_CollectedSpecimen = @"CollectedSpecimen";
static NSString *kName_CollectedSpecimen_type = @"type";
static NSString *kName_SNOMEDCT_Concept_ID = @"snomedCTConceptID";
static NSString *kName_CollectedSpecimen_topographyRequired = @"topographyRequired";
static NSString *kName_CollectedSpecimen_morphologyRequired= @"morphologyRequired";
static NSString *kName_CollectionMethod = @"CollectionMethod";
static NSString *kName_CollectionMethod_method = @"name";
static NSString *kName_NLMC_TestMetaData = @"NLMCTestMetaData";
static NSString *kName_NLMC_TestMetaData_status = @"status";
static NSString *kName_NLMC_TestMetaData_version = @"version";
static NSString *kName_NLMC_TestMetaData_firstPublishedVersion = @"firstPublishedVersion";
static NSString *kName_NLMC_TestMetaData_lastModified = @"lastModified";
static NSString *kName_MetaTestNames = @"MetaTestNames";
static NSString *kName_MetaTestNames_AlternateTestName = @"AlternateTestName";
static NSString *kName_MetaTestNames_displayName = @"displayName";
static NSString *kName_Disciplines = @"Disciplines";
static NSString *kName_Discipline = @"Discipline";
static NSString *kName_Discipline_name = @"name";

+ (void)parseXMLFile:(NSURL*)pathToFile {
    
    //Display Import progress window
    CWImportWindowController *importProgressWindow = [[CWImportWindowController alloc]initWithWindowNibName:@"CWImportWindowController"];
    [importProgressWindow.window display];
    [importProgressWindow.window makeKeyAndOrderFront:self];
    
    //Load XML file into parser
    NSError *error;
    NSData * data = [NSData dataWithContentsOfURL:pathToFile];
    
    // tbxml is the xml document object
    TBXML * tbxml = [TBXML tbxmlWithXMLData:data error:&error];
    
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        return;
    } else {
    
        //Set up magical record to do background saves on another thread
        //Inform OS that we cant sleep
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        
        [processInfo disableSuddenTermination];
        [processInfo disableAutomaticTermination:@"Application is currently saving to persistent store"];
        
        // Start of Magical Record save block and start of processing each XML element
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            // If TBXML found a root node, process element and iterate all children
            if (tbxml.rootXMLElement) {
                
                TBXMLElement *root = tbxml.rootXMLElement;
                TBXMLElement *requestables = [TBXML childElementNamed:kName_NLMC_Requestables parentElement:root];
                
                if (requestables) {
                    
                    TBXMLElement * NLMC_Test = [TBXML childElementNamed:kName_NLMC_Test parentElement:requestables];
                    
                    if (NLMC_Test) {
                        // Get a count of the total number of records
                        int j = [self countXMLelementsinTBXMLObject:tbxml parentElement:root childElementName:kName_NLMC_Test];
                        
                        // Set up date progress bar parameters and display number of records to import
                        NSString *str = [NSString stringWithFormat:@"Importing : %1$d records", j];
                        [importProgressWindow.progressTextField setStringValue:str];
                        [importProgressWindow.importProgressIndicator setMaxValue:j];
                        [importProgressWindow.window display];
                        
                        while (NLMC_Test != nil) {
                            
                            NLMCTest* newTest = [NLMCTest MR_createInContext:localContext];
                            newTest.catalogueVersion = [TBXML valueOfAttributeNamed:kName_NLMC_Catalog_version forElement:root];
                            
                            TBXMLElement *NLMC_ID = [TBXML childElementNamed:kName_NLMC_ID parentElement:NLMC_Test];
                            if (NLMC_ID != nil) {
                                // Set the ID
                                newTest.nlmcID = [TBXML textForElement:NLMC_ID];
                            }
                            
                            TBXMLElement *FullName = [TBXML childElementNamed:kName_FullName parentElement:NLMC_Test];
                            if (FullName != nil) {
                                // Set the full name for the test
                                newTest.fullName = [TBXML textForElement:FullName];
                            }
                            
                            TBXMLElement *SNOMEDCT = [TBXML childElementNamed:kName_SNOMEDCT parentElement:NLMC_Test];
                            if (SNOMEDCT != nil) {
                                newTest.snomedConceptID = [TBXML valueOfAttributeNamed:kName_Concept_ID forElement:SNOMEDCT];
                                newTest.nlmcRecommendedDescription = [TBXML valueOfAttributeNamed:kName_SNOMEDCT_NLMC_RecommendedDescription forElement:SNOMEDCT];
                            }
                            
                            
                            // Create collection specimen set enclosing a collection methods set
                            TBXMLElement *CollectedSpecimenElement = [TBXML childElementNamed:kName_CollectedSpecimen parentElement:NLMC_Test];
                            if (CollectedSpecimenElement) {
                                NSSet *collectionSpecimenSet = [[NSMutableSet alloc]init];
                                collectionSpecimenSet = [self processCollectionSpecimenElement:CollectedSpecimenElement localContext:localContext];
                                
                                [newTest addCollectionSpecimen:collectionSpecimenSet];
                            }
                            
                            
                            TBXMLElement *NLMC_TestMetaData = [TBXML childElementNamed:kName_NLMC_TestMetaData parentElement:NLMC_Test];
                            if (NLMC_TestMetaData != nil) {
                                NSString* dateString = [TBXML valueOfAttributeNamed:kName_NLMC_TestMetaData_lastModified forElement:NLMC_TestMetaData];
                                NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                                // this is imporant - we set our input date format to match our input string
                                // if format doesn't match you'll get nil from your string, so be careful
                                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                                NSDate* dateFromString = [[NSDate alloc] init];
                                // voila!
                                dateFromString = [dateFormatter dateFromString:dateString];
                                
                                newTest.status = [TBXML valueOfAttributeNamed:kName_NLMC_TestMetaData_status forElement:NLMC_TestMetaData];
                                newTest.firstPublishedVersion = [TBXML valueOfAttributeNamed:kName_NLMC_TestMetaData_firstPublishedVersion forElement:NLMC_TestMetaData];
                                newTest.lastModified = dateFromString;
                                newTest.version = [TBXML valueOfAttributeNamed:kName_NLMC_TestMetaData_version forElement:NLMC_TestMetaData];
                            }
                            
                            
                            // Create a json string of the alternate testnames.
                            TBXMLElement *MetaTestNamesElement = [TBXML childElementNamed:kName_MetaTestNames parentElement:NLMC_TestMetaData];
                            TBXMLElement *AlternateTestNameElement = [TBXML childElementNamed:kName_MetaTestNames_AlternateTestName parentElement:MetaTestNamesElement];
                            
                            // Set Display name
                            newTest.displayName = [TBXML valueOfAttributeNamed:kName_MetaTestNames_displayName forElement:MetaTestNamesElement];
                            
                            NSData *jsonData = [self concateElementToJson:AlternateTestNameElement elementName:kName_MetaTestNames_AlternateTestName];
                            if (! jsonData) {
                                NSLog(@"Got an error: %@", error);
                            } else {
                                 NSLog(@"Got an name");
                                newTest.alternateTestNames= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                
                            }
                            
                            // Creata a json string of the departments
                            TBXMLElement *Disciplines = [TBXML childElementNamed:kName_Disciplines parentElement:NLMC_TestMetaData];
                            TBXMLElement *DisciplineElement = [TBXML childElementNamed:kName_Discipline parentElement:Disciplines];
                            
                            NSData *jsonDataDisciplines = [self concateAttributeToJson:DisciplineElement attributeName:kName_Discipline_name elementName:kName_Discipline];
                            
                            if (! jsonDataDisciplines) {
                                NSLog(@"Got an error: %@", error);
                            } else {
                                newTest.discipline = [[NSString alloc] initWithData:jsonDataDisciplines encoding:NSUTF8StringEncoding];
                            
                            }
                            
                            
                            // All things have been set
                            // check to see if test already in data base
                            // match on ID, version number and date updated, if already present dont sav
                            
                                                    if (![self isTestAlreadyImported:newTest]) {
                                                        [newTest MR_deleteEntity];
                                                    }

                            [importProgressWindow.importProgressIndicator incrementBy:1];
                            [importProgressWindow.window display];
                            NLMC_Test = [TBXML nextSiblingNamed:kName_NLMC_Test searchFromElement:NLMC_Test];
                        }
                    }
                }
                
            }
        } completion:^(BOOL success, NSError *error) {
            [processInfo enableSuddenTermination];
            [processInfo enableAutomaticTermination:@"Application has finished saving to the persistent store"];
        }];

    
    
    }
    // [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveOnlySelfAndWait];
}

#pragma mark -
#pragma mark - ==== XML Element Processsing Methods ===
#pragma mark -

+(int)countXMLelementsinTBXMLObject:(TBXML *)tbxmlObject parentElement:(TBXMLElement *)parentElement childElementName:(NSString *)childElementName {
    
    TBXMLElement * element = [TBXML childElementNamed:childElementName parentElement:parentElement];
    int i = 0;
    while (element != nil) {
        i++;
        element = [TBXML nextSiblingNamed:childElementName searchFromElement:element];
    }
    return i;
}

+(NSData *)concateElementToJson:(TBXMLElement *)tbxmlElement elementName:(NSString *)elementName  {
    
    NSMutableDictionary *concatedDictionary = [[NSMutableDictionary alloc]init];
    
    int idx = 0;
    
    while (tbxmlElement != nil) {
        NSString *keyIdx = [NSString stringWithFormat:@"%d",idx];
        [concatedDictionary setObject:[TBXML textForElement:tbxmlElement] forKey:keyIdx];
        
        idx++;
        tbxmlElement = [TBXML nextSiblingNamed:elementName searchFromElement:tbxmlElement];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:concatedDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    return jsonData;
    
}


+(NSData *)concateAttributeToJson:(TBXMLElement *)tbxmlElement attributeName:(NSString *)attributeName elementName:(NSString *)elementName {
    
    NSMutableDictionary *concatedDictionary = [[NSMutableDictionary alloc]init];
    
    int idx = 0;
    
    while (tbxmlElement != nil) {
        NSString *keyIdx = [NSString stringWithFormat:@"%d",idx];
        [concatedDictionary setObject:[TBXML valueOfAttributeNamed:attributeName forElement:tbxmlElement] forKey:keyIdx];
        
        idx++;
        
        tbxmlElement = [TBXML nextSiblingNamed:elementName searchFromElement:tbxmlElement];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:concatedDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    return jsonData;
    
}

+(NSSet *)processCollectionSpecimenElement:(TBXMLElement *)collectionSpecimenElement localContext:(NSManagedObjectContext *)localContext {
    NSMutableSet *collectionSpecimenSet = [[NSMutableSet alloc]init];
    
    while (collectionSpecimenElement != nil) {
        
        NSMutableSet *collectionMethodSet = [[NSMutableSet alloc]init];
        
        CollectionSpecimen* newCollectionSpecimen = [CollectionSpecimen MR_createInContext:localContext];
        
        newCollectionSpecimen.type = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_type forElement:collectionSpecimenElement];
        newCollectionSpecimen.snomedConceptID = [TBXML valueOfAttributeNamed:kName_SNOMEDCT_Concept_ID forElement:collectionSpecimenElement];
        newCollectionSpecimen.topographyRequired = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_topographyRequired forElement:collectionSpecimenElement];
        newCollectionSpecimen.morphologyRequired = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_morphologyRequired forElement:collectionSpecimenElement];
        
        
        TBXMLElement *CollectionMethodElement = [TBXML childElementNamed:kName_CollectionMethod parentElement:collectionSpecimenElement];
        while (CollectionMethodElement != nil) {
            
            CollectionMethod* newCollectionMethod = [CollectionMethod MR_createInContext:localContext];
            
            // set the relevant data
            newCollectionMethod.snomedConceptID = [TBXML valueOfAttributeNamed:kName_SNOMEDCT_Concept_ID forElement:CollectionMethodElement];
            newCollectionMethod.method = [TBXML valueOfAttributeNamed:kName_CollectionMethod_method forElement:CollectionMethodElement];
            
            [collectionMethodSet addObject:newCollectionMethod];
            
            CollectionMethodElement = [TBXML nextSiblingNamed:kName_CollectionMethod searchFromElement:CollectionMethodElement];
        }
        
        [newCollectionSpecimen addCollectionMethodsRelationship:collectionMethodSet];
        
        [collectionSpecimenSet addObject:newCollectionSpecimen];
        
        collectionSpecimenElement = [TBXML nextSiblingNamed:kName_CollectedSpecimen searchFromElement:collectionSpecimenElement];
    }

    return collectionSpecimenSet;
    
}


#pragma mark -
#pragma mark - ==== Import Error Checking ===
#pragma mark -

+(BOOL)isTestAlreadyImported:(NLMCTest *) nlmcTestToCheck {
    
    NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];

    // Set example predicate and sort orderings...
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(nlmcID = %@) AND (version = %@) AND (lastModified = %@)", nlmcTestToCheck.nlmcID, nlmcTestToCheck.version, nlmcTestToCheck.lastModified];
    NSArray *array = [NLMCTest MR_findAllWithPredicate:predicate inContext:myNewContext];

   
    if ([array count] == 0)
    {
        return TRUE;
    }
    
    return FALSE;
}


#pragma mark -
#pragma mark - ==== General TBXML Functions ===
#pragma mark -


// this method will process an unknown XML formal and log all elements and attributes
+ (void) traverseElement:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSLog(@"element name: %@",[TBXML elementName:element]);
        
        // Obtain first attribute from element
        TBXMLAttribute * attribute = element->firstAttribute;
        
        // if attribute is valid
        while (attribute) {
            // Display name and value of attribute to the log window
            NSLog(@"element name: %@-> attribute name: %@ = attribute value: %@",  [TBXML elementName:element],
                  [TBXML attributeName:attribute],
                  [TBXML attributeValue:attribute]);
            
            // Obtain the next attribute
            attribute = attribute->next;
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseElement:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));  
}



@end
