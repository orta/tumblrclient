//
//  VideoController.h
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <iMediaBrowser/iMediaBrowser.h>
@interface VideoController : NSObject {
  
  IBOutlet QTCaptureView * videoCaptureView;
  IBOutlet QTMovieView * videoRecordingMovieView;
  IBOutlet NSView * qtContentView;
  
  IBOutlet NSView * videoContainerView;
  
  IBOutlet NSWindow * sheet;
  IBOutlet NSButton * recordButton;
  
  IBOutlet QTMovieView * videoMovieView;
  IBOutlet NSTextField * captionTextField;
  IBOutlet NSWindow * mainWindow;

  
  QTCaptureSession            *mCaptureSession;
  QTCaptureMovieFileOutput    *mCaptureMovieFileOutput;
  QTCaptureDeviceInput        *mCaptureVideoDeviceInput;
  QTCaptureDeviceInput        *mCaptureAudioDeviceInput;
  NSString * _filepath;
  bool _isRecording;
  bool _isViewing;
  bool _firstRecorderLoad;
  bool _movieViewActive;
  
@private
  id <iMediaBrowser> videoView;

}

- (void) setSource : (NSString *) path;
- (void) setCaption : (NSString *) caption;

- (IBAction)toggleRecording:(id)sender;
- (IBAction)startRecordingSheet:(id)sender;
- (IBAction)saveAndEndSheet:(id)sender;
- (IBAction)cancelRecordingSheet:(id)sender;

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;
- (void) stopCapture;

@end