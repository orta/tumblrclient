//
//  AudioImageView.h
//  Tumblg
//
//  Created by orta on 10/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioController.h"

@interface AudioImageView : NSImageView {
  IBOutlet AudioController *audioController;
}

@end
