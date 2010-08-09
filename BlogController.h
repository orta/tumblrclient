//
//  BlogController.h
//  Tumblg
//
//  Created by orta on 20/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ConnectionController.h"
#import "ORHTTPWrapper.h"

@interface BlogController : NSObject {
  IBOutlet ConnectionController *connectionController;  
  IBOutlet NSImageView *profilePictureView;  
  
  IBOutlet NSToolbar *toolbar;  
  IBOutlet NSToolbarItem *loginButtonItem;
  IBOutlet NSToolbarItem *profilePictureItem;
  IBOutlet NSToolbarItem *blogSwitcherButtonItem; 
  IBOutlet NSPopUpButton *blogSwitcherButton;
  
  NSMutableArray * blogs;
  NSMutableArray * blogTitles;
  ORHTTPRequest * _HTTPReq;
  int _currentBlogIndex;
  bool _hasLoggedIn;

}
- (IBAction) selectedIndexChanged:(id) sender;

- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data;
- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error;
- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code;

- (IBAction)openCurrentBlog:(id)sender;
- (void) userLoggedIn;

- (void) setCurrentBlogIndex: (int) index;
- (NSString *) currentBlogURL;

- (int) currentBlogIndex;
- (NSArray *) blogTitles;
- (NSString *) group;

@property(retain)   NSMutableArray * blogs;


@end
