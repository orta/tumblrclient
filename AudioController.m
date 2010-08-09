//
//  AudioController.m
//  Tumblor
//
//  Created by orta on 20/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "AudioController.h"
#import "NSImage+QuickLook.h"

@implementation AudioController

- (void) awakeFromNib{
  _recordingFromMic = false;
  [mainWindow setInitialFirstResponder:captionTextField];
}

- (IBAction) toggleMic: (id)sender{
  if(_recordingFromMic){
    [self stopVoiceRecording];
    _recordingFromMic = false;
  }else{
    [self startVoiceRecording];
    _recordingFromMic = true;
  }
}

- (void) startVoiceRecording{
  mCaptureSession = [[QTCaptureSession alloc] init];
  
  BOOL success = NO;
  NSError *error;
  
  QTCaptureDevice *audioDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
  success = [audioDevice open:&error];
  
  if (![audioDevice hasMediaType:QTMediaTypeSound] && ![audioDevice hasMediaType:QTMediaTypeMuxed]) {
    QTCaptureDevice *audioDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeSound];
    success = [audioDevice open:&error];
    
    if (!success) {
      audioDevice = nil;
      return;
      // Handle error
    }
    
    if (audioDevice) {
      mCaptureAudioDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:audioDevice];
      success = [mCaptureSession addInput:mCaptureAudioDeviceInput error:&error];
      if (!success) {
        return;
      }
    }
    mCaptureMovieFileOutput = [[QTCaptureMovieFileOutput alloc] init];
    success = [mCaptureSession addOutput:mCaptureMovieFileOutput error:&error];
    if (!success) {
      // Handle error
    }
    
    [mCaptureMovieFileOutput setDelegate:self];
    
    
    // Set the compression for the audio/video that is recorded to the hard disk.
    
    NSEnumerator *connectionEnumerator = [[mCaptureMovieFileOutput connections] objectEnumerator];
    QTCaptureConnection *connection;
    
    // iterate over each output connection for the capture session and specify the desired compression
    while ((connection = [connectionEnumerator nextObject])) {
      NSString *mediaType = [connection mediaType];
      QTCompressionOptions *compressionOptions = nil;
      if ([mediaType isEqualToString:QTMediaTypeSound]) {
        compressionOptions = [QTCompressionOptions compressionOptionsWithIdentifier:@"QTCompressionOptionsHighQualityAACAudio"];
      }      
      [mCaptureMovieFileOutput setCompressionOptions:compressionOptions forConnection:connection];
    } 
    [mCaptureSession startRunning];
    [mCaptureMovieFileOutput recordToOutputFileURL:[NSURL fileURLWithPath:@"/tmp/tumblraudio.mov"]];
  }
}

- (void) stopVoiceRecording{
  [mCaptureSession stopRunning];
}

- (void)captureOutput:(QTCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL forConnections:(NSArray *)connections dueToError:(NSError *)error {
  [self setSource:@"/tmp/tumblraudio.mov"];
  //TODO : convert to mp3
}


- (void) hasBecomeKeyView{
  if(!_musicViewActive){
    musicView = [[iMBMusicView alloc] initWithFrame:[musicContainerView bounds]];
    [musicContainerView addSubview:(NSView *)musicView];
    [(NSView *)musicView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];

    [musicView willActivate];
    _musicViewActive = true;
  }
}

- (void) setSource : (NSString *) path{
  log(@"audio path = %@", [[NSURL fileURLWithPath: path] absoluteString] );
  QTMovie *movie = [QTMovie movieWithFile:path error:nil];
  [movieView setMovie:movie];
  [albumImageView setImage:[NSImage imageWithPreviewOfFileAtPath:path ofSize:[albumImageView bounds].size asIcon:YES]];
  _filepath = path;
}

- (void) clear{
  [self setCaption:@""];
  [self setSource:@""];
  
}

- (void) setCaption : (NSString *) caption{
  [captionTextField setStringValue:caption];
}


- (void) resignedAsKeyView{
  if ([[mCaptureAudioDeviceInput device] isOpen]){
    [mCaptureSession stopRunning];
    [[mCaptureAudioDeviceInput device] close];
  }
}

- (NSDictionary *)values {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          _filepath, @"filepath",
          [captionTextField stringValue], @"caption",nil];
}
@end
