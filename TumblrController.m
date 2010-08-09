//
//  TumblrController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.

#import "TumblrController.h"

@implementation TumblrController

- (void)awakeFromNib { 
  
  magicFooterNumber = 21;
  magicToolbarSizeNumber = 92;
  superfluousVisualEffects = true;
  loggedIn = false;
  showingPrefs = false;
  
  [mainWindow setContentBorderThickness: magicFooterNumber forEdge:NSMinYEdge];
  [mainWindowContentView setAutoresizesSubviews:YES];
  viewControllers =        [NSArray arrayWithObjects:textController, imageController, quoteController, 
                                                   linkController, conversationController, audioController,
                                                   videoController, welcomeController, nil ];  
  
  toolbarItems =          [NSArray arrayWithObjects:textItem, imageItem, quoteItem,
                                                   linkItem, conversationItem, audioItem,
                                                   videoItem, welcomeItem, nil ];  
  
  viewsForContentTypes = [NSArray arrayWithObjects:textView, imageView, quoteView, 
                                                   linkView, conversationView, audioView,
                                                   videoView, welcomeView, nil];
  // wants
  [viewsForContentTypes retain];
  [viewControllers retain];
  [toolbarItems retain];
  [currentView retain];
  [currentViewIndex retain];
  [oldViewIndex retain];
  [oldView retain];
  
  if([connectionController email] != nil){
    log(@"logged in automatically to - %@", [connectionController email]);
    log(@"going to index %i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastViewIndex"] intValue]);
    [self setCurrentViewIndex: [[[NSUserDefaults standardUserDefaults] objectForKey:@"lastViewIndex"] intValue] ];
    [self setLoggedIn:YES];
  }else{
    [self setCurrentViewIndex: [viewsForContentTypes count]-1];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDown) name:@"ORNetworkDown" object:nil];
 // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleClickInPhotosBrowser:) name:@"iMediaSelectionDoubleClicked" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleClickInPhotosBrowser:) name:@"iMediaSelectionChanged" object:nil];


}                         


- (NSArray *)toolbarSelectableItemIdentifiers: (NSToolbar *)toolbar{
  // Allow the user to select only our type categories
  return   [NSArray arrayWithObjects:[textItem itemIdentifier], [imageItem itemIdentifier], [quoteItem itemIdentifier],
                           [linkItem itemIdentifier], [conversationItem itemIdentifier], [audioItem itemIdentifier],
                           [videoItem itemIdentifier], [welcomeItem itemIdentifier], nil ]; 
}

- (IBAction)toolbarClicked:(id)sender {  
  if([sender tag] != [currentViewIndex intValue]){
    [self setCurrentViewIndex: [sender tag] ];
  }
}

- (int)currentViewIndex{
  return [currentViewIndex intValue];
}

- (void)setCurrentViewIndex:(int)newIndex {
  log(@"%s new %i old %@", _cmd, newIndex, currentViewIndex);
  
  oldView = currentView;
  oldViewIndex = currentViewIndex;
  [currentViewIndex retain];
  
  //remove preferences view
  if(showingPrefs){
    [self togglePrefs:nil];
  }
  
  if([currentViewIndex intValue] == newIndex){
    //TODO : this might break tings 
   // [[viewControllers objectAtIndex:[currentViewIndex intValue]] hasBecomeKeyView];
    if(newIndex != 0){
      return;   
    }
   
  }

  int direction; 

  if(newIndex > [currentViewIndex intValue]) direction = -1;
  else direction = 1;
  if(_inverseDirectionOnce){
    direction *= -1;
    _inverseDirectionOnce = false;
  }  
  if(currentView != nil){
    //out with the old    
    if(superfluousVisualEffects){
      NSRect newFrame = [oldView frame];
      newFrame.origin.x  = newFrame.size.width * direction;
    //  [[oldView animator] setFrame:newFrame];
      [oldView setFrame:newFrame];
      [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(removeOldView) userInfo:nil repeats:false];
    }else{
      [self removeOldView];      
    }
  }
  //in with the new
  currentViewIndex = [NSNumber numberWithInt:newIndex];
  [[NSUserDefaults standardUserDefaults] setObject:currentViewIndex forKey:@"lastViewIndex"];
//  if(newIndex != [toolbarItems count]-1){
    [toolBar setSelectedItemIdentifier: [ [toolbarItems objectAtIndex: newIndex] itemIdentifier] ];
 // }
  currentView = [viewsForContentTypes objectAtIndex: [currentViewIndex intValue]];
  [mainWindowContentView addSubview: currentView];
  [currentView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
  NSRect resizedFrame = [mainWindowContentView frame];
  resizedFrame.size.height -= magicFooterNumber;
  resizedFrame.origin.y += magicFooterNumber;
  [mainWindow setInitialFirstResponder: currentView ];

  if(superfluousVisualEffects){
    NSRect newFrame = resizedFrame;
    newFrame.origin.x  = newFrame.size.width * direction * -1;
  //  [currentView setFrame: newFrame];  
   // [[currentView animator] setFrame: resizedFrame];  
    [currentView setFrame:resizedFrame];
    [[viewControllers objectAtIndex:[currentViewIndex intValue]] hasBecomeKeyView];
    
  }else{
    [currentView setFrame: resizedFrame];  
    [[viewControllers objectAtIndex:[currentViewIndex intValue]] hasBecomeKeyView];

  }
 //g [mainWindow setInitialFirstResponder: currentView ];
}

- (IBAction)appHelp:(id)sender {  
  welcomeController.defaultPage = @"welcome";
  if([currentViewIndex intValue] != 7){
    [self setCurrentViewIndex:7];
  }else{
    [welcomeController hasBecomeKeyView];
  }
}

- (IBAction)advancedUsage:(id)sender {  
    welcomeController.defaultPage = @"advanced";
  if([currentViewIndex intValue] != 7){
    [self setCurrentViewIndex:7];
  }else{
    [welcomeController hasBecomeKeyView];
  }
}


- (IBAction)nextTab:(id)sender {  
  //its 2, one for the fence post and another for the welcome view
  if([currentViewIndex intValue] >= ([viewsForContentTypes count]-2)){
    _inverseDirectionOnce = true;
    [self setCurrentViewIndex: 0];
  }else{
    [self setCurrentViewIndex: [currentViewIndex intValue]+1];
  }
}

- (IBAction)previousTab:(id)sender {  
  if([currentViewIndex intValue] == 0){
    _inverseDirectionOnce = true;
    [self setCurrentViewIndex: ([viewsForContentTypes count]-2)];
  }else{
    [self setCurrentViewIndex: [currentViewIndex intValue]-1];
  }
}

- (IBAction)togglePrefs:(id)sender{
  
  NSRect newFrame;
  //[prefsView toggleFilter];
  if(showingPrefs){
    newFrame = [[mainWindow contentView] frame];
    newFrame.origin.y = newFrame.size.height;
    [prefsView setFrame:newFrame];
    showingPrefs = false;
    [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(removeOldView) userInfo:nil repeats:false];
    
  }else{
    newFrame = [[mainWindow contentView] frame];
    newFrame.origin.y = newFrame.size.height;
    [prefsView setFrame:newFrame];
    [prefsView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
    [mainWindowContentView addSubview:prefsView];
    
    newFrame = [[mainWindow contentView] frame];
    [prefsView setFrame:newFrame];
    showingPrefs = true;
  }
}

- (id)currentViewController{
  return [viewControllers objectAtIndex:[currentViewIndex intValue]];
}


- (void) removeOldView{
  [oldView removeFromSuperview];
  [prefsView removeFromSuperview];
  [[viewControllers objectAtIndex:[oldViewIndex intValue]] resignedAsKeyView];
}

- (IBAction)toggleExtraPostInfo:(id)sender{
  int sizeOfMorePrefs = 25;
  
  if(showingExtraInfo){
    [moreOptionsButton setTitle:[NSString localizedStringWithFormat:@"More Info"]];

    showingExtraInfo = false;
    [moreOptionsView removeFromSuperview];
    magicFooterNumber -= sizeOfMorePrefs;
    NSRect newFrame =  [mainWindow frame];
    newFrame.size.height -= sizeOfMorePrefs;
    [mainWindow setFrame:newFrame display:true animate:true];
    NSRect resizedFrame = [mainWindowContentView frame];
    resizedFrame.size.height -= magicFooterNumber;
    resizedFrame.origin.y += magicFooterNumber;
    
    [currentView setFrame:resizedFrame];
    
  }else{
      [moreOptionsButton setTitle:[NSString localizedStringWithFormat:@"Hide Info"]];
    showingExtraInfo = true;
    magicFooterNumber += sizeOfMorePrefs;  
    NSRect newFrame =  [mainWindow frame];
    newFrame.size.height += sizeOfMorePrefs;
    
    [mainWindow setFrame:newFrame display:true animate:true];
    [[mainWindow contentView] addSubview:moreOptionsView];

    
    //resize current view
    newFrame = [[mainWindow contentView] frame];
    newFrame.origin.y  += magicFooterNumber;
  //  newFrame.size.height -= sizeOfMorePrefs;
    newFrame.size.height -= magicFooterNumber;
    [currentView setFrame:newFrame];
    
    //add prefs
    newFrame.origin.x = 0;
    newFrame.origin.y = sizeOfMorePrefs - 4;
    newFrame.size.height = [moreOptionsView frame].size.height;
    newFrame.size.width = [[mainWindow contentView] frame].size.width;
    [moreOptionsView setFrame:newFrame];
   }
}//toggleExtraPostInfo

- (void) setLoggedIn:(bool) newBool{
  loggedIn  = newBool;
}

- (bool)loggedIn{
  return loggedIn;
}

- (void)importTextContentWithBody:(NSString *)aBody title:(NSString *) aTitle summary:(NSString *)aSummary
                         link:(NSString *)aLink source:(NSString *) aSource asType:(int)type{
  if(type == 99){
    type = [[[NSUserDefaults standardUserDefaults] objectForKey:@"importedTextIndex"] intValue];
  }
  
  switch (type) {
    case 1:// quote
      [quoteController setQuote: aBody];
      [quoteController setDescription: aSource];
      [self setCurrentViewIndex:2];
      break;
      
    case 2:// link
      [linkController setLink: aLink];
      [linkController setTitle:  aTitle];
      [linkController setDescription: aBody];
      [self setCurrentViewIndex:3];
      break;

    case 3:// conversation
      [conversationController setConversation:aBody];
      [conversationController setTitle:aTitle];
      [self setCurrentViewIndex:4];
      
      break;
      
    case 0: //Text import
    default:
      [textController setBody:aBody];
      [textController setTitle:aTitle];
      [self setCurrentViewIndex:0];
      break;
  }
}

- (void)importFileContentWithPath:(NSString *)path andDescription:(NSString*) description{
  log(@"importing file with path %@", path );
  int type = [TumblrController fileTypeForFilePath:path];
  switch (type) {
    case 1:
      // image
      [imageController setSource: path];
      [imageController setCaption: description];
      [self setCurrentViewIndex:1];
      
      break;
    
    case 6:
      [videoController setSource: path];
      [videoController setCaption: description];

      [self setCurrentViewIndex:6];
      // video
      break;

    case 5:
      [audioController setSource: path];
      [audioController setCaption: description];

      [self setCurrentViewIndex:5];
      // audio
      break;
    default:
      log(@"unknown file type");
      break;
  }
  
}
- (IBAction)newTextPost:(id)sender{
  [textController setBody:@""];
  [self setCurrentViewIndex:0];
}

#pragma mark iMedia Delegate methods, app wide
- (void)iMediaConfiguration:(iMediaConfiguration *)configuration doubleClickedSelectedObjects:(NSArray*)selection{
  log(@"click!");
  [self importFileContentWithPath: [[selection objectAtIndex:0] stringValue] andDescription:@""];
}

- (void)iMediaConfiguration:(iMediaConfiguration *)configuration didSelectNode:(iMBLibraryNode *)node{
  // this is when you change the type of library we're looking in
  log(@"blick!");
}


- (BOOL)iMediaConfiguration:(iMediaConfiguration *)configuration willUseMediaParser:(NSString *)parserClassname forMediaType:(NSString *)media{
  //these are useless, get lost.

  if([parserClassname compare:@"iMBiLifeSoundEffectsParser"] == NSOrderedSame ) return NO;
  if([parserClassname compare:@"iMBiMovieSoundEffectsParser"]== NSOrderedSame) return NO;
  if([parserClassname compare:@"iMBLibrarySoundsParser"]== NSOrderedSame) return NO;
  return YES;
}

- (void) networkDown{
  [self setLoggedIn:false];
}

- (void) doubleClickInPhotosBrowser: (NSNotification *)notification{
  if([[[notification userInfo] objectForKey:@"Selection"] objectAtIndex:0]){
    NSString* imagePath = [[[[notification userInfo] objectForKey:@"Selection"] objectAtIndex:0] objectForKey:@"ImagePath"];
    NSString* caption = [[[[notification userInfo] objectForKey:@"Selection"] objectAtIndex:0] objectForKey:@"Caption"];

    [self importFileContentWithPath:imagePath andDescription: caption];
  }
}

+ (int) fileTypeForFilePath: (NSString *) filename{
  NSString	*extension = [filename pathExtension];
  NSString * filetype;
  for ( filetype in [NSImage imageFileTypes] ) {
    if([extension caseInsensitiveCompare: filetype] == NSOrderedSame){
      log(@"found image file type");
      return 1;
    }
  }
  
  if (([extension caseInsensitiveCompare:@"mp3"] == NSOrderedSame)  ||
      ([extension caseInsensitiveCompare:@"aiff"] == NSOrderedSame) ||
      ([extension caseInsensitiveCompare:@"wav"] == NSOrderedSame)  ||
      ([extension caseInsensitiveCompare:@"aac"] == NSOrderedSame)  ||
      ([extension caseInsensitiveCompare:@"m4a"] == NSOrderedSame)){
    log(@"found audio filetype");
    return 5;
  }
  if (([extension caseInsensitiveCompare:@"avi"] == NSOrderedSame) ||
      ([extension caseInsensitiveCompare:@"mpg"] == NSOrderedSame) ||
      ([extension caseInsensitiveCompare:@"png"] == NSOrderedSame) ||
      ([extension caseInsensitiveCompare:@"mp4"] == NSOrderedSame) ||
      ([extension caseInsensitiveCompare:@"m4v"] == NSOrderedSame)){
    log(@"found video filetype");
    return 6;
  }
  log(@"not found anything for file type: %@", extension);
  return 99;  
}

@end
