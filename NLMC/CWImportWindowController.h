//
//  CWImportWindowController.h
//  NLMC
//
//  Created by Craig Webster on 05/01/2015.
//  Copyright (c) 2015 Craig Webster. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CWImportWindowController : NSWindowController

@property (nonatomic, strong) IBOutlet NSProgressIndicator* importProgressIndicator;
@property (nonatomic, strong) IBOutlet NSTextField* progressTextField;

@end
