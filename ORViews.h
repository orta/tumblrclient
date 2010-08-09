/*
 *  ORViews.h
 *  Tumblor
 *
 *  Created by orta on 03/08/2008.
 *  Copyright 2008 __MyCompanyName__. All rights reserved.
 *
 */

#include <Cocoa/Cocoa.h>

@interface ORBlueyBackgroundView : NSView {} @end
@interface ORKindaBlackBackgroundView : NSView {} @end
@interface ORWhiteBackgroundView : NSView {} @end
@interface ORTiledBackgroundView : NSView {} @end
@interface ORExtrasGradientView : NSView {} @end

@interface ORBlackBackgroundView : NSView {
  bool _showingFilters;
}
- (void) turnOnFilter;
- (void)mouseDown:(NSEvent *)event;
- (void)cursorUpdate:(NSEvent *)event;
- (BOOL)isOpaque;
- (void) toggleFilter;
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
@end

