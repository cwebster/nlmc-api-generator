//
//  CWNLMCEntityTest.m
//  NLMC
//
//  Created by Craig Webster on 21/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "NLMCTest.h"

@interface CWNLMCEntityTest : XCTestCase

@end

@implementation CWNLMCEntityTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
   	[MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [MagicalRecord cleanUp];
    [super tearDown];
}

- (void)testExample {

    NLMCTest *testEntity = [NLMCTest MR_createEntity];
    XCTAssertNotNil(testEntity, @"NLMC Test Entity Not Nil");
                   
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
