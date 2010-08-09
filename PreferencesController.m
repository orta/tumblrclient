//
//  PreferencesController.m
//  Tumblor
//
//  Created by orta on 26/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController
- (void) awakeFromNib{
  [self changeCloseAppText:nil];
}

- (IBAction)changeCloseAppText:(id)sender{
  if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"openBlogAfterPost"]  boolValue] == true ){
    NSLog(@"1");
    [closeAppButton setTitle:@"then close Tumblg."];  
  }else{
    NSLog(@"2");
    [closeAppButton setTitle:@"Close Tumblg after posting."];
  }
}


@end
