//
//  ORHTTPWrapper.m
//
//  Created by orta on 09/08/2008.
//  Copyright 2008 ortatherox. All rights reserved.
//

#define  HTTP_REQUEST_DEBUG

#ifdef	HTTP_REQUEST_DEBUG
#define orLog(X,...)	NSLog(X,##__VA_ARGS__)
#else
#define orLog(X,...)	{ ; }
#endif

#import "ORHTTPWrapper.h"


@implementation ORHTTPRequest : NSObject

@synthesize requestPath;

- (id) initWithDelegate:(id)myDelegate {
  self = [super init];
  _connection = NULL;
  _receivedData = NULL;
  _response = NULL;
  _delegate = myDelegate;
  //escapeStrings = true;
  return self;
}

#pragma mark Blah blah

// convienience method
- (void) multiPartPostRequestWithPath: (NSString *) path params:(NSDictionary *)params{
    
  orLog(@"[%@ multiPartPostRequestWithPath: path: %@ params:%@]", [self class], path, params);
  NSData *  data  = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];  
  [self _multiPartPostRequestWithData:data params:params filename:path];
}

- (void) multiPathPostRequestWithParams:(NSDictionary *) params{
  orLog(@"[ multiPartPostRequestWithParams: %@]", params);
  [self _multiPartPostRequestWithData:nil  params:params filename:@""];
}

- (void) _multiPartPostRequestWithData: (NSData *) data params:(NSDictionary *)params filename:(NSString* ) filename{  
  orLog(@"[%@ multiPartPostRequestWithData: (NSData *) data params:%@]", [self class], params);
  NSString *boundary = @"----BOUND";  
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: requestPath]];
  [req setHTTPMethod:@"POST"];
  
  //adding the body:
  NSMutableData *postBody = [NSMutableData data];
  [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  //cycle through params
  NSEnumerator *enumerator = [params keyEnumerator];
  id key;
  NSString * postheaders = @"";
  while ((key = [enumerator nextObject])) {
    postheaders = [postheaders stringByAppendingFormat:@"%@=%@&", key, [params valueForKey:key]];

    [postBody appendData:[@"Content-Disposition: form-data; name=\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[key dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[params valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  if (data != nil){
    [postBody appendData:[[NSString stringWithFormat:@"Content-Transfer-Encoding: binary:\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"data\"; filename=\"%@\"\r\n", filename] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[@"Content-Type: data\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:data];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  unsigned char byteBuffer[[postBody length]];
  [postBody getBytes:byteBuffer];
  
  [req setHTTPBody:postBody];
  
  
  // headers
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
  [req setValue:contentType forHTTPHeaderField:@"Content-type"];
  [req setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-length"];
  _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
  if(_connection){
    _receivedData = [[NSMutableData data] retain];
  }else{
    if(_delegate){
      if([_delegate respondsToSelector:@selector(httpConnectionFailed:)] ){
        [_delegate HTTPConnectionFailed:self ];
      }
    }
  }
}

- (void) postRequestWithParams: (NSDictionary *)params{
  orLog(@"[%@ postRequestWithParams: (NSDictionary *)params]", [self class]);
  NSString * post = @"";
  NSString * publicPost = @"";
  NSString *key;
  for (key in params) {
    post = [post stringByAppendingFormat:@"%@=%@&", key, [params valueForKey:key]];
    if([key compare:@"password"] != NSOrderedSame){
      publicPost = [post stringByAppendingFormat:@"%@=%@&", key, [params valueForKey:key]];
    }else{
      publicPost = [post stringByAppendingFormat:@"%@=%@&", key, @"********"];
    }
  }
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString: requestPath]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:postData];
  [request setTimeoutInterval:10];
  _receivedData = [NSMutableData data];
  _connection = [NSURLConnection connectionWithRequest: request delegate:self];
  
  if(_connection){
    orLog(@" ORHTTP: Created connection  = %@", _connection);
    orLog(@" ORHTTP: with post data = %@", post);

   // [_connection start];
    
  }else{
    if(_delegate){
      if([_delegate respondsToSelector:@selector(httpConnectionFailed:)] ){
        [_delegate HTTPConnectionFailed:self ];
      }
    }
  }
}

#pragma mark Connection Delegate Methods

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)resp {
  orLog(@"[%@ connection:%@ didReceiveResponse:%@]", [self class], connection, resp);
  if([resp class]  == [NSHTTPURLResponse class]){
    _response = (NSHTTPURLResponse *)resp;
    [_response retain];
  }
  if(_delegate){
    if([_delegate respondsToSelector: @selector(httpRequest:DidRecieveResponse:)] ) {
      [_delegate httpRequest:self DidRecieveResponse: _response];
    }
  }
}
- (NSURLRequest *)connection:(NSURLConnection *)connection 
             willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
  orLog(@"[%@ connection:%@ willSendRequest:%@]", [self class], connection, request);

  return request;
}
- (void)connection:(NSURLConnection *)connection 
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
  orLog(@"[%@ connection:%@ didReceiveAuthenticationChallenge]", [self class], connection);
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  orLog(@"[%@ connection:%@ didReceiveData:%@]", [self class], connection, data);
  [_receivedData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {  
  orLog(@"[%@ connection:%@ didFailWithError:%@]", [self class], connection, error);
  if (_delegate) {
    if (_delegate && [_delegate respondsToSelector:@selector(httpRequest:connectionDidFailWithResponseCode:)]) {
      [_delegate httpRequest:self DidFailWithError:error];
    }
  }
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
  orLog(@"[%@ connectionDidFinishLoading:%@]", [self class], connection);
  orLog(@"Reply [%@] = %@ ", [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]);
  
  if ([_response statusCode] != 200 && [_response statusCode] != 304 && [_response statusCode] != 400) {
    orLog (@"sending to connectionDidFailWithResponseCode");
    if (_delegate && [_delegate respondsToSelector:@selector(httpRequest:connectionDidFailWithResponseCode:)]) {
      [_delegate httpRequest:self connectionDidFailWithResponseCode: [NSString stringWithFormat:@"%d", [_response statusCode]] ];
    }
  } else {
    if (_delegate){
      orLog (@"sending to connectionDidSucceedWithData or ConnectionDidSucceedWithString");
      if([_delegate respondsToSelector:@selector(httpRequest:connectionDidSucceedWithData:)]) {
        [_delegate httpRequest:self ConnectionDidSucceedWithData: _receivedData ];
      }
      else if([_delegate respondsToSelector:@selector( httpRequest: ConnectionDidSucceedWithString: )]) {
        [_delegate httpRequest:self ConnectionDidSucceedWithString: [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding]]; 
      }
    }
  }
}

- (void) cancel {
  [_connection cancel];
}




@end