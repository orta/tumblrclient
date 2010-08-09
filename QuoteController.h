//
//  QuoteController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "NSString_URLEncoding.h"

@interface QuoteController : NSObject {
  
  IBOutlet WebView *quoteWebView;
  IBOutlet NSTextView *descriptionTextField;  
  IBOutlet NSWindow * mainWindow;

}

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;
- (void) setQuote: (NSString*) quote;
- (void) setDescription: (NSString*) description;
- (NSDictionary *) values;

@end
