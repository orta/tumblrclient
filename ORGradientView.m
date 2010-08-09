//
//  ORGradientView.m
//  Tumblor
//
//  Created by orta on 02/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ORViews.h"


@implementation ORExtrasGradientView

- (void)drawRect:(NSRect)rect {
  NSColor* topColour = [NSColor colorWithDeviceRed:0.635f green:0.694f blue:0.811f alpha:1.0f];
  NSColor * bottomColour = [NSColor colorWithDeviceRed:0.47f green:0.541f blue:0.694f alpha:1.0f];
  NSGradient * grad = [[NSGradient alloc] initWithStartingColor:topColour endingColor:bottomColour];
  [grad drawInRect:[self bounds] angle:270];
  
 // background-image: -webkit-gradient(linear, left top, left bottom, from(rgb(162, 177, 207)), to(rgb(120, 138, 177)));

  
}

@end
