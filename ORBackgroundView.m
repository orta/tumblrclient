//
//  ORBackgroundView.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ORViews.h"
#import <Quartz/Quartz.h>

@implementation ORBlueyBackgroundView

- (void)drawRect:(NSRect)rect {
  [[NSColor colorWithDeviceRed: 0.27f green: 0.35f blue: 0.49f alpha: 1.0f] set];
  NSRectFill([self bounds]);
}
@end

@implementation ORWhiteBackgroundView

- (void)drawRect:(NSRect)rect {
  [[NSColor colorWithDeviceRed: 1.0f green: 1.0f blue: 1.0f alpha: 1.0f] set];
  NSRectFill([self bounds]);
}
@end

@implementation ORKindaBlackBackgroundView

- (void)drawRect:(NSRect)rect {
  [[NSColor colorWithDeviceRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.7f] set];
  NSRectFill([self bounds]);
}
@end

@implementation ORBlackBackgroundView

- (void) awakeFromNib{
  _showingFilters = false;
  [self setWantsLayer:true];
}

- (void) toggleFilter{
//  if(_showingFilters){
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:[NSNumber numberWithFloat:0.0f] forKey:@"inputRadius"];  
//    [self setBackgroundFilters:[NSArray arrayWithObject:filter]];
//    _showingFilters = false;
//    
//  }else{
//    [NSTimer scheduledTimerWithTimeInterval:0.3  target:self selector:@selector(turnOnFilter) userInfo:nil repeats:false];
//    _showingFilters = true;
//  }
}
- (void)cursorUpdate:(NSEvent *)event{}
- (void)mouseEntered:(NSEvent *)theEvent{}

- (void) turnOnFilter{
//  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//  [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputRadius"];  
//  [self setBackgroundFilters:[NSArray arrayWithObject:filter]];
  [[self window] invalidateCursorRectsForView:self];
  NSCursor * cursor = [NSCursor crosshairCursor];
  [self addCursorRect:[self bounds] cursor:cursor];
  [cursor setOnMouseEntered:true];
  
}

-(void)mouseDown:(NSEvent *)event{
}
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent{
  return true;
}
- (BOOL)isOpaque{
  return true;
}

- (void)drawRect:(NSRect)rect {
  [[NSColor colorWithDeviceRed: 0.0f green: 0.0f blue: 0.0f alpha: 0.8f] set];
  NSRectFill([self bounds]);
}


@end
