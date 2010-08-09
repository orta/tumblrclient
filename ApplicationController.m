//
//  ApplicationController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ApplicationController.h"
#import "NSURL_UrlFromFSRef.h"
#import <iMediaBrowser/iMediaBrowser.h>
#import "MMICrashReporterBridge.h"

@implementation ApplicationController

- (void) awakeFromNib{
    
  [self registerDefaults];
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self
                                                     andSelector: @selector (recievedRSSEvent: withReplyEvent:)
                                                   forEventClass: EditDataItemAppleEventClass
                                                      andEventID: EditDataItemAppleEventID];
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self
                                                     andSelector: @selector (post: withReplyEvent:)
                                                   forEventClass: TumblrPostClass 
                                                      andEventID: TumblrPostEventID];
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self
                                                     andSelector: @selector (postFile: withReplyEvent:)
                                                   forEventClass: TumblrPostClass 
                                                      andEventID: TumblrPostFileEventID];
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self
                                                     andSelector: @selector (send: withReplyEvent:)
                                                   forEventClass: TumblrPostClass 
                                                      andEventID: TumblrPostSendID];
  
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                     andSelector:@selector(gotIncomingURL: withReplyEvent:) 
                                                   forEventClass:kInternetEventClass
                                                      andEventID:kAEGetURL];  
  log(@"added events");
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setiMediaDelegate) name:@"ORAniMediaViewActivated" object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSucceeded) name:@"ORPostedSuccessfully" object:nil];

}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename{
  log(@"application open file = %@", filename);
  NSString *extension = [filename pathExtension];

  if ([extension caseInsensitiveCompare:@"qsscpt"] == NSOrderedSame ||
      [extension caseInsensitiveCompare:@"scpt"] == NSOrderedSame  ) {
    [TumblrQSHandler dealWithPath: filename];
    return YES;
  }
  
  [tumblrController importFileContentWithPath:filename andDescription:@""];
  return YES;
}	

- (IBAction)bugReport:(id)sender{
  [MMICrashReporterBridge reportBug];
}

- (void) gotIncomingURL:(NSAppleEventDescriptor*) event withReplyEvent:(NSAppleEventDescriptor *) reply{
  NSString *incomingURL = [[event descriptorForKeyword: '----'] stringValue];
  incomingURL = [incomingURL urlUnEncodeValue];
  NSArray *fields = [incomingURL componentsSeparatedByString:@"&"];
  NSEnumerator *e = [fields objectEnumerator];
  NSString *field = @"";
  NSString *url = @"";
  NSString *title = @"";
  int type = 99;
  NSString *description = @"";
  while ((field = [e nextObject])) {
    NSArray *keyvalue = [field componentsSeparatedByString:@"="];
    NSString *key = [keyvalue objectAtIndex:0] ;
    NSString *value = [keyvalue objectAtIndex:1];
    log(@"key = '%@' - value = '%@'", key, value); 
    if([key caseInsensitiveCompare:@"Tumblg:url"] == NSOrderedSame){
      url = value;
    }
    else if ([key caseInsensitiveCompare:@"title"] == NSOrderedSame) {
      title = value;
    }
    else if ([key caseInsensitiveCompare:@"description"] == NSOrderedSame) {
      description = value;
    }
    else if ([key caseInsensitiveCompare:@"type"] == NSOrderedSame) {
      type = [value intValue];
    
    }else{
      //incase of & signs in URL
      NSLog(@"don't know this key %@", key);
      url = [url stringByAppendingString:value];
    }
  }
  [tumblrController importTextContentWithBody:description title:title summary:@"" link:url source:title asType:type];
}


- (void) recievedRSSEvent: (NSAppleEventDescriptor *) event
           withReplyEvent: (NSAppleEventDescriptor *) reply {
  
  NSAppleEventDescriptor *recordDescriptor = [event descriptorForKeyword: keyDirectObject];
  NSString *title = [[recordDescriptor descriptorForKeyword: DataItemTitle] stringValue];
  NSString *body = [[recordDescriptor descriptorForKeyword: DataItemDescription] stringValue];
  NSString *summary = [[recordDescriptor descriptorForKeyword: DataItemSummary] stringValue];
  NSString *link = [[recordDescriptor descriptorForKeyword: DataItemLink] stringValue];
//  NSString *permalink = [[recordDescriptor descriptorForKeyword: DataItemPermalink] stringValue];
  NSString *sourceName = [[recordDescriptor descriptorForKeyword: DataItemSourceName] stringValue];
  //NSString *sourceHomeURL = [[recordDescriptor descriptorForKeyword: DataItemSourceHomeURL] stringValue];
  [tumblrController importTextContentWithBody:body title:title summary:summary link:link source:sourceName asType:99];
  
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
	[self setiMediaDelegate];
  if([tumblrController loggedIn] == true){
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORUserLoggedIn" object:@""];   
  }
}


+ (NSString *)applicationSupportDirectory {	
  return [[[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Application Support"] stringByAppendingPathComponent:@"Tumblg"];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication{
  return YES;
}


  // from applescript post "x" as type "y"
-(void) post:(NSAppleEventDescriptor *) event
  withReplyEvent: (NSAppleEventDescriptor *) reply{
  
  NSString *text = [[event descriptorForKeyword: PostText] stringValue];
  NSString* type = [[event descriptorForKeyword: PostType] stringValue];
  int postType = 99;
  log(@"post text = %@ - type = %i", text, type);
  if([type caseInsensitiveCompare:@"text"] == NSOrderedSame){
    postType = 0;
  }
  else if ([type caseInsensitiveCompare:@"quote"] == NSOrderedSame) {
    postType = 2;
  }
  else if ([type caseInsensitiveCompare:@"chat"] == NSOrderedSame) {
    postType = 3;
  }
  else if ([type caseInsensitiveCompare:@"link"] == NSOrderedSame) {
    postType = 4;
  }
  [tumblrController importTextContentWithBody:text title:@"" summary:text link:text source:@"" asType:postType];
}

// from applescript post file "x" with description "y"
-(void) postFile:(NSAppleEventDescriptor *) event
withReplyEvent: (NSAppleEventDescriptor *) reply{
  log(@"file posted event = %@", event);
  NSString *description = [[event descriptorForKeyword: PostImageDescription] stringValue];

  // Based on Adium's NSAppleEventDescriptor+NDAppleScriptObject
  id					theURL = nil;
	OSAError			theError;
  unsigned int	theSize;
  Handle			theAliasHandle;
  FSRef				theTarget;
  Boolean			theWasChanged;
  
  theSize = (unsigned int)AEGetDescDataSize([[event descriptorForKeyword: '----'] aeDesc]);
  theAliasHandle = NewHandle( theSize );
  HLock(theAliasHandle);
  theError = AEGetDescData([[event descriptorForKeyword: '----'] aeDesc], *theAliasHandle, theSize);
  HUnlock(theAliasHandle);
  if( theError == noErr  && FSResolveAlias( NULL, (AliasHandle)theAliasHandle, &theTarget, &theWasChanged ) == noErr ){
    theURL = [NSURL URLWithFSRef:&theTarget];
  }
  
  DisposeHandle(theAliasHandle);
  
  [tumblrController importFileContentWithPath:[theURL path] andDescription:description];
}

-(void) send:(NSAppleEventDescriptor *) event withReplyEvent: (NSAppleEventDescriptor *) reply{
  log(@"send event recieved = %@", event);
  [postController post:self];
}

- (BOOL)application:(NSApplication *)sender delegateHandlesKey:(NSString *)key {
  log(@"%@ - delegateHandlesKey", key);
  return YES;
}

- (void) registerDefaults{
  log(@"registering defaults");
  NSDictionary* defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"1", @"storePasswordInKeychain",
                            @"1", @"superfluousVisualEffects",
                            nil];
  
  NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
  [defs registerDefaults: defaults];
  [defs synchronize];
}

- (void) setiMediaDelegate{
  NSLog(@"delegating");
  [[iMediaConfiguration sharedConfiguration] setDelegate:tumblrController];
}

- (IBAction) aboutApp:(id)sender{
  [NSBundle loadNibNamed:@"About" owner:self];
}

- (void)postSucceeded{
  
  if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"openBlogAfterPost"] boolValue] ){
    NSLog(@"TODO: open blog");
//    [tumblrController openCurrentBlog];
  }
  if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"openBlogAfterPost"] boolValue] ){
    NSLog(@"TODO: close app");
    
  }
}
@end