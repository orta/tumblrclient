//
//  ORBackgroundView.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ORViews.h"

@implementation ORTiledBackgroundView

- (void)drawRect:(NSRect)rect {
  
  [[NSGraphicsContext currentContext] saveGraphicsState];
  [[NSGraphicsContext currentContext] setPatternPhase:NSMakePoint(0,[self frame].size.height)];
  NSImage *anImage = [NSImage imageNamed:@"tumblr-bg"];
  [[NSColor colorWithPatternImage:anImage] set];
  NSRectFill([self bounds]);
  [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end
