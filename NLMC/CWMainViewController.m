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

    // Do any additional setup after loading the view.
    
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
    
}

-(IBAction)createTestNames:(id)sender{
    NSLog(@"doOpen");
    NSOpenPanel *tvarNSOpenPanelObj	= [NSOpenPanel openPanel];
    NSInteger tvarNSInteger	= [tvarNSOpenPanelObj runModal];
    if(tvarNSInteger == NSModalResponseOK){
        NSLog(@"doOpen we have an OK button");
    } else if(tvarNSInteger == NSModalResponseCancel) {
        NSLog(@"doOpen we have a Cancel button");
        return;
    } else {
        NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",(long)tvarNSInteger);
        return;
    } // end if
    
    NSURL * tvarFilename = [tvarNSOpenPanelObj URL];
    NSLog(@"doOpen filename = %@",tvarFilename);
    
    NSMutableDictionary  *api = [CWNLMCFunctions getTestNamesJSON:tvarFilename];
    
    // create a JSON version of imported XML file
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:api options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // get the file url
    NSSavePanel* zSavePanel = [NSSavePanel savePanel];
    NSInteger zResult = [zSavePanel runModal];
    if (zResult == NSFileHandlingPanelCancelButton) {
        NSLog(@"writeUsingSavePanel cancelled");
        return;
    }
    NSURL* zUrl = [zSavePanel URL];
    
    //write
    BOOL zBoolResult = [jsonString writeToURL:zUrl
                                   atomically:YES
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
    if (!zBoolResult) {
        NSLog(@"writeUsingSavePanel failed");
    }

}

- (IBAction)parseNLMCXML:(id)sender
{
    NSLog(@"doOpen");
    NSOpenPanel *tvarNSOpenPanelObj	= [NSOpenPanel openPanel];
    NSInteger tvarNSInteger	= [tvarNSOpenPanelObj runModal];
    if(tvarNSInteger == NSModalResponseOK){
        NSLog(@"doOpen we have an OK button");
    } else if(tvarNSInteger == NSModalResponseCancel) {
        NSLog(@"doOpen we have a Cancel button");
        return;
    } else {
        NSLog(@"doOpen tvarInt not equal 1 or zero = %3ld",(long)tvarNSInteger);
        return;
    } // end if
    
    NSURL * tvarFilename = [tvarNSOpenPanelObj URL];
    NSLog(@"doOpen filename = %@",tvarFilename);
    
    CWNLMCFunctions* Parser = [[CWNLMCFunctions alloc] init];
    
    [Parser parseXMLFile:tvarFilename];

    //NSError* error;

    // create a JSON version of imported XML file
   // NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
   // NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    // get the file url
//    NSSavePanel* zSavePanel = [NSSavePanel savePanel];
//    NSInteger zResult = [zSavePanel runModal];
//    if (zResult == NSFileHandlingPanelCancelButton) {
//        NSLog(@"writeUsingSavePanel cancelled");
//        return;
//    }
//    NSURL* zUrl = [zSavePanel URL];
//
//    //write
//    BOOL zBoolResult = [jsonString writeToURL:zUrl
//                                   atomically:YES
//                                     encoding:NSUTF8StringEncoding
//                                        error:NULL];
//    if (!zBoolResult) {
//        NSLog(@"writeUsingSavePanel failed");
//    }

}

- (IBAction)jsonNLMC:(id)sender
{
}

@end
