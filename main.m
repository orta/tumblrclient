//
//  main.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MMICrashReporterBridge.h"


int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [MMICrashReporterBridge installSignalHandlers];
  [pool release];
    return NSApplicationMain(argc,  (const char **) argv);
}
