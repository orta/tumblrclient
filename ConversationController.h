//
//  ConversationController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ConversationController : NSObject {
  IBOutlet NSTextField * titleTextView;
  IBOutlet NSTextView * chatTextView;
  IBOutlet NSWindow * mainWindow;

}

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

-(void) setTitle:(NSString*) title;
-(void) setConversation:(NSString*) chat;
-(void) clear;

- (NSDictionary *) values;

@end
