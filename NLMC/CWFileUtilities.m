//
//  BatchConverter.m
//  Modelling
//
//  Created by Craig Webster on 29/08/2010.
//  Copyright 2010 Craig Webster. All rights reserved.
//

#import "CWFileUtilities.h"

@implementation CWFileUtilities

@synthesize csvArray;
@synthesize csvFileName;


// Select files method allows user to select CSV file
- (NSArray*) selectFiles;
{
    NSOpenPanel* op = [NSOpenPanel openPanel];
    //Set file open dialog properties
    [op setCanChooseDirectories:NO];
    [op setCanChooseFiles:YES];
    [op setAllowsMultipleSelection:YES];
	//title of window passed
    [op setPrompt:@"Select"];
    
    if ( [op runModal] == NSModalResponseOK )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* urls = [op URLs];
        
        // Loop through all the files and process them.
        for(int i = 0; i < [urls count]; i++ )
        {
            NSString* url = [urls objectAtIndex:i];
            NSLog(@"Url: %@", url);
        }
        
        return urls;
    }
    
    return nil;
}

// Write a CSV string to a file
- (void)writeToCSVFile;
{
	//init variables
	int	i;
    NSInteger count;
	NSError *error;
	NSString *csvString = [NSMutableString string];
	id batchfiles;
	NSArray* selectedFiles;
	
    		
	//init batch object
    batchfiles = [[CWFileUtilities alloc]init];
	
	//open a file save dialog
	
	selectedFiles = [batchfiles selectFiles];
	
	
	// get file name string
	NSString *filenameStr = [selectedFiles objectAtIndex:0];
	
	
	//Loop though the supplied array and add to CSV string
	for (i = 0, count = [csvArray count]; i < count; i = i + 1)
    {
		[csvString stringByAppendingString:[NSString stringWithFormat:@"%@\n",[csvArray objectAtIndex:i]]];
	}
	//write to file
	if(![csvString writeToFile: filenameStr atomically: YES encoding:NSUTF8StringEncoding error:&error]) {
			 NSLog(@"We have a problem %@\r\n",[error localizedFailureReason]);
	}
}

-(NSArray *) getFilesInDirectory:(NSURL *)directoryUrl{
    
    
    NSURL *url = directoryUrl;
    NSError *error = nil;
    NSArray *properties = [NSArray arrayWithObjects: NSURLLocalizedNameKey,
                           NSURLCreationDateKey, NSURLLocalizedTypeDescriptionKey, nil];
    
    NSArray *array = [[NSFileManager defaultManager]
                      contentsOfDirectoryAtURL:url
                      includingPropertiesForKeys:properties
                      options:(NSDirectoryEnumerationSkipsHiddenFiles)
                      error:&error];
    if (array == nil) {
        // Handle the error
    }
    
    return array;
}

+ (void)writeUsingSavePanel:(NSString *)stringToSave {
    // get the file url
    NSSavePanel * zSavePanel = [NSSavePanel savePanel];
    NSInteger zResult = [zSavePanel runModal];
    if (zResult == NSFileHandlingPanelCancelButton) {
        NSLog(@"writeUsingSavePanel cancelled");
        return;
    }
    NSURL *zUrl = [zSavePanel URL];
    
    //write
    BOOL zBoolResult = [stringToSave writeToURL:zUrl
                             atomically:YES
                               encoding:NSASCIIStringEncoding
                                  error:NULL];
    if (! zBoolResult) {
        NSLog(@"writeUsingSavePanel failed");
    }   
}


@end 