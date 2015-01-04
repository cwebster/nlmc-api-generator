//
//  ViewController.m
//  NLMC
//
//  Created by Craig Webster on 07/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWMainViewController.h"
#import "CWNLMCFunctions.h"
#import "CWFileUtilities.h"

@implementation CWMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set up core data stack
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"MyDatabase.sqlite"];
    self.moc = [NSManagedObjectContext MR_contextForCurrentThread];

    // Register Observers for table changes
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(collectedSpecimenstableViewSelectionDidChange:)
     name:NSTableViewSelectionDidChangeNotification object:self.collectionSpecimensTableView];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(nlmcTestTableViewSelectionDidChange:)
     name:NSTableViewSelectionDidChangeNotification object:self.nlmcTestTableView];

    //init a datasources for sub tables
    self.collectionMethodsDataSource = [[CWCollectionMethodsTableViewDataSource alloc] init];
    self.collectionSpecimensDataSource = [[CWCollectionSpecimenDataSource alloc] init];
    // Set datasources for sub tables
    [self.collectionSpecimensTableView setDataSource:self.collectionSpecimensDataSource];
    [self.collectionMethodsTableView setDataSource:self.collectionMethodsDataSource];

}

-(void)nlmcTestTableViewSelectionDidChange:(NSNotification *)notification
{
    //up date sub tables on table change
    self.collectionSpecimensDataSource.currentSpecimensMethodsArray = [NSMutableArray arrayWithArray:[[self.nlmcArrayController.selection valueForKey:@"CollectionSpecimen"] allObjects]];;
    
    // Reload New Data
    [self.collectionSpecimensTableView reloadData];
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.collectionSpecimensTableView selectRowIndexes:indexSet byExtendingSelection:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NSTableViewSelectionDidChangeNotification
                                                        object:self.collectionSpecimensTableView
                                                      userInfo:nil];
    
}

-(void)collectedSpecimenstableViewSelectionDidChange:(NSNotification *)notification
{
    // update collection methods for selected specimen type
    NSInteger row = [self.collectionSpecimensTableView selectedRow];
    
    if (self.collectionSpecimensDataSource.currentSpecimensMethodsArray .count > row) {
        CollectionSpecimen *currentSpecimenCollection = [self.collectionSpecimensDataSource.currentSpecimensMethodsArray objectAtIndex:row];
    NSSet *methods = currentSpecimenCollection.collectionMethodsRelationship;
    self.collectionMethodsDataSource.currentCollectionMethodsArray = [methods allObjects];
    [self.collectionMethodsTableView reloadData];
    
    }
}


- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)createTestNames:(id)sender
{

}

- (IBAction)parseNLMCXML:(id)sender
{
    NSLog(@"doOpen");
    NSOpenPanel* tvarNSOpenPanelObj = [NSOpenPanel openPanel];
    NSInteger tvarNSInteger = [tvarNSOpenPanelObj runModal];
    if (tvarNSInteger == NSModalResponseOK) {
        NSLog(@"doOpen we have an OK button");
    }
    else if (tvarNSInteger == NSModalResponseCancel) {
        NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {
        NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld", (long)tvarNSInteger);
        return;
    } // end if

    NSURL* tvarFilename = [tvarNSOpenPanelObj URL];
    NSLog(@"doOpen filename = %@", tvarFilename);

    CWNLMCFunctions* Parser = [[CWNLMCFunctions alloc] init];

    [Parser parseXMLFile:tvarFilename];
}


- (IBAction)parseXMLusingDom:(id)sender
{
    NSLog(@"doOpen");
    NSOpenPanel* tvarNSOpenPanelObj = [NSOpenPanel openPanel];
    NSInteger tvarNSInteger = [tvarNSOpenPanelObj runModal];
    if (tvarNSInteger == NSModalResponseOK) {
        NSLog(@"doOpen we have an OK button");
    }
    else if (tvarNSInteger == NSModalResponseCancel) {
        NSLog(@"doOpen we have a Cancel button");
        return;
    }
    else {
        NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld", (long)tvarNSInteger);
        return;
    } // end if
    
    NSURL* tvarFilename = [tvarNSOpenPanelObj URL];
    NSLog(@"doOpen filename = %@", tvarFilename);
    
    [CWNLMCXMLParser parseXMLFile:tvarFilename];
}

- (IBAction)jsonNLMC:(id)sender
{
}

@end
