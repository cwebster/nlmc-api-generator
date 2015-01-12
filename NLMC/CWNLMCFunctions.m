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

    }

    return self;
}

+ (NSString *)createTestNamesJSON{
    
    
    NSArray *nlmcTests = [NLMCTest MR_findAll];
    NSMutableDictionary *tests = [[NSMutableDictionary alloc]init];
    
    [nlmcTests enumerateObjectsUsingBlock:^(NLMCTest *nlmcTest,
                                              NSUInteger idx,
                                              BOOL *stop) {
        NSMutableDictionary *details = [[NSMutableDictionary alloc]init];
        
        NSString *snomedKey = nlmcTest.snomedConceptID;
        NSString *description = nlmcTest.nlmcRecommendedDescription;
        NSString *nlmcID = nlmcTest.nlmcID;
        NSString *disciplines = nlmcTest.discipline;
        NSString *alternateNames = nlmcTest.alternateTestNames;
        
        [details setObject:description forKey:@"description"];
        [details setObject:nlmcID forKey:@"nlmcID"];
        [details setObject:disciplines forKey:@"disciplines"];
        [details setObject:alternateNames forKey:@"alternateNames"];
        
        [tests setObject:details forKey:snomedKey];

        
    }];
    
    return [self bv_jsonStringWithPrettyPrint:YES dictionary:tests];
    
}

+(NSString *)createCollectionSpecimenJSON {
    
    NSFetchRequest *peopleRequest = [CollectionSpecimen MR_requestAll];
    [peopleRequest setReturnsDistinctResults:NO];
    [peopleRequest setReturnsObjectsAsFaults:NO];
    
    NSArray *collectionSpecimens = [CollectionSpecimen MR_executeFetchRequest:peopleRequest];
    
    NSMutableDictionary *collectionSpecimensDictionary = [[NSMutableDictionary alloc]init];
    
    [collectionSpecimens enumerateObjectsUsingBlock:^(CollectionSpecimen *collSpec,
                                            NSUInteger idx,
                                            BOOL *stop) {
        
        NSMutableDictionary *collectionSpecimensAndMethodsDictionary = [[NSMutableDictionary alloc]init];
        NSString *snomedConceptID = collSpec.snomedConceptID;
        NSString *type = collSpec.type;
        NSMutableString *snomedCTmethod = [[NSMutableString alloc]init];
        NSMutableString *collectionMethodName = [[NSMutableString alloc]init];
        NSSet *methods = collSpec.collectionMethodsRelationship;
        
        [methods enumerateObjectsUsingBlock:^(id x, BOOL *stop){
            if ([x isKindOfClass:[CollectionMethod class]]) {
                CollectionMethod *method = x;
                [collectionMethodName setString:method.method];
                [snomedCTmethod setString:method.snomedConceptID];
                
                [collectionSpecimensAndMethodsDictionary setObject:type forKey:@"collectionSpecimenType"];
                [collectionSpecimensAndMethodsDictionary setObject:collectionMethodName forKey:@"collectionMethodName"];
                [collectionSpecimensAndMethodsDictionary setObject:snomedConceptID forKey:@"collectionSpecimenSnomedConcept"];
                
            }
        
        }];
        [collectionSpecimensDictionary setObject:collectionSpecimensAndMethodsDictionary forKey:snomedCTmethod];
        
        
        
    }];
     
    return [self bv_jsonStringWithPrettyPrint:YES dictionary:collectionSpecimensDictionary];
    
}

+(NSString *) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint dictionary:(NSDictionary *)dictionary{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end
