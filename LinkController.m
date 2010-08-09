//
//  LinkController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "LinkController.h"
#import "NSString_URLEncoding.h"


@implementation LinkController

- (void) awakeFromNib{  
} 

- (void) setLink:(NSString*) link{
  [urlField setStringValue:link];
}

- (void) setTitle:(NSString*) title{
  [urlNameField setStringValue:title];
}

- (void) setDescription:(NSString*) description{
  [urlDescriptionTextField setString:description];
}

- (void) clear{
  [self setLink:@""];
  [self setTitle:@""];
  [self setDescription:@""];
}


- (void) hasBecomeKeyView{  
  [mainWindow setInitialFirstResponder:urlField];
  
}
- (void) resignedAsKeyView{
  
}

- (NSDictionary *)values{
  
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [[urlField stringValue] urlEncodeValue] , @"url",
          [urlNameField stringValue], @"name",
          [urlDescriptionTextField string], @"description",
          nil] ;
}

@end
