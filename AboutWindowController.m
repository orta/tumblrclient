//
//  AboutWindowController.m
//  Tumblg
//
//  Created by orta on 11/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AboutWindowController.h"


@implementation AboutWindowController

- (void) awakeFromNib{
  [quartzView loadCompositionFromFile:[[NSBundle mainBundle] pathForResource: @"Tumblgabout"  ofType:@"qtz"]]; 
}
                    

@end
