//
//  BlogController.m
//  Tumblg
//
//  Created by orta on 20/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BlogController.h"
#import "NSImage+QuickLook.h"

@implementation BlogController
@synthesize blogs;

- (void) awakeFromNib{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getXML) name:@"ORUserLoggedIn" object:nil];
}

- (void) getXML{
  blogs = [NSMutableArray array];
  blogTitles = [NSMutableArray array];

  NSString *email = [connectionController email];
  NSString *password =  [connectionController password];
  _HTTPReq  = [[ORHTTPRequest alloc] initWithDelegate:self];
  _HTTPReq.requestPath = @"http://www.tumblr.com/api/write";
  
  NSDictionary * params = [NSDictionary dictionaryWithObjectsAndKeys:@"list-tumblelogs", @"action", email, @"email", password, @"password", nil];
  [_HTTPReq postRequestWithParams:params];
}

- (void) HTTPConnectionFailed: (ORHTTPRequest *) httpReq{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORNetworkDown" object:nil];   
}

- (void) httpRequest:(ORHTTPRequest *) httpReq DidFailWithError: (NSError *) error{
  [self HTTPConnectionFailed:nil];
}

- (void) httpRequest:(ORHTTPRequest *) httpReq connectionDidFailWithResponseCode: (NSString *) code{
  [self HTTPConnectionFailed:nil];
}

- (void) httpRequest:(ORHTTPRequest *) httpReq ConnectionDidSucceedWithString: (NSString *) data{
  [self userLoggedIn];
  NSLog(@"xml = %@", data);
  NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[NSData dataWithBytes: [data cStringUsingEncoding:NSASCIIStringEncoding] 
                                                                         length:[data lengthOfBytesUsingEncoding:NSASCIIStringEncoding]]];
  
  
  // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
  [parser setDelegate:self];
  NSError * error;
  [parser setShouldProcessNamespaces:NO];
  [parser setShouldReportNamespacePrefixes:NO];
  [parser setShouldResolveExternalEntities:NO];
  
  [parser parse];
  
  NSError *parseError = [parser parserError];
  if (parseError && error) {
    error = parseError;
  }
  [self setCurrentBlogIndex:_currentBlogIndex];
  [parser release];  
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
  if (qName) {
    elementName = qName;
  }
  if( [elementName compare:@"tumblelog"] == NSOrderedSame  ){
    //  as long as something exists
    [blogs insertObject:attributeDict atIndex: [blogs count]];
    [blogTitles addObject:[attributeDict valueForKey:@"title"]];
  }
  if([attributeDict valueForKey:@"is-primary"] != nil){
    if([[attributeDict valueForKey:@"is-primary"]  compare:@"yes"] == NSOrderedSame){
      [self setCurrentBlogIndex:[blogs indexOfObject:attributeDict]];
    }
  }
}

- (void) userLoggedIn{
  if (_hasLoggedIn) return;
  //kill the login button
  [toolbar removeItemAtIndex:0];
  [toolbar insertItemWithItemIdentifier: [profilePictureItem itemIdentifier] atIndex:0];
  [toolbar insertItemWithItemIdentifier: [blogSwitcherButtonItem itemIdentifier] atIndex:1];
  _hasLoggedIn = true;

}

- (void) setCurrentBlogIndex: (int) index{
  _currentBlogIndex = index;
  NSDictionary * currentBlog = [blogs objectAtIndex:index];
  if([currentBlog valueForKey:@"avatar-url"] != nil){
    [NSThread detachNewThreadSelector:@selector(loadImageFromURL) toTarget:self withObject:nil];
  }
}

- (void) loadImageFromURL{
  NSDictionary * currentBlog = [blogs objectAtIndex:_currentBlogIndex];
  NSURL * address = [NSURL URLWithString:[currentBlog valueForKey:@"avatar-url"]];
  NSData * data = [NSData dataWithContentsOfURL: address ];
  [data writeToFile:@"/tmp/tumblrprofilepic.png" atomically:YES];
  NSImage * profilePic = [NSImage imageWithPreviewOfFileAtPath:@"/tmp/tumblrprofilepic.png" ofSize:NSMakeSize(32, 32) asIcon:NO];
  [profilePictureView setImage:profilePic];
  
}

- (IBAction) selectedIndexChanged:(id) sender{
  [self setCurrentBlogIndex: [sender indexOfSelectedItem]];
  [blogSwitcherButton selectItemAtIndex: [sender indexOfSelectedItem]];
} 

- (NSString *) currentBlogURL{
  return [[blogs objectAtIndex:_currentBlogIndex] valueForKey:@"url"];
}

- (int) currentBlogIndex{
  return _currentBlogIndex;
}

- (NSString *) group{
  NSDictionary * currentBlog = [blogs objectAtIndex:_currentBlogIndex];
  if([currentBlog valueForKey:@"is-primary"] != nil){
    return @"";
  }
  if([currentBlog valueForKey:@"private-id"] != nil){
    return[currentBlog valueForKey:@"private-id"];
  }
  return [currentBlog valueForKey:@"url"];
}

- (NSArray *) blogTitles{
  return blogTitles;
}

- (IBAction)openCurrentBlog:(id)sender{
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[self currentBlogURL]]];
}


@end
