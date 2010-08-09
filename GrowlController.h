//
//  GrowlController.h
//  Tumblg
//
//  Created by orta on 21/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.02 Tonight
//

#import <Cocoa/Cocoa.h>
#import <Growl-WithInstaller/Growl.h>


@interface GrowlController : NSObject  <GrowlApplicationBridgeDelegate> {
     
}

- (void) postSuccess;
- (void) postFailed;
- (void) networkDown;
- (void) startedPosting;

- (void) growlWithTitle:(NSString *)title description:(NSString*)description name:(NSString*) name;

@end
