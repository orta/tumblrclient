//
//  VideoQTMovieView.h
//  Tumblg
//
//  Created by orta on 13/08/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VideoController.h"

@interface VideoQTMovieView : QTMovieView {
  IBOutlet VideoController *videoController;

}

@end
