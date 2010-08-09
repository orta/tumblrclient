//
//  LinkController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LinkController : NSObject {
  IBOutlet NSTextField *urlField;
  IBOutlet NSTextField *urlNameField;
  IBOutlet NSTextView *urlDescriptionTextField;
  IBOutlet NSWindow * mainWindow;
  
}

- (void) setLink:(NSString*) link;
- (void) setTitle:(NSString*) title;
- (void) setDescription:(NSString*) description;
- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

@end
