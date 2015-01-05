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
    [self createDisciplinesFromJsonString];
    
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

- (void)createDisciplinesFromJsonString {
    
    NSString* str = [self.disciplineTextField stringValue];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    [self.immunologyTextField setHidden:YES];
    [self.chemistryTextField setHidden:YES];
    [self.haematologyTextField setHidden:YES];
    
    id disciplineData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if(error) { /* JSON was malformed, act appropriately here */ }
    
    // the originating poster wants to deal with dictionaries;
    // assuming you do too then something like this is the first
    // validation step:
    if([disciplineData isKindOfClass:[NSDictionary class]])
    {
       NSDictionary *results = disciplineData;
        
        [results enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
            // do something with key and obj
            if ([obj isEqualToString:@"Immunology"]) {
                NSLog(@"Immunology" );
                [self.immunologyTextField setHidden:NO];
                [self.immunologyTextField setBackgroundColor:[NSColor blueColor]];
                [self.immunologyTextField setDrawsBackground:YES];
            } else if ([obj isEqualToString:@"Clinical Biochemistry"]) {
                NSLog(@"Clinical Biochemistry" );
                [self.chemistryTextField setHidden:NO];
                [self.chemistryTextField setBackgroundColor:[NSColor greenColor]];
                [self.chemistryTextField setDrawsBackground:YES];
            } else if ([obj isEqualToString:@"Haematology"]){
               NSLog(@"Haematology");
                [self.haematologyTextField setHidden:NO];
                [self.haematologyTextField setBackgroundColor:[NSColor redColor]];
                [self.haematologyTextField setDrawsBackground:YES];
            }
            
         
            
        }];
        
        /* proceed with results as you like; the assignment to
         an explicit NSDictionary * is artificial step to get
         compile-time checking from here on down (and better autocompletion
         when editing). You could have just made object an NSDictionary *
         in the first place but stylistically you might prefer to keep
         the question of type open until it's confirmed */
    }
    else
    {
        /* there's no guarantee that the outermost object in a JSON
         packet will be a dictionary; if we get here then it wasn't,
         so 'object' shouldn't be treated as an NSDictionary; probably
         you need to report a suitable error condition */
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
