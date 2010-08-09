//
//  TumblrQSHandler.m
//  Tumblg
//
//  Created by orta on 10/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TumblrQSHandler.h"


@implementation TumblrQSHandler

+ (void) dealWithPath: (NSString *) path{	
  NSArray  * paths =  NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory,NSUserDomainMask, YES);
  NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex: 0] : NSTemporaryDirectory();
  NSString * destinationFilePath =  [basePath stringByAppendingPathComponent:@"Quicksilver"] ;
  destinationFilePath =  [destinationFilePath stringByAppendingPathComponent:@"Actions"];
  // add the correct filename, not including the filetype
  destinationFilePath = [destinationFilePath stringByAppendingPathComponent:[[path lastPathComponent] stringByDeletingPathExtension] ];
  destinationFilePath = [destinationFilePath stringByAppendingPathExtension:@"scpt"];
  //out with the old version if it exists
  [[NSFileManager defaultManager] removeFileAtPath:destinationFilePath handler:nil];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    if ([[NSFileManager defaultManager] copyPath:path toPath:destinationFilePath handler:nil]) {
      log(@"successful install of script to QS");
    }else{
      log(@"failed install of script to QS");
    }
  }  
}
@end
