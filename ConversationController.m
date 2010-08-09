//
//  ConversationController.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ConversationController.h"


@implementation ConversationController

- (void) hasBecomeKeyView{
  [mainWindow setInitialFirstResponder: titleTextView];
}
- (void) resignedAsKeyView{
  
}

-(void) setTitle:(NSString*) title{
  [titleTextView setStringValue:title];
}

-(void) setConversation:(NSString*) chat{
  [chatTextView setString:chat];
}

- (void) clear{
  [chatTextView setString:@""];
  [titleTextView setStringValue:@""];

}

- (NSDictionary *) values{
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [chatTextView string], @"conversation",
          [titleTextView stringValue], @"title",
          nil];  
}

@end
