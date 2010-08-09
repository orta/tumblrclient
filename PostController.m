//
//  PostController.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PostController.h"
#import "ORHTTPWrapper.h"



@implementation PostController


-(IBAction) post:(id) sender{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"ORDoingNetworkStuffYah" object:self];
  
  switch ([tumblrController currentViewIndex]) {
    case 0:
    case 2:
    case 3:
    case 4:
      [self postWithType:@"text"];
      break;
    case 1:
    case 5:
    case 6:
      [self postWithType:@"file"];

      break;
    default:
      log(@"***should not get here");
      break;
  }  
}

-(void) postWithType: (NSString *) postType {
  NSString* username = [connectionController email];
  NSString* password = [connectionController password];
  
  id <ViewController> currentViewController = [tumblrController currentViewController];

  log(@"controller = %@", [currentViewController class]);
  
  NSArray* postTypes = [NSArray arrayWithObjects: @"regular", @"photo", @"quote", @"link", @"conversation", @"audio", @"video" , nil]; 
  NSString* type = [postTypes objectAtIndex:[tumblrController currentViewIndex]];
  
  NSString* generator = @"Tumblg";
  
  NSString* private = @"0";
  if([privatePostButton state] == 1) private = @"1";
  
  NSString* tagsAsCSV = [[tagTokenView stringValue] urlEncodeValue];
  NSString* group = [blogController group];
  NSLog(@"GROUP = %@", group);
    
  NSMutableDictionary * postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                               username, @"email",
                               password, @"password",
                               type, @"type",
                               generator, @"generator",
                               private, @"private",
                               group, @"group",
                               tagsAsCSV, @"tags", nil];
  log(@"%@ - params from CVC", [currentViewController values]);
  [postParams addEntriesFromDictionary: [currentViewController values] ];
  [growlController startedPosting];
  _HTTPReq = [[ORHTTPRequest alloc] initWithDelegate:self];
  _HTTPReq.requestPath = @"http://www.tumblr.com/api/write";

  if([postType compare:@"text"] == NSOrderedSame ){
    [_HTTPReq postRequestWithParams:postParams];
  }
  
  if([postType compare:@"file"] == NSOrderedSame ){
    [_HTTPReq multiPartPostRequestWithPath: [postParams objectForKey:@"filepath"] params:postParams];
  }
}
//
//-(void) _silentPostWithType: (NSString *) type email: (NSString *)email password:(NSString *)password{
//  NSString* username = [connectionController email];
//  NSString* password = [connectionController password];
//  
//  id <ViewController> currentViewController = [tumblrController currentViewController];
//  
//  log(@"controller = %@", [currentViewController class]);
//    
//  NSString* generator = @"Tumblg";
//  
//  NSString* private = @"0";
//  if([privatePostButton state] == 1) private = @"1";
//  
//  NSString* tagsAsCSV = [[tagTokenView stringValue] urlEncodeValue];
//  NSString* group = [[groupTextField stringValue] urlEncodeValue];
//  
//  NSMutableDictionary * postParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                      username, @"email",
//                                      password, @"password",
//                                      type, @"type",
//                                      generator, @"generator",
//                                      private, @"private",
//                                      group, @"group",
//                                      tagsAsCSV, @"tags", nil];
//  log(@"%@ - params from CVC", [currentViewController values]);
//  [postParams addEntriesFromDictionary: [currentViewController values] ];
//  
//  ORHTTPRequest * httpReq = [[ORHTTPRequest alloc] initWithDelegate:self];
//  httpReq.requestPath = @"http://www.tumblr.com/api/write";
//  
//  if([postType compare:@"text"] == NSOrderedSame ){
//    [httpReq postRequestWithParams:postParams];
//  }
//  
//  if([postType compare:@"file"] == NSOrderedSame ){
//    [httpReq multiPartPostRequestWithPath: [postParams objectForKey:@"filepath"] params:postParams];
//  }
//}


- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data{
  log(@"httpReq succeded with string = %@", data);  
}

- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code{
  log(@"httpRequest connectionDidFailWithResponseCode: %@", code);
  if([code compare:@"201"] == NSOrderedSame){
    log(@"cool success");  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ORPostedSuccessfully" object:code];   
    [growlController postSuccess];
    id <ViewController> currentViewController = [tumblrController currentViewController];
    [currentViewController clear];
  }
}   

- (void) HTTPConnectionFailed: (ORHTTPRequest *) httpReq{
  log(@"failed!");
    [growlController postFailed];

}

- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error{
  log(@"request failed!");
   [growlController networkDown];

}

@end
