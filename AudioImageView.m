//
//  AudioImageView.m
//  Tumblg
//
//  Created by orta on 10/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioImageView.h"


@implementation AudioImageView

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
  if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])  == NSDragOperationGeneric){    
		[self setNeedsDisplay:YES];
		NSPasteboard *pboard = [sender draggingPasteboard];
		NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
    NSString *extension =  [fileName pathExtension];
    if (([extension caseInsensitiveCompare:@"mp3"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"aiff"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"aac"] == NSOrderedSame)  ||
        ([extension caseInsensitiveCompare:@"wav"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"m4a"] == NSOrderedSame)){
			return NSDragOperationCopy;
		}
  }
  return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
  [audioController setSource:fileName];
  return YES;
}

@end
