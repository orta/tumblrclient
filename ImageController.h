//
//  ImageController.h
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <iMediaBrowser/iMedia.h>
#import <iMediaBrowser/iMBPhotosView.h>



@interface ImageController : NSObject {
  IBOutlet NSView *photosContainerView;
  IBOutlet IKImageView *imageView;
  IBOutlet NSTextField *descriptionTextField;
  NSString * filepath;
  IBOutlet NSWindow * mainWindow;

  
  bool _photosViewActive;
  
@private
  id <iMediaBrowser> photosView;

}

- (void)photoView:(MUPhotoView *)view doubleClickOnPhotoAtIndex:(unsigned)index withFrame:(NSRect)frame;

- (IBAction)browseForFile:(id)sender;
- (IBAction)mediaBroswerForFile:(id)sender;
- (IBAction) pictureTaker:(id)sender;
- (void)pictureTakerDidEnd:(IKPictureTaker *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

- (void) setSource : (NSString *) path;
- (void) setCaption : (NSString *) caption;

- (void) activateMediaView;

- (void) hasBecomeKeyView;
- (void) resignedAsKeyView;

@end
