//
//  TextController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface TextController : NSObject {
  IBOutlet NSTextField * titleTextField;
  IBOutlet NSTextView * bodyHTMLField;
  IBOutlet NSWindow * mainWindow;

  bool _firstRun;
}
- (void) setBody:(NSString * ) body;
- (void) setTitle:(NSString * ) title;

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;
- (NSDictionary *) values;


@end
