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

    // Register Observer for Main table change
    [self.nlmcArrayController addObserver:self forKeyPath:@"selection" options:0 context:nil];

    //init a datasources for sub tables
    self.collectionMethodsDataSource = [[CWCollectionMethodsTableViewDataSource alloc] init];
    self.collectionSpecimensDataSource = [[CWCollectionSpecimenDataSource alloc] init];
    // Set datasources for sub tables
    [self.collectionSpecimensTableView setDataSource:self.collectionSpecimensDataSource];
    [self.collectionMethodsTableView setDataSource:self.collectionMethodsDataSource];

    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{

    if ([keyPath isEqualToString:@"selection"]) {
        // Update the datasource arrays for Collection Methods and Collection Specimens
        self.currentCollectionMethods = [NSMutableArray arrayWithArray:[[self.nlmcArrayController.selection valueForKey:@"CollectionMethod"] allObjects]];
        self.collectionMethodsDataSource.currentCollectionMethodsArray = self.currentCollectionMethods;

        self.currentCollectionSpecimens = [NSMutableArray arrayWithArray:[[self.nlmcArrayController.selection valueForKey:@"CollectionSpecimen"] allObjects]];
        self.collectionSpecimensDataSource.currentSpecimensMethodsArray = self.currentCollectionSpecimens;

        // Reload New Data
        [self.collectionMethodsTableView reloadData];
        [self.collectionSpecimensTableView reloadData];
    }
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
