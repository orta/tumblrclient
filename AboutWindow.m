//
//  AboutWindow.m
//  Tumblg
//
//  Created by orta on 21/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AboutWindow.h"


@implementation AboutWindow

- (void)keyDown:(NSEvent *)theEvent{
  NSString *characters;
  unichar c;
  unsigned int characterIndex, characterCount;
  
  // There could be multiple characters in the event.
  characters = [theEvent charactersIgnoringModifiers];
  
  characterCount = [characters length];
  for (characterIndex = 0; characterIndex < characterCount;
       characterIndex++)
  {
    c = [characters characterAtIndex: characterIndex];
    switch(c){
      case '\r': //Return
      case '\t': //Tab
      case 25: //Back Tab
      case 27: //Escape
        [self orderOut:self];
        return;
    }
  }  
}

-(void) awakeFromNib{
  [self makeKeyAndOrderFront:self];
}

@end
