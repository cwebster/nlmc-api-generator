//
//  ViewController.h
//  NLMC
//
//  Created by Craig Webster on 07/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CWMainViewController : NSViewController

@property NSManagedObjectContext *moc;

- (IBAction)parseNLMCXML:(id)sender;
- (IBAction)createTestNames:(id)sender;

- (IBAction)jsonNLMC:(id)sender;

@end

