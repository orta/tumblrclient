//
//  NSURL_UrlFromFSRef.m
//  Tumblg
// From  NSURL+NDCarbonUtilities.h
// @header NSURL+NDCarbonUtilities
// @abstract Provides method for interacting with Carbon APIs.
// @discussion The methods in <tt>NSURL(NDCarbonUtilities)</tt> are simply wrappers for functions that can bew found within the Carbon API.
// @copyright &#169; 2007 Nathan Day. All rights reserved.
//

#import "NSURL_UrlFromFSRef.h"

@implementation NSURL (NDCarbonUtilities)

/*
 + URLWithFSRef:
 */
+ (NSURL *)URLWithFSRef:(const FSRef *)aFsRef
{
	CFURLRef theURL = CFURLCreateFromFSRef( kCFAllocatorDefault, aFsRef );
  
	/* With garbage collection, toll free bridging is not so perfect; must always match CFCreate...() and CFRelease().
   Put another way, don't autorelease objects created by CFCreate...() functions */
#ifndef __OBJC_GC__
	[(NSURL *)theURL autorelease];
#else
	CFMakeCollectable( theURL );
#endif
  
	return (NSURL*)theURL;
}
@end
