//
//  QuoteController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "QuoteController.h"


@implementation QuoteController

- (void) awakeFromNib{

  NSString * path =  [[NSBundle mainBundle] pathForResource: @"quote" ofType:@"html"];
  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
  [[quoteWebView mainFrame] loadRequest:request];
  [quoteWebView setDrawsBackground: NO];
  [self setQuote:@"asdasda"];
}

- (void) hasBecomeKeyView{
  
  [mainWindow setInitialFirstResponder:quoteWebView];
}
- (void) resignedAsKeyView{
  
}

- (void) setQuote: (NSString*) quote{
  id win = [quoteWebView windowScriptObject];
  [win evaluateWebScript:[NSString stringWithFormat:@"document.getElementById('text').innerHTML = '%@'", quote]];
 // NSLog(@"content %@", [paragraphNode textContent] );
}

- (void) setDescription: (NSString*) description{
  [descriptionTextField setString:description];
}



- (void) clear{
  [self setQuote: @"..."];
  [self setDescription:@""];
}  

- (NSDictionary *) values{
  id win = [quoteWebView windowScriptObject];
  NSString *href = [win evaluateWebScript:@"document.getElementById('text').innerHTML"];
  return [NSDictionary dictionaryWithObjectsAndKeys:
          
          href, @"quote",
          [descriptionTextField string], @"source",
          nil];
}


@end
