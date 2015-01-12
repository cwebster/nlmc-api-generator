//
//  csv_tools.h
//  Modelling
//
//  Created by Craig Webster on 29/08/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSString+CSVUtils.h"
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>



@interface CWFileUtilities : NSObject {
	NSArray* csvArray;
	NSString* csvFileName;
	}

@property NSArray* csvArray;
@property NSString* csvFileName;



-(NSArray*) selectFiles;
-(void)writeToCSVFile;
-(NSArray *) getFilesInDirectory:(NSURL *)directoryUrl;
+ (void)writeUsingSavePanel:(NSString *)stringToSave;

@end
