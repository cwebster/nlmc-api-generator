//
//  CWCollectionSpecimenDataSource.m
//  NLMC
//
//  Created by Craig Webster on 30/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWCollectionSpecimenDataSource.h"
#import "CollectionSpecimen.h"

@implementation CWCollectionSpecimenDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.currentSpecimensMethodsArray.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    //NSLog(@"Object at index: %@", [self.currentSpecimensMethodsArray objectAtIndex:row]);
    
    CollectionSpecimen *currentEntity = [self.currentSpecimensMethodsArray objectAtIndex:row];
    return currentEntity.type;
    
    //return [self.currentCollectionMethodsArray objectAtIndex:row];
    
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    NSLog(@"Row changed");
}

@end
