//
//  untitled.m
//  MMICrashReporter
//
//  Created by Martin Redington on 17/05/2006.
//  Copyright 2006 MildMannered Industries. All rights reserved.
//

#import "MMICrashReporterBridge.h"

#import <signal.h>

// Defines. These are all duplicates of entries in mmicr_defines.h
// They are duplicated, so that the Bridge can be distributed 
// as simply as possible.

#define OPEN_CRASH_REPORT_DESC_TYPE 'MIcr'
#define OPEN_BUG_REPORT_DESC_TYPE 'MIbr'
#define PASS_THRU_PARAMS_DESC_TYPE 'prdt'

#define MMI_CRASH_REPORTER_NAME @"MMICrashReporter"
#define APP_EXTENSION @"app" 

#define MMI_CRASH_REPORTER_CONFIG @"MMICrashReporter"
#define MMI_CRASH_REPORTER_CONFIG_EXTENSION @"crashreporterconfig"

#define MMI_INFO_PLIST_DELIVERY_ADDRESS_KEY @"MMICrashReporterDeliveryAddress"


// This is used to store the location of the crash reporter.
static NSString *crashReporterPath = nil;


#define NUMBER_OF_SIGNALS_TO_HANDLE 19

static int SIGNALS_TO_HANDLE[] = {
    SIGHUP,
    SIGINT,
    SIGILL,
    // SIGQUIT,
    SIGTRAP,
    SIGABRT,

    SIGEMT,
    SIGFPE,
    SIGKILL,
    SIGBUS,
    SIGSEGV,

    SIGSYS,
    SIGPIPE,
    SIGALRM,
    SIGTERM,
    // SIGURG,
    // SIGSTOP,
    // SIGTSTP,
    // SIGCONT,
    // SIGCHLD,
    SIGTTIN,

    SIGTTOU,
    // SIGIO,
    SIGXCPU,
    SIGXFSZ,
    SIGVTALRM,
    
    // SIGPROF,
    // SIGWINCH,
    // SIGINFO,
    // SIGUSR1,
    // SIGUSR2,
};


/**
 * This actually open the app ...
 */
void mmicr_launch_crashreporter(DescType descType){
    NSURL *url = [NSURL fileURLWithPath:crashReporterPath];
    
    OSStatus status;
    
    AEDesc recordDesc;
    AEInitializeDesc(&recordDesc);
    status = AECreateDesc(descType, NULL, 0, &recordDesc);

    // We check the status here
    if(status != noErr){
        NSLog(@"MMICrashReporterBridge could not launch MMICrashReporter: Apple Event could not be created");
    }
    
    LSLaunchURLSpec inLaunchSpec;
    inLaunchSpec.appURL = (CFURLRef) url;
    inLaunchSpec.itemURLs = NULL;
    inLaunchSpec.passThruParams = &recordDesc;
    inLaunchSpec.launchFlags = kLSLaunchDontAddToRecents | kLSLaunchDefaults;
    inLaunchSpec.asyncRefCon = NULL;
    
    CFURLRef *outLaunchedURL = NULL;
    status = LSOpenFromURLSpec (&inLaunchSpec, outLaunchedURL);
    
    if(status != noErr){
        NSLog(@"MMICrashReporterBridge could not launch MMICrashReporter: %d", status);                
    }
    else{
        NSLog(@"MMICrashReporterBridge launched MMICrashReporter");
    }
}

////////////////////////////////////////////////////////

/**
 * This is the signal handler.
 */
void mmicr_handle_signal(int signal){
    NSLog(@"MMICrashReporterBridge received signal %d", signal);
    NSLog(@"MMICrashReporterBridge launching CrashReporter from %@", crashReporterPath);

    mmicr_launch_crashreporter(OPEN_CRASH_REPORT_DESC_TYPE);
    
    NSLog(@"MMICrashReporterBridge terminating application");

    //    [NSApp terminate:nil];
    exit(0);
}

////////////////////////////////////////////////////////


@implementation MMICrashReporterBridge

////////////////////////////////////////////////////////

+ (void) reportBug
{
    mmicr_launch_crashreporter(OPEN_BUG_REPORT_DESC_TYPE);
}

////////////////////////////////////////////////////////

- (IBAction) reportBug:(id)sender{
    [[self class] reportBug];    
}

////////////////////////////////////////////////////////

+ (BOOL) installSignalHandlers
{
    NSLog(@"Installing MMICrashReporterBridge signal handlers");

    // work out which directory the parent app is in
    NSString *mainBundlePath = [[NSBundle mainBundle] bundlePath];
    // locate MMICrashReporter

    if(mainBundlePath == nil){
        // we are not being run from a bundle ... bail        
        NSLog(@"WARNING: MMICrashReporterBridge signal handlers were not installed, because:");
        NSLog(@"[[NSBundle mainBundle] bundlePath] returned nil");
        NSLog(@"MMICrashReporter can only currently be used with Bundle based applications");
        return NO;
    }
    
    // Work out the path to MMICrashReporter.app, and make sure its there
    crashReporterPath = [[NSBundle mainBundle] pathForResource:MMI_CRASH_REPORTER_NAME ofType:APP_EXTENSION];
    
    if(crashReporterPath == nil){
        NSLog(@"WARNING: MMICrashReporterBridge signal handlers were not installed, because:");
        NSLog(@"%@.%@ could not be found inside the bundle's Resources directory", MMI_CRASH_REPORTER_NAME, APP_EXTENSION);
        return NO;
    }

    // Also, are we configured ...
    NSString *crashReporterConfigFilePath = [[NSBundle mainBundle] pathForResource:MMI_CRASH_REPORTER_CONFIG ofType:MMI_CRASH_REPORTER_CONFIG_EXTENSION];

    if(crashReporterConfigFilePath == nil){
        // We don't have a config file. Do we have an Info.plist entry for delivery ...
        NSString *deliveryAddress = [[NSBundle mainBundle] objectForInfoDictionaryKey:MMI_INFO_PLIST_DELIVERY_ADDRESS_KEY];
        if(deliveryAddress == nil){
            NSLog(@"WARNING: MMICrashReporterBridge signal handlers were not installed, because:");
            NSLog(@"Configuration could not be found in %@.%@, or in Info.plist", MMI_CRASH_REPORTER_CONFIG, MMI_CRASH_REPORTER_CONFIG_EXTENSION);
            return NO;
        }
    }

    // We're all set ...
    // NSLog(@"MMICrashReporterBridge caching CrashReporter path: %@", crashReporterPath);        
    [crashReporterPath retain];    
    
    
    int i;
    for(i = 0; i < NUMBER_OF_SIGNALS_TO_HANDLE; i++){
        signal(SIGNALS_TO_HANDLE[i], &mmicr_handle_signal);
    }
    
  //  NSLog(@"MMICrashReporterBridge Signal handlers installed");
    return YES;
}


@end
