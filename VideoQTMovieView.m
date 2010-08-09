//
//  VideoQTMovieView.m
//  Tumblg
//
//  Created by orta on 13/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "VideoQTMovieView.h"


@implementation VideoQTMovieView

- (void) awakeFromNib{
  [self registerForDraggedTypes:[NSArray arrayWithObjects: NSFilenamesPboardType, nil]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{

 // if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])  == NSDragOperationGeneric){    
		[self setNeedsDisplay:YES];
		NSPasteboard *pboard = [sender draggingPasteboard];
		NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
    NSString *extension =  [fileName pathExtension];
    log(@" ext = %@", extension);
    
    if (([extension caseInsensitiveCompare:@"mp4"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"avi"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"flv"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"mov"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"mpg"] == NSOrderedSame) ||
        ([extension caseInsensitiveCompare:@"wmv"] == NSOrderedSame)){
			return NSDragOperationCopy;
	//	}
  }
  return NSDragOperationNone;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	NSString *fileName = [[pboard propertyListForType:NSFilenamesPboardType] objectAtIndex: 0];
  [videoController setSource:fileName];
  return YES;
}
@end
