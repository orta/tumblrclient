//
//  GrowlController.m
//  Tumblg
//
//  Created by orta on 21/09/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GrowlController.h"

@implementation GrowlController 

- (void) awakeFromNib {
  [GrowlApplicationBridge setGrowlDelegate:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDown) name:@"ORNetworkDown" object:nil];

}

- (NSDictionary*) registrationDictionaryForGrowl {
	// For this application, only one notification is registered
	NSArray* allNotifications = [NSArray arrayWithObjects:@"Posted Succesfully", @"Post Failed", @"Network Down", @"Starting Post", nil];
	
	NSDictionary* growlRegistration = [NSDictionary dictionaryWithObjectsAndKeys: 
                                     allNotifications, GROWL_NOTIFICATIONS_DEFAULT,
                                     allNotifications, GROWL_NOTIFICATIONS_ALL, nil];
	
	return growlRegistration;
}

- (NSString *) applicationNameForGrowl {
	return @"Tumblg";
}

- (void) postSuccess{
  [self growlWithTitle:@"Posted Succesfully" description:@"Your post has been posted to your tumblog" name:@"Posted Succesfully"];
}
- (void) postFailed{
  [self growlWithTitle:@"Post Failed" description:@"Your post has not been posted to your tumblog" name:@"Post Failed"];
}
- (void) networkDown{
  [self growlWithTitle:@"Network Down" description:@"Tumblg could not connect to the interwebs" name:@"Network Down"];
}
- (void) startedPosting{
  [self growlWithTitle:@"Starting Post" description:@"Uploading your file to your tumblog" name:@"Starting Post"];
}

- (void) growlWithTitle:(NSString *)title description:(NSString*)description name:(NSString*) name {		
  
	[GrowlApplicationBridge notifyWithTitle:title
                              description:description
                         notificationName:name
                                 iconData:nil
                                 priority:0
                                 isSticky: NO 
                             clickContext: nil];
}



@end
