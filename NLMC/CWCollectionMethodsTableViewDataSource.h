//
//  CWCollectionMethodsTableViewDataSource.h
//  NLMC
//
//  Created by Craig Webster on 30/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CWCollectionMethodsTableViewDataSource :  NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (strong, readwrite) NSArray *currentCollectionMethodsArray;

@end
