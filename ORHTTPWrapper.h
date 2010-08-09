//
//  ORHTTPWrapper.h
//
//  Created by orta on 09/08/2008.
//  Copyright 2008 ortatherox. All rights reserved.
//
//
#import <Cocoa/Cocoa.h>

@class ORHTTPRequest;

@protocol HTTPRequest <NSObject>

@optional

- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code;    
- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithData: (NSData *) data;
- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data;

- (void) HTTPConnectionFailed: (ORHTTPRequest *) httpReq;
- (void) httpRequest:(ORHTTPRequest *) httpReq DidRecieveResponse: (NSHTTPURLResponse *) response;
- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error;

@end

@interface ORHTTPRequest : NSObject {
  NSString * requestPath;
  
  id <HTTPRequest> _delegate;
  NSHTTPURLResponse *_response;
  NSURLConnection *_connection;
  NSMutableData *_receivedData;
  
}

- (id) initWithDelegate:(id)myDelegate;
- (void) multiPathPostRequestWithParams:(NSDictionary *)params;
- (void) postRequestWithParams: (NSDictionary *)params;  
- (void) multiPartPostRequestWithPath: (NSString *) path params:(NSDictionary *)params;
@property(copy, readwrite) NSString *requestPath;

//private
- (void) _multiPartPostRequestWithData: (NSData *) data params:(NSDictionary *)params filename:(NSString* ) filename;



@end


