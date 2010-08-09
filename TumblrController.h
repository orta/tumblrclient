//
//  TumblrController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
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
#import "ORViews.h"
#import <iMediaBrowser/iMediaBrowser.h>


@interface TumblrController : NSViewController {
  
  IBOutlet NSView *mainWindowContentView;
  IBOutlet NSWindow *mainWindow;

  IBOutlet NSToolbarItem *textItem;
  IBOutlet NSToolbarItem *imageItem;
  IBOutlet NSToolbarItem *videoItem;
  IBOutlet NSToolbarItem *quoteItem;
  IBOutlet NSToolbarItem *conversationItem;
  IBOutlet NSToolbarItem *linkItem;
  IBOutlet NSToolbarItem *audioItem;
  IBOutlet NSToolbarItem *welcomeItem;
  
  IBOutlet NSToolbar *toolBar;
  
  IBOutlet NSView *textView;
  IBOutlet NSView *imageView;
  IBOutlet NSView *videoView;
  IBOutlet NSView *quoteView;
  IBOutlet NSView *conversationView;
  IBOutlet NSView *linkView;
  IBOutlet NSView *audioView;
  IBOutlet NSView *welcomeView;
  
  IBOutlet TextController *textController;
  IBOutlet ImageController *imageController;
  IBOutlet VideoController *videoController;
  IBOutlet QuoteController *quoteController;
  IBOutlet ConversationController *conversationController;
  IBOutlet AudioController *audioController;
  IBOutlet LinkController *linkController;
  IBOutlet WelcomeController *welcomeController;
  
  IBOutlet ConnectionController *connectionController;

  IBOutlet ORExtrasGradientView * moreOptionsView;
  IBOutlet  NSButton* moreOptionsButton;
  
  IBOutlet ORBlackBackgroundView * prefsView;
  
  
  NSArray * toolbarItems;
  NSArray * viewsForContentTypes;
  NSArray * viewControllers;

  NSView * currentView;
  NSView * oldView;
  NSNumber * currentViewIndex;
  NSNumber * oldViewIndex;

  int magicFooterNumber;
  int magicToolbarSizeNumber;
  
  bool superfluousVisualEffects;
  bool _inverseDirectionOnce;
  bool loggedIn;
  bool showingPrefs;
  bool showingExtraInfo;
}

- (IBAction)toolbarClicked:(id)sender;
- (IBAction)nextTab:(id)sender;
- (IBAction)previousTab:(id)sender;  
- (IBAction)toggleExtraPostInfo:(id)sender;
- (IBAction)togglePrefs:(id)sender;
- (IBAction)advancedUsage:(id)sender;
- (IBAction)newTextPost:(id)sender;
- (IBAction)appHelp:(id)sender;

+ (int) fileTypeForFilePath: (NSString *) filename;

- (void) importTextContentWithBody:(NSString *)aBody 
                             title:(NSString *) aTitle 
                           summary:(NSString *)aSummary
                              link:(NSString *)aLink
                            source:(NSString *) aSource 
                            asType:(int)type;

- (void) importFileContentWithPath:(NSString *)path 
                    andDescription:(NSString*) description;

- (void) setCurrentViewIndex:(int)newIndex;
- (int)  currentViewIndex;
- (id)   currentViewController;
- (void) removeOldView;
- (void) setLoggedIn:(bool) newBool;
- (bool) loggedIn;
- (void) networkDown;
- (void) doubleClickInPhotosBrowser:(NSNotification *)notification;
- (void)iMediaConfiguration:(iMediaConfiguration *)configuration doubleClickedSelectedObjects:(NSArray*)selection;

@end
