//
//  PostController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TextController.h"
#import "ImageController.h"
#import "VideoController.h"
#import "QuoteController.h"
#import "ConversationController.h"
#import "AudioController.h"
#import "LinkController.h"
#import "WelcomeController.h"
#import "ConnectionController.h"
#import "TumblrController.h"
#import "BlogController.h"
#import "viewControllerProtocol.h"
#import "ORHTTPWrapper.h"
#import "GrowlController.h"


@interface PostController : NSObject {
  
  IBOutlet TextController *textController;
  IBOutlet ImageController *imageController;
  IBOutlet VideoController *videoController;
  IBOutlet QuoteController *quoteController;
  IBOutlet ConversationController *conversationController;
  IBOutlet AudioController *audioController;
  IBOutlet LinkController *linkController;
  IBOutlet WelcomeController *welcomeController;
  IBOutlet TumblrController *tumblrController;
  IBOutlet ConnectionController *connectionController;
  IBOutlet BlogController *blogController;

  IBOutlet NSTextField *groupTextField;
  IBOutlet NSTokenField *tagTokenView;
  IBOutlet NSButton *privatePostButton;
  
  ORHTTPRequest * _HTTPReq;
  
  IBOutlet GrowlController *growlController;

  NSMutableData *receivedData;
}

// ORHTTP Delegate methods

- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code;    
- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data;
- (void) HTTPConnectionFailed: (ORHTTPRequest *) httpReq;
- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error;

-(IBAction) post:(id) sender;
- (void)postWithType:(NSString*)fileType;
@end
