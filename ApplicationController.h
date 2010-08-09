//
//  ApplicationController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TumblrController.h"
#import "TumblrQSHandler.h"
#import "PostController.h"

@interface ApplicationController : NSObject {
  // I'm for OS features rather than app
  // e.g. Dock stuff
  
  IBOutlet TumblrController *tumblrController;
  IBOutlet PostController *postController;
}

const AEKeyword EditDataItemAppleEventClass = 'EBlg';
const AEKeyword EditDataItemAppleEventID = 'oitm';
const AEKeyword DataItemTitle = 'titl';
const AEKeyword DataItemDescription = 'desc';
const AEKeyword DataItemSummary = 'summ';
const AEKeyword DataItemLink = 'link';
const AEKeyword DataItemPermalink = 'plnk';
const AEKeyword DataItemSubject = 'subj';
const AEKeyword DataItemCreator = 'crtr';
const AEKeyword DataItemCommentsURL = 'curl';
const AEKeyword DataItemGUID = 'guid';
const AEKeyword DataItemSourceName = 'snam';
const AEKeyword DataItemSourceHomeURL = 'hurl';
const AEKeyword DataItemSourceFeedURL = 'furl';

const AEKeyword TumblrPostClass = 'tumb';
const AEKeyword TumblrPostSendID = 'send';
const AEKeyword TumblrPostEventID = 'post';
const AEKeyword TumblrPostFileEventID = 'posi';

const AEKeyword PostText = '----';
const AEKeyword PostType = 'ptyp';
const AEKeyword PostImageDescription = 'pidc';

- (void) registerDefaults;
- (IBAction) aboutApp:(id)sender;
- (IBAction)bugReport:(id)sender;
@end
