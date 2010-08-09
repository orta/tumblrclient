//
//  NSURL_UrlFromFSRef.h
//  Tumblg
/*
 *  NSURL+NDCarbonUtilities.m category
 *  AppleScriptObjectProject
 *
 *  Created by nathan on Wed Dec 05 2001.
 *  Copyright 2001-2007 Nathan Day. All rights reserved.
 */


#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

@interface NSURL (NDCarbonUtilities)

+ (NSURL *)URLWithFSRef:(const FSRef *)fsRef;

@end
