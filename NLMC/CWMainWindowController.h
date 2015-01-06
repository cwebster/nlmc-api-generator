//
//  WebsterMainWindowController.h
//  NLMC
//
//  Created by Craig Webster on 11/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class CWMainViewController;

@interface CWMainWindowController : NSWindowController

@property NSManagedObjectContext *moc;
@property (nonatomic, strong) IBOutlet CWMainViewController *mainViewController;

- (IBAction)parseNLMCXML:(id)sender;
- (IBAction)emptyDatabase:(id)sender;
- (IBAction)exportJSON:(id)sender;


@end
