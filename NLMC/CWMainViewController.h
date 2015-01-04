//
//  ViewController.h
//  NLMC
//
//  Created by Craig Webster on 07/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CWCollectionMethodsTableViewDataSource.h"
#import "CWCollectionSpecimenDataSource.h"
#import "CWNLMCXMLParser.h"

@interface CWMainViewController : NSViewController

@property NSManagedObjectContext* moc;

@property (nonatomic, strong) IBOutlet NSArrayController* nlmcArrayController;
@property (nonatomic, strong) CWCollectionMethodsTableViewDataSource *collectionMethodsDataSource;
@property (nonatomic, strong) CWCollectionSpecimenDataSource *collectionSpecimensDataSource;
@property (nonatomic, strong) IBOutlet NSTableView *collectionMethodsTableView;
@property (nonatomic, strong) IBOutlet NSTableView *collectionSpecimensTableView;
@property (nonatomic, strong) IBOutlet NSTableView *nlmcTestTableView;


- (IBAction)parseNLMCXML:(id)sender;
- (IBAction)createTestNames:(id)sender;
- (IBAction)parseXMLusingDom:(id)sender;

- (IBAction)jsonNLMC:(id)sender;

@end
