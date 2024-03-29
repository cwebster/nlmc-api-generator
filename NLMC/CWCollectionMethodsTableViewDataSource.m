//
//  CWCollectionMethodsTableViewDataSource.m
//  NLMC
//
//  Created by Craig Webster on 30/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWCollectionMethodsTableViewDataSource.h"
#import "CollectionMethod.h"

@implementation CWCollectionMethodsTableViewDataSource


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.currentCollectionMethodsArray.count;
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    if(self.currentCollectionMethodsArray.count>row){
        CollectionMethod *currentEntity = [self.currentCollectionMethodsArray objectAtIndex:row];
        return currentEntity.method;
    } else {
        return nil;
    }
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{

}



@end
