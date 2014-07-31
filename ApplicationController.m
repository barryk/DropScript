/**
 *  ApplicationController.m
 *  DropScript
 *
 *  Created by Wilfredo S‡nchez on Sun May 02 2004.
 *  Copyright (c) 2004 Wilfredo S‡nchez Vega. All rights reserved.
 **/

#import <Cocoa/Cocoa.h>

#import "ApplicationController.h"

@implementation ApplicationController

/**
 * Inits
 **/

- (id) init
{
    if ((self = [super init]))
    {
        myAppIsLaunching             = YES;
        myAppWasLaunchedWithDocument = NO;
        myScriptFilename             = [[[NSBundle mainBundle] pathForResource:@"drop_script" ofType:nil] retain];
        
        if (!myScriptFilename)
        {
            NSRunAlertPanel(@"Error", @"Missing script.", @"Bummer", nil, nil);
            [NSApp terminate: self];
        }
        
        // Provide application services
        // From http://stackoverflow.com/questions/49510/how-do-you-set-your-cocoa-application-as-the-default-web-browser
        [NSApp setServicesProvider: self];
        NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
        [em
         setEventHandler:self
         andSelector:@selector(handleURIEvent:withReplyEvent:)
         forEventClass:kInternetEventClass
         andEventID:kAEGetURL];
    }
    return self;
}

- (void) dealloc
{
    [myScriptFilename release];
    
    [super dealloc];
}

/**
 * Actions
 **/

- (void) runScriptWithArguments: (NSArray*) anArguments
{
    [NSTask launchedTaskWithLaunchPath: myScriptFilename
                             arguments: anArguments];
}

/**
 * IB Targets
 **/

- (IBAction) open: (id) aSender
{
    NSOpenPanel* anOpenPanel = [NSOpenPanel openPanel];
    
    [anOpenPanel setCanChooseFiles         : YES];
    [anOpenPanel setCanChooseDirectories   : YES];
    [anOpenPanel setAllowsMultipleSelection: YES];
    
    if ([anOpenPanel runModalForTypes:nil] == NSOKButton)
    {
        [self runScriptWithArguments: [anOpenPanel filenames]];
    }
}

/**
 * Application delegate
 **/

- (BOOL) application: (NSApplication*) anApplication
            openFile: (NSString*     ) aFileName
{
    if (myAppIsLaunching) myAppWasLaunchedWithDocument = YES;
    
    if (myFilesToBatch == nil)
    {
        myFilesToBatch = [[NSMutableArray alloc] init];
        [self performSelector: @selector(_delayedOpenFile:) withObject: nil afterDelay: 0];
    }
    
    [myFilesToBatch addObject: aFileName];
    
    return YES;
}

- (void) _delayedOpenFile: (id) anObject
{
    [self runScriptWithArguments: myFilesToBatch];
    [myFilesToBatch release];
    myFilesToBatch = nil;
    
    if (myAppWasLaunchedWithDocument) [NSApp terminate: self];
}

- (void) applicationDidFinishLaunching: (NSNotification*) aNotification
{
    myAppIsLaunching = NO;
}

/**
 * Services
 **/

- (void) dropService: (NSPasteboard*) aPasteBoard
            userData: (NSString*    ) aUserData
               error: (NSString**   ) anError
{
    NSArray* aTypes = [aPasteBoard types];
    
    id aData = nil;
    
    if ([aTypes containsObject: NSFilenamesPboardType] &&
        (aData = [aPasteBoard propertyListForType: NSFilenamesPboardType]))
    {
        [self runScriptWithArguments: aData];
    }
    else
    {
        *anError = @"Unknown data type in pasteboard.";
        NSLog(@"Service invoked with no valid pasteboard data.");
    }
}

- (void)handleURIEvent:(NSAppleEventDescriptor *)event
        withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSString *urlStr = [[event paramDescriptorForKeyword:keyDirectObject]
                        stringValue];
    NSMutableArray *urls = [[[NSMutableArray alloc] init] autorelease];
    [urls addObject: urlStr];
    [self runScriptWithArguments: urls];
}

@end
