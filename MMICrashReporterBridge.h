//
//  untitled.h
//  MMICrashReporter
//
//  Created by Martin Redington on 17/05/2006.
//  Copyright 2006 MildMannered Industries. All rights reserved.
//

/*!
 @header MMICrashReporterBridge.h
 @discussion Applications which wish to use MMICrashReporter must import this 
             header and the corresponding object file.
 @copyright MildMannered Industries
 */

#import <Cocoa/Cocoa.h>

/*!
@class MMICrashReporterBridge
@abstract MMICrashReporterBridge is the access point for MMICrashReporter.
@discussion Developers who wish to integrate MMICrashReporter with their 
application should call the <code>installSignalHandlers</code> method soon 
after startup.

If you want to connect a user interface item or control to launching a bug report, 
you can instantiate MMICrashReporterBridge in your nib, and call the 
<code>reportBug:</code> method.

See the Integration docs for more information.
*/

@interface MMICrashReporterBridge : NSObject {

}


/*!
 @method installSignalHandlers
 @abstract Installs the signal handlers that will launch a new Crash Report if the 
           application crashes.
 @discussion If MMICrashReporter, or its configuration cannot be found inside the 
             callers main Bundle, this method will fail, and a message will be printed 
             to the Console Log.
 
 @result YES if the signal handlers were installed, and NO otherwise.
 */
+ (BOOL) installSignalHandlers;


/*!
 @method reportBug
 @abstract Launches a new Bug Report.
 @discussion You can use this method to launch a Bug Report from within your application.
 */
+ (void) reportBug;


/*!
 @method reportBug:
 @abstract Launches a new Bug Report.
 @discussion This instance method can be used to connect user interface items to.
 
 @param The sender of the message.
 */
- (IBAction) reportBug:(id)sender;


@end


