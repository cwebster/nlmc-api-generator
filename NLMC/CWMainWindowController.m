//
//  WebsterMainWindowController.m
//  NLMC
//
//  Created by Craig Webster on 11/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "CWMainWindowController.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "CWNLMCXMLParser.h"
#import "CWMainViewController.h"

@interface CWMainWindowController ()

@end

@implementation CWMainWindowController

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.moc = [NSManagedObjectContext MR_contextForCurrentThread];
    
    self.mainViewController = (CWMainViewController *)self.window.contentViewController;

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSLog(@"vc = %@", self.contentViewController);
    
}

- (void)awakeFromNib {
    
   
}

- (IBAction)parseNLMCXML:(id)sender {
    

    NSOpenPanel* tvarNSOpenPanelObj = [NSOpenPanel openPanel];
    NSInteger tvarNSInteger = [tvarNSOpenPanelObj runModal];
    if (tvarNSInteger == NSModalResponseOK) {
        
    }
    else if (tvarNSInteger == NSModalResponseCancel) {
        
        return;
    }
    else {
        
        return;
    } // end if
    
    NSURL* tvarFilename = [tvarNSOpenPanelObj URL];

    [NSApp endSheet:tvarNSOpenPanelObj];
    [tvarNSOpenPanelObj orderOut:self];
    [tvarNSOpenPanelObj close];
    
    [CWNLMCXMLParser parseXMLFile:tvarFilename];
    

}

- (IBAction)emptyDatabase:(id)sender {
    
   [NLMCTest MR_truncateAll];
    
    
    NSRange range = NSMakeRange(0, [[self.mainViewController.nlmcArrayController arrangedObjects] count]);
    [self.mainViewController.nlmcArrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    
    [self.moc MR_saveOnlySelfAndWait];
}

- (IBAction)exportJSON:(id)sender {
    
}

@end
