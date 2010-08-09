//
//  TumblrBGView.m
//  Tumblg
//
//  Created by orta on 14/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TumblrBGView.h"

#define vertical_margin 20
#define horizontal_margin 20
#define border_width 10


@implementation TumblrBGView

- (void)drawRect:(NSRect)rect {
  NSRect bounds = [self bounds];
  bounds.origin.x += horizontal_margin;
  bounds.size.width -= horizontal_margin *2;
  bounds.size.height -= vertical_margin;
  
  NSBezierPath*    clipShape = [NSBezierPath bezierPath];
  [clipShape appendBezierPathWithRoundedRect:bounds xRadius:16 yRadius:16];
  
  // create outer gradient
  NSGradient* aGradient = [[[NSGradient alloc]
                            initWithColorsAndLocations:[NSColor colorWithDeviceRed:0.21 green:0.27 blue:0.39 alpha:1.0], (CGFloat)0.0,
                            [NSColor colorWithDeviceRed: 0.27f green: 0.35f blue: 0.49f alpha: 1.0f], (CGFloat)0.8,
                            nil] autorelease];
  

  [aGradient drawInBezierPath:clipShape angle:270.0];
  //reset path and draw inner rect
  [clipShape removeAllPoints];
  bounds.size.width -= border_width *2;
  bounds.size.height -= border_width;
  bounds.origin.x += border_width;
  [clipShape appendBezierPathWithRoundedRect:bounds xRadius:8 yRadius:8];
  
  aGradient = [[[NSGradient alloc]
                            initWithColorsAndLocations:[NSColor whiteColor], (CGFloat)0.0,
                            [NSColor whiteColor], (CGFloat)1.0,
                            nil] autorelease];
  NSRect bottomRect = bounds;
  bottomRect.size.height = 8;
  bottomRect.origin.y = bottomRect.size.height - 8;
  
  [clipShape appendBezierPathWithRect:bottomRect];
  
  [aGradient drawInBezierPath:clipShape angle:0.0];
  
}


- (BOOL)acceptsFirstResponder{
  NSLog(@"HI ------------------");
  return NO;
}

- (BOOL)becomeFirstResponder{
  NSLog(@"HI ===========");
  return NO;
}


@end
