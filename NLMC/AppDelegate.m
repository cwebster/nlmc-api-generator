//
//  AppDelegate.m
//  NLMC
//
//  Created by Craig Webster on 07/12/2014.
//  Copyright (c) 2014 Craig Webster. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

+(void)initialize {
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"nlmcTestDatabase.sqlite"];
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    // Insert code here to initialize your application

    
    
}

-(void)applicationWillFinishLaunching:(NSNotification *)notification   {
    
   
    
}

- (void)applicationWillTerminate:(NSNotification*)aNotification
{
    // Insert code here to tear down your application
    [MagicalRecord cleanUp];
}

#pragma mark - Core Data Saving and Undo support

@end
