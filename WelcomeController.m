//
//  WelcomeController.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WelcomeController.h"
#import "MMICrashReporterBridge.h"
#import "EMKeychainProxy.h"

@implementation WelcomeController

- (void) awakeFromNib{
  defaultPage = @"welcome";
}

- (void) hasBecomeKeyView{
  [introView setPolicyDelegate:nil];
  NSString * path =  [[NSBundle mainBundle] pathForResource: defaultPage ofType:@"html"];
  NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
  [[introView mainFrame] loadRequest:request];
  [introView setDrawsBackground: NO];
  [introView setPolicyDelegate:self];
  [introView setMaintainsBackForwardList: NO];
}
 

- (void) resignedAsKeyView{
  [[introView mainFrame] loadHTMLString:@"" baseURL:nil];
  [introView release];
}

- (void)webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener{
  NSArray *listItems = [[[request URL] relativePath] componentsSeparatedByString:@"/"];
  NSString * value = [listItems lastObject];
  //we can use custom URLs to load code from here.
  log(@"clicked on %@", value);

  if([value isEqual: @"login"]){
    [connectionController login:nil];
  }
  else if([value isEqual: @"blog"]){
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://blog.ortatherox.com/tags/useful"]];
  }
  
  else if([value isEqual: @"blog2"]){
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://carolineg.com"]];

  }
  
  else if([value isEqual: @"register"]){

    if([mainWindow frame].size.width < 755){
      NSRect newFrame = [mainWindow frame];
      newFrame.size.width = 755;
      [mainWindow setFrame:newFrame display:YES animate:YES];
    }
    [listener use];
    
    
  }
  else if([value isEqual: @"advanced.html"]){
    [listener use];
  }
  

  else if([value isEqual: @"advanced"]){
    NSString * path =  [[NSBundle mainBundle] pathForResource: @"advanced" ofType:@"html"];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
    [[introView mainFrame] loadRequest:request];    
  }
  
  else if([value isEqual:@"welcome"]){
    //user has logged in
    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://tumblr.com/customize"]];
    [[introView mainFrame] loadRequest:request]; 
    
  }

  else if([value isEqual: @"dashboard"]){
    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://tumblr.com/logout"]];
    [[introView mainFrame] loadRequest:request];    

  }
  else if([value isEqual: @""]){
    NSLog(@"%@", [listItems objectAtIndex:0]);
    NSURLRequest * request = [NSURLRequest requestWithURL: [NSURL URLWithString:@"http://tumblr.com/register"]];
    [[introView mainFrame] loadRequest:request];    
  }
  
  else if([value isEqual:@"email"]){
    [MMICrashReporterBridge reportBug];  
  }else{ //vanity vanity vanity
    log(@"webview using!");
    [listener use];
  }
}


// user goes to register, fills it in
// register redirects to / 
// so we need to get this case and send to 
//  /customize so that they can name their blog
//http://www.tumblr.com/customize

@synthesize defaultPage;
@end
