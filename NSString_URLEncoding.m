//
//  NSString_URLEncoding.m
//  Tumblor
//
//  Created by orta on 23/07/2008.
//  Copyright 2008 ortatherox. All rights reserved.
//

#import "NSString_URLEncoding.h"


@implementation NSString (URLEnc)

- (NSString *)urlEncodeValue{
  NSString *result = (NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("?=&+"), kCFStringEncodingUTF8);
  return [result autorelease];
}
- (NSString *)urlUnEncodeValue{
  NSString *result = (NSString *) CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8);
  return [result autorelease];
}


@end
