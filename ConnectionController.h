//
//  ConnectionController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EMKeychainItem.h"
#import "EMKeychainProxy.h"
#import "ORHTTPWrapper.h"

@interface ConnectionController : NSObject {
  IBOutlet NSTextField *loginTextField;
  IBOutlet NSTextField *errorField;
  IBOutlet NSTextField *toolbarTextField;
  IBOutlet NSToolbar * toolbar;
  IBOutlet NSToolbarItem * seperatorToolbarItem;
  IBOutlet NSButton *loginButton;
  IBOutlet NSTextField *usernameTextField;
  IBOutlet NSSecureTextField *passwordTextField;
  IBOutlet NSProgressIndicator *progressIndicator;
  IBOutlet NSWindow *mainWindow;
  IBOutlet NSWindow *loginSheet;

  ORHTTPRequest * _HTTPReq;

  NSMutableData *receivedData;
  NSString *emailAddress;
  bool _loggedIn;
  
}
  
- (IBAction)login:(id)sender;
- (IBAction)cancelLoginSheet:(id)sender;
- (IBAction) authenticate:(id)sender;

- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data;
- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error;
- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code;
- (void) followOrta;
- (void)connectionFailed:(NSNotification *)notification;
- (void)dodgyCredentials:(NSNotification *)notification;
- (void)storeCredentials:(NSNotification *)notification;
- (NSString *)password;
- (void) setPassword: (NSString *) newPass;
- (NSString *)email;
- (bool)loggedIn;
@end
