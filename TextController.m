//
//  TextController.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TextController.h"
#import "NSString_URLEncoding.h"

@implementation TextController

- (void) awakeFromNib{
  _firstRun = true;
}


- (void) setBody:(NSString * ) body{
  [bodyHTMLField setString:body];
}

- (void) setTitle:(NSString * ) title{
  [titleTextField setStringValue:title];
}

- (void) hasBecomeKeyView{
  if(_firstRun){
  } 
  NSLog(@"%@", [mainWindow initialFirstResponder]);

  [mainWindow setInitialFirstResponder:titleTextField];
  //NSLog(@"%@", [[mainWindow initialFirstResponder] stringValue];);

  NSLog(@"setInitialFirstResponder");
  NSLog(@"%@", [mainWindow initialFirstResponder]);
  
}

- (void) resignedAsKeyView{
  
}

- (void) clear{
  [self setBody:@""];
  [self setTitle:@""];
}

- (NSDictionary *) values{
  return [NSDictionary dictionaryWithObjectsAndKeys:
                        [[[bodyHTMLField textStorage] string] urlEncodeValue], @"body",
                        [titleTextField stringValue], @"title", nil];
  
  
}

@end
