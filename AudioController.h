//
//  AudioController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <iMediaBrowser/iMedia.h>
#import <iMediaBrowser/iMBMusicView.h>
#import <QTKit/QTKit.h>


@interface AudioController : NSObject {
  IBOutlet NSView *musicContainerView;
  IBOutlet QTMovieView *movieView;
  IBOutlet NSTextField *captionTextField;
  IBOutlet NSImageView *albumImageView;
  IBOutlet NSWindow * mainWindow;

  
  QTCaptureSession            *mCaptureSession;
  QTCaptureMovieFileOutput    *mCaptureMovieFileOutput;
  QTCaptureDeviceInput        *mCaptureAudioDeviceInput;
  
  NSString * _filepath;
  Boolean _musicViewActive;
  Boolean _recordingFromMic;
  
@private
  id <iMediaBrowser> musicView;
}

- (IBAction) toggleMic: (id)sender;

- (void) startVoiceRecording;
- (void) stopVoiceRecording;

- (void) setSource: (NSString *) path;
- (void) setCaption: (NSString *) caption;
- (void) clear;
- (NSDictionary *)values;

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

@end
  