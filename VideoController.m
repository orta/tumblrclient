
#import "VideoController.h"
#import <iMediaBrowser/iMBMoviesView.h>
#import <iMediaBrowser/iMediaBrowser.h>


@implementation VideoController

- (void)awakeFromNib {  
  _movieViewActive = false;
  
}



- (void) setSource : (NSString *) path{
  log(@"set source %@", path);
  _filepath = path;
  [videoMovieView setMovie: [QTMovie movieWithFile:path error:nil]];
  [videoMovieView play:self];
}

- (void) setCaption : (NSString *) caption{
  [captionTextField setStringValue:caption];
}



- (void) openCameraConnection {
  
  // Create the capture session
  mCaptureSession = [[QTCaptureSession alloc] init];
  
  BOOL success = NO;
  NSError *error;
  
  QTCaptureDevice *videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
  success = [videoDevice open:&error];
  
  
  // If a video input device can't be found or opened, try to find and open a muxed input device
  
  if (!success) {
    videoDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeMuxed];
    success = [videoDevice open:&error];
    
  }
  
  if (!success) {
    videoDevice = nil;
    // Handle error nsview
    
  }
  
  if (videoDevice) {
    //Add the video device to the session as a device input
    
    mCaptureVideoDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:videoDevice];
    success = [mCaptureSession addInput:mCaptureVideoDeviceInput error:&error];
    if (!success) {
      // Handle error
    }
    
    // If the video device doesn't also supply audio, add an audio device input to the session
    if (![videoDevice hasMediaType:QTMediaTypeSound] && ![videoDevice hasMediaType:QTMediaTypeMuxed]) {
      QTCaptureDevice *audioDevice = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeSound];
      success = [audioDevice open:&error];
      
      if (!success) {
        audioDevice = nil;
        // Handle error
      }
      
      if (audioDevice) {
        mCaptureAudioDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:audioDevice];
        
        success = [mCaptureSession addInput:mCaptureAudioDeviceInput error:&error];
        if (!success) {
          // Handle error
        }
      }
    }
    
    // Create the movie file output and add it to the session
    
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
      // specify the video compression options
      // (note: a list of other valid compression types can be found in the QTCompressionOptions.h interface file)
      if ([mediaType isEqualToString:QTMediaTypeVideo]) {
        // use H.264
        compressionOptions = [QTCompressionOptions compressionOptionsWithIdentifier:@"QTCompressionOptions240SizeH264Video"];
        // specify the audio compression options
      } else if ([mediaType isEqualToString:QTMediaTypeSound]) {
        // use AAC Audio
        compressionOptions = [QTCompressionOptions compressionOptionsWithIdentifier:@"QTCompressionOptionsHighQualityAACAudio"];
      }
      
      // set the compression options for the movie file output
      [mCaptureMovieFileOutput setCompressionOptions:compressionOptions forConnection:connection];
    } 
    
    // Associate the capture view in the UI with the session
    [qtContentView addSubview: videoCaptureView];
    NSRect newBounds = [qtContentView bounds];
    [videoCaptureView setFrame:newBounds];
    [videoCaptureView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
    _isViewing = true;
    [videoCaptureView setCaptureSession:mCaptureSession];
    [mCaptureSession startRunning];

  }
  
}

// Handle window closing notifications for your device input

- (void)windowWillClose:(NSNotification *)notification{
  [self stopCapture];
}

- (void) stopCapture{
  [mCaptureSession stopRunning];
  if ([[mCaptureVideoDeviceInput device] isOpen]){
    [[mCaptureVideoDeviceInput device] close];
  }
  if ([[mCaptureAudioDeviceInput device] isOpen]){
    [[mCaptureAudioDeviceInput device] close];
  }
}


- (IBAction)startRecordingSheet:(id)sender {
  [[NSApplication sharedApplication] beginSheet:sheet modalForWindow: mainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
//  [videoCaptureView retain];
//  [videoRecordingMovieView retain];

  [self openCameraConnection];
}

- (IBAction)cancelRecordingSheet:(id)sender{
  [sheet orderOut:nil];
  [[NSApplication sharedApplication] endSheet:sheet];	
 // [videoCaptureView release];
 // [videoRecordingMovieView release];
  [self stopCapture];
}

- (IBAction)saveAndEndSheet:(id)sender{
  [self cancelRecordingSheet:nil];
  [self setSource: @"/tmp/tumblrmovie.mov"];
}

- (IBAction)toggleRecording:(id)sender {
  

  if(_isViewing == true){
    if(_isRecording == false){
      //started recording
      _isRecording = true;  
      _isViewing = true;
      [mCaptureMovieFileOutput recordToOutputFileURL:[NSURL fileURLWithPath:@"/tmp/tumblrmovie.mov"]];   
      [recordButton setTitle:@"Stop"];
      
    }else{
      //finished recording switch to QTMoviewView
      if([[qtContentView  subviews] count] == 1){
        [videoCaptureView removeFromSuperview];
      }
      [mCaptureSession stopRunning];
      [qtContentView addSubview: videoRecordingMovieView];
      [videoRecordingMovieView setFrame:[qtContentView frame]];
      [videoRecordingMovieView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
      _isViewing = false;
      _isRecording = false;
      [recordButton setTitle:@"Record"];
    }
  }else{

    //Hit Record again
    _isRecording = true;
    _isViewing = true;

    if([[qtContentView  subviews] count] == 1){
      [videoRecordingMovieView removeFromSuperview];
    }   
    [videoCaptureView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
    [qtContentView addSubview: videoCaptureView];
    [mCaptureMovieFileOutput recordToOutputFileURL:[NSURL fileURLWithPath:@"/tmp/tumblrmovie.mov"]];   
    [mCaptureSession startRunning];
    [videoCaptureView setFrame:[qtContentView frame]];
    [recordButton setTitle:@"Stop"];
  }
}


- (void)captureOutput:(QTCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL forConnections:(NSArray *)connections dueToError:(NSError *)error {
   [videoRecordingMovieView setMovie:[QTMovie movieWithURL:outputFileURL error:nil]];
}

- (void) hasBecomeKeyView{
  if(!_movieViewActive){
    videoView = [[iMBMoviesView alloc] initWithFrame:[videoContainerView bounds]];
    [videoContainerView addSubview:(NSView *)videoView];
    [(NSView *)videoView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
    
    [videoView willActivate];
    _movieViewActive = true;
  }
  
  [mainWindow setInitialFirstResponder:captionTextField];
}

- (void) clear{
  [self setCaption:@""];
  [self setSource:@""];
}  

- (void) resignedAsKeyView{

}

- (NSDictionary *)values {
  return [NSDictionary dictionaryWithObjectsAndKeys:
                     _filepath, @"filepath",
[captionTextField stringValue], @"caption",nil];
}


@end
