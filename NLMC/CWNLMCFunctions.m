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

+ (void)createTestNamesJSON{
    
    NSArray *testNames = [NLMCTest MR_findAll];
    
    
}


@end
