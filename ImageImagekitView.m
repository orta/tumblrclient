//
//  ImageImagekitView.m
//  Tumblg
//
//  Created by orta on 21/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ImageImagekitView.h"


@implementation ImageImagekitView
- (void) awakeFromNib{
  [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender{
  NSPasteboard *pboard = [sender draggingPasteboard];
  NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
  NSString *extension =  [fileName pathExtension];
  NSLog(@"ext = %@", extension);
  NSString *filetype;
  for ( filetype in [NSImage imageFileTypes] ) {
    if([extension caseInsensitiveCompare: filetype] == NSOrderedSame){
      return NSDragOperationCopy;
    }
  }
  return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
  [imageController setSource:fileName];
  return YES;
}

@end
