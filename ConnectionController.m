//
//  ConnectionController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ConnectionController.h"
#import "ORHTTPWrapper.h"

@implementation ConnectionController

- (void) awakeFromNib{
}

- (IBAction) authenticate:(id)sender{
  NSString * username = [usernameTextField stringValue];
  NSString * password = [passwordTextField stringValue];  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDoingAuthNowAight" object:self];
  
  _HTTPReq  = [[ORHTTPRequest alloc] initWithDelegate:self];
  _HTTPReq.requestPath = @"http://www.tumblr.com/api/write";
  
  NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"authenticate", @"action", username, @"email", password, @"password", nil];
  [_HTTPReq postRequestWithParams:params];
}


- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORConnectionProblems" object:  [error localizedDescription] ];
}

- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code{  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORUserDetailsAreBadMan" object:self];
}

- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data{
  log(@"Recieved auth string %@", data);
  [self storeCredentials:nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORUserLoggedIn" object:self];

}  


- (IBAction)login:(id)sender {
  [errorField setStringValue:@""];
  [progressIndicator setHidden:true];
  [[NSApplication sharedApplication] beginSheet:loginSheet modalForWindow: mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticatingNow:) name:@"ORDoingAuthNowAight" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dodgyCredentials:) name:@"ORUserDetailsAreBadMan" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionFailed:) name:@"ORConnectionProblems" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeCredentials:) name:@"ORUserDetailsAreCool" object:nil];
}



- (IBAction)cancelLoginSheet:(id)sender {
  [progressIndicator stopAnimation:self];
  [loginSheet orderOut:nil];
  [[NSApplication sharedApplication] endSheet:loginSheet];	
  [errorField setStringValue:@""];

}

- (void)dodgyCredentials:(NSNotification *)notification{
  [progressIndicator stopAnimation:self];
  [progressIndicator setHidden:true];
  [errorField setStringValue:@"Could not authenticate"];
}


- (void)connectionFailed:(NSNotification *)notification{
  [progressIndicator stopAnimation:self];
  [progressIndicator setHidden:true];
  [errorField setStringValue:[notification object]];

}

- (void)authenticatingNow:(NSNotification *)notification{
  [progressIndicator startAnimation:self]; 
  [progressIndicator setHidden:false];
} 

- (void)storeCredentials:(NSNotification *)notification{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [progressIndicator stopAnimation:self];
  [self setPassword:[passwordTextField stringValue]];
  
}

- (void) setPassword: (NSString *) newPass{
  emailAddress =  [[NSUserDefaults standardUserDefaults] objectForKey:@"tumblrEmailAddress"];
  EMKeychainItem * currentItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tumblg" withUsername:emailAddress];
  if( currentItem == nil){
    [[EMKeychainProxy sharedProxy] addGenericKeychainItemForService:@"Tumblg" withUsername: emailAddress password:newPass];
  }
  else if([currentItem password] != [passwordTextField stringValue]){
    [currentItem setPassword:[passwordTextField stringValue]];
  }
  [self cancelLoginSheet: nil];
  _loggedIn = true;
  
}

- (NSString *)password{
  EMGenericKeychainItem *keychainItem = [[EMKeychainProxy sharedProxy] genericKeychainItemForService:@"Tumblg" withUsername: emailAddress];
  NSString *keychainPassword = [keychainItem password];
  if(keychainPassword == nil){
    return @"^^nil^^";
  }
  return keychainPassword;
}

- (bool) loggedIn{
  return _loggedIn;
}

- (NSString *)email{
  if(emailAddress == nil){
    emailAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"tumblrEmailAddress"];
  }
  return emailAddress;
}
- (void) followOrta{
 // <input type="hidden" name="form_key" value="QGjdFWQs97x4IZSIOR3C5pn6OWg"/> 
 // <input type="hidden" name="id" value="259225"/> 
  
}

@end
