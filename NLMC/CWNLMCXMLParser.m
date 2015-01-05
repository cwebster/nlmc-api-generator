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
static NSString *kName_NLMC_Test = @"NLMC_Test";
static NSString *kName_NLMC_Catalog_version = @"catalogueVersion";
static NSString *kName_NLMC_ID = @"NLMC_ID";
static NSString *kName_FullName = @"FullName";
static NSString *kName_SNOMEDCT = @"SNOMEDCT";
static NSString *kName_Concept_ID = @"Concept_ID";
static NSString *kName_SNOMEDCT_NLMC_RecommendedDescription = @"NLMC_RecommendedDescription";
static NSString *kName_CollectedSpecimen = @"CollectedSpecimen";
static NSString *kName_CollectedSpecimen_type = @"type";
static NSString *kName_SNOMEDCT_Concept_ID = @"SNOMEDCT_Concept_ID";
static NSString *kName_CollectedSpecimen_topographyRequired = @"topographyRequired";
static NSString *kName_CollectedSpecimen_morphologyRequired= @"morphologyRequired";
static NSString *kName_CollectionMethod = @"CollectionMethod";
static NSString *kName_CollectionMethod_method = @"method";
static NSString *kName_NLMC_TestMetaData = @"NLMC_TestMetaData";
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
    
    CWImportWindowController *importProgressWindow = [[CWImportWindowController alloc]initWithWindowNibName:@"CWImportWindowController"];
    [importProgressWindow.window display];
    [importProgressWindow.window makeKeyAndOrderFront:self];
    
    NSError *error;
    NSData * data = [NSData dataWithContentsOfURL:pathToFile];
    TBXML * tbxml = [TBXML tbxmlWithXMLData:data error:&error];
    
    
    if (error) {
        NSLog(@"%@ %@", [error localizedDescription], [error userInfo]);
        return;
    } else {
        // If TBXML found a root node, process element and iterate all children
        if (tbxml.rootXMLElement) {
            
            TBXMLElement *root = tbxml.rootXMLElement;
            
            if (root) {
                TBXMLElement * NLMC_Test = [TBXML childElementNamed:kName_NLMC_Test parentElement:root];
                
                if (NLMC_Test) {
                    int i = 0;
                    
                    while (NLMC_Test != nil) {
                        i++;
                        NLMC_Test = [TBXML nextSiblingNamed:kName_NLMC_Test searchFromElement:NLMC_Test];
                    }
                
                
                [importProgressWindow.progressTextField setStringValue:@"Importing Records"];
                [importProgressWindow.importProgressIndicator setMaxValue:i];
                [importProgressWindow.window display];
                }
            }
            
            
            if (root) {
                TBXMLElement * NLMC_Test = [TBXML childElementNamed:kName_NLMC_Test parentElement:root];
                
                [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"MyDatabase.sqlite"];
                NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
                
                if (NLMC_Test) {
                   
                    while (NLMC_Test != nil) {
                        
                        NLMCTest* newTest = [NLMCTest MR_createInContext:moc];
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
                        
                        TBXMLElement *CollectedSpecimenElement = [TBXML childElementNamed:kName_CollectedSpecimen parentElement:NLMC_Test];
                        if (CollectedSpecimenElement) {
                            
                            NSMutableSet *collectionSpecimenSet = [[NSMutableSet alloc]init];

                            
                            while (CollectedSpecimenElement != nil) {
                                
                                NSMutableSet *collectionMethodSet = [[NSMutableSet alloc]init];
                                
                                NSEntityDescription* newCollectionSpecimenEntityDescription = [NSEntityDescription entityForName:@"CollectionSpecimen" inManagedObjectContext:moc];
                                
                                CollectionSpecimen* newCollectionSpecimen = [[CollectionSpecimen alloc] initWithEntity:newCollectionSpecimenEntityDescription insertIntoManagedObjectContext:moc];
                                
                                newCollectionSpecimen.type = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_type forElement:CollectedSpecimenElement];
                                newCollectionSpecimen.snomedConceptID = [TBXML valueOfAttributeNamed:kName_SNOMEDCT_Concept_ID forElement:CollectedSpecimenElement];
                                
                                newCollectionSpecimen.topographyRequired = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_topographyRequired forElement:CollectedSpecimenElement];
                                
                                newCollectionSpecimen.morphologyRequired = [TBXML valueOfAttributeNamed:kName_CollectedSpecimen_morphologyRequired forElement:CollectedSpecimenElement];
                                
                                
                                
                                TBXMLElement *CollectionMethodElement = [TBXML childElementNamed:kName_CollectionMethod parentElement:CollectedSpecimenElement];
                                
                                while (CollectionMethodElement != nil) {
                                    
                                    NSEntityDescription* newCollectionMethodEntityDescription = [NSEntityDescription entityForName:@"CollectionMethod" inManagedObjectContext:moc];
                                    
                                    CollectionMethod* newCollectionMethod = [[CollectionMethod alloc] initWithEntity:newCollectionMethodEntityDescription insertIntoManagedObjectContext:moc];
                                    
                                    // set the relevant data
                                    newCollectionMethod.snomedConceptID = [TBXML valueOfAttributeNamed:kName_SNOMEDCT_Concept_ID forElement:CollectionMethodElement];
                                    
                                    newCollectionMethod.method = [TBXML valueOfAttributeNamed:kName_CollectionMethod_method forElement:CollectionMethodElement];
                                    
                                    [collectionMethodSet addObject:newCollectionMethod];
                                    
                                    CollectionMethodElement = [TBXML nextSiblingNamed:kName_CollectionMethod searchFromElement:CollectionMethodElement];
                                }
                                
                                [newCollectionSpecimen addCollectionMethodsRelationship:collectionMethodSet];

                                [collectionSpecimenSet addObject:newCollectionSpecimen];
                                
                                CollectedSpecimenElement = [TBXML nextSiblingNamed:kName_CollectedSpecimen searchFromElement:CollectedSpecimenElement];
                            }
                            
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
                        
                        newTest.displayName = [TBXML valueOfAttributeNamed:kName_MetaTestNames_displayName forElement:MetaTestNamesElement];
                        
                        NSMutableDictionary *alternateTestNamesDictionary = [[NSMutableDictionary alloc]init];
                        
                        int idx = 0;
                        
                        while (AlternateTestNameElement != nil) {
                            NSString *keyIdx = [NSString stringWithFormat:@"%d",idx];
                            [alternateTestNamesDictionary setObject:[TBXML textForElement:AlternateTestNameElement]forKey:keyIdx];
                            
                            idx++;
                            AlternateTestNameElement = [TBXML nextSiblingNamed:kName_MetaTestNames_AlternateTestName searchFromElement:AlternateTestNameElement];
                        }
                        
                        NSError *error;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:alternateTestNamesDictionary
                                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                             error:&error];
                        
                        if (! jsonData) {
                            NSLog(@"Got an error: %@", error);
                        } else {
                            newTest.alternateTestNames= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        }
                        
                        
                        
                        // Creata a json string of the departments
                        TBXMLElement *Disciplines = [TBXML childElementNamed:kName_Disciplines parentElement:NLMC_TestMetaData];
                        
                        TBXMLElement *DisciplineElement = [TBXML childElementNamed:kName_Discipline parentElement:Disciplines];
                        
                        NSMutableDictionary *disciplinesDictionary = [[NSMutableDictionary alloc]init];
                        
                        idx = 0;
                        
                        while (DisciplineElement != nil) {
                            NSString *keyIdx = [NSString stringWithFormat:@"%d",idx];
                            [disciplinesDictionary setObject:[TBXML valueOfAttributeNamed:kName_Discipline_name forElement:DisciplineElement] forKey:keyIdx];
                            
                            idx++;
                            DisciplineElement = [TBXML nextSiblingNamed:kName_Discipline searchFromElement:DisciplineElement];
                        }
                        
                        NSData *jsonDataDisciplines = [NSJSONSerialization dataWithJSONObject:disciplinesDictionary
                                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                             error:&error];
                        
                        if (! jsonDataDisciplines) {
                            NSLog(@"Got an error: %@", error);
                        } else {
                            newTest.discipline = [[NSString alloc] initWithData:jsonDataDisciplines encoding:NSUTF8StringEncoding];
                        }
                        
                        
                        // All things have been set
                        // check to see if test already in data base
                        // match on ID, version number and date updated, if already present dont sav
                        
                        if ([self isTestAlreadyImported:newTest]) {
                            NSLog(@"Saving");
                            [moc MR_saveOnlySelfAndWait];
                        } else {
                            // NSLog(@"Already in database not saving");
                        }
                        
                        
                        // [moc MR_saveOnlySelfAndWait];
                        [importProgressWindow.importProgressIndicator incrementBy:1];
                        [importProgressWindow.window display];
                        
                        
                        
                        
                        NLMC_Test = [TBXML nextSiblingNamed:kName_NLMC_Test searchFromElement:NLMC_Test];
                    }
                }
            }
            
        }
        
    }
}

+(BOOL)isTestAlreadyImported:(NLMCTest *) nlmcTestToCheck {
    
    NSManagedObjectContext *moc = [NSManagedObjectContext MR_contextForCurrentThread];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"NLMCTest" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(nlmcID = %@) AND (version = %@) AND (lastModified = %@)", nlmcTestToCheck.nlmcID, nlmcTestToCheck.version, nlmcTestToCheck.lastModified];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"nlmcID" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        return TRUE;
    }
    
    return FALSE;
    
    
    
}

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
