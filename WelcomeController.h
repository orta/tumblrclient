//
//  WelcomeController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>
#import "ConnectionController.h"

@interface WelcomeController : NSObject {
  IBOutlet WebView *introView;
  IBOutlet NSWindow *mainWindow;
  IBOutlet ConnectionController *connectionController;
  NSString * defaultPage;

}

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

@property (retain) NSString * defaultPage;

@end
