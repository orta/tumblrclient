//
//  PreferencesController.h
//  Tumblor
//
//  Created by orta on 26/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PreferencesController : NSObject {
  IBOutlet NSButton* closeAppButton;
}
- (IBAction)changeCloseAppText:(id)sender;

@end
