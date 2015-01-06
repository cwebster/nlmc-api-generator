//
//  CWNLMCXMLParser.h
//  NLMC
//
//  Created by Craig Webster on 30/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "TBXML.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "NLMCTest.h"
#import "CollectionSpecimen.h" 
#import "CollectionMethod.h"



@interface CWNLMCXMLParser : NSObject

+ (void) parseXMLFile:(NSURL*)pathToFile;
+ (void) traverseElement:(TBXMLElement *)element;

@end
