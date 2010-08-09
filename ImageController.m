//
//  ImageController.m
//  Tumblor
//
//  Created by orta on 19/07/2008.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "ImageController.h"

@implementation ImageController

- (void) hasBecomeKeyView{
  if(!_photosViewActive){    
    photosView = [[iMBPhotosView alloc] initWithFrame:[photosContainerView bounds]];
    [photosContainerView addSubview:(NSView *)photosView];
    [(NSView *)photosView setAutoresizingMask:(NSViewHeightSizable|NSViewWidthSizable)];
    [NSThread detachNewThreadSelector:@selector(activateMediaView) toTarget:self withObject:nil];
  }  
  
  [mainWindow setInitialFirstResponder:descriptionTextField];
}

- (void)photoView:(MUPhotoView *)view doubleClickOnPhotoAtIndex:(unsigned)index withFrame:(NSRect)frame{
  

}

- (void) activateMediaView{
  
  [photosView willActivate];    
  _photosViewActive = true;  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"ORAniMediaViewActivated" object:nil];   
}

- (void) resignedAsKeyView{
  
}

- (IBAction)browseForFile:(id)sender{
  log(@"%s Hi", _cmd);
}

-(IBAction) pictureTaker:(id)sender{
  IKPictureTaker * pic = [IKPictureTaker pictureTaker];
  [pic setMirroring:true];
  [pic setTitle:@"Tumblg Cam-shot"];
  NSImage * image;
  //TODO : Set Max Size
  if(filepath){
     image = [[NSImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath: filepath]];
  }else{
    image = [NSImage imageNamed:@"photoplaceholder"];
  }
  [pic setInputImage:image];
  
  [pic beginPictureTakerWithDelegate:self didEndSelector:@selector(pictureTakerDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)pictureTakerDidEnd:(IKPictureTaker *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
  if(returnCode == NSOKButton){
    // IKImageView doesn't have an accept NSImage, so we write out a png and then load that in
    IKPictureTaker * pic = [IKPictureTaker pictureTaker];
    NSImage * image = [pic outputImage]; 
    NSBitmapImageRep	*bitmapRep =  [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    NSData * pngData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    NSString *fullPath = [@"/tmp" stringByAppendingPathComponent:@"newpic.png"];    
    [pngData writeToFile:fullPath atomically:YES];
    [self setSource:fullPath];
  }
}

- (void) setSource : (NSString *) path{
  NSString * type =  [[path componentsSeparatedByString:@"."] lastObject];
  if( [type compare:@"pdf"] == NSOrderedSame){
    log(@"path = %@", [NSURL fileURLWithPath: path]);
    NSImage * image = [[NSImage alloc] initWithContentsOfURL:[NSURL fileURLWithPath: path]];
    NSBitmapImageRep	*bitmapRep =  [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
    NSData * pngData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    NSString *fullPath = [@"/tmp" stringByAppendingPathComponent:@"pdfpic.png"];    
    [pngData writeToFile:fullPath atomically:YES];
    path = fullPath;
  }
  filepath = path;
  [imageView setImageWithURL:[NSURL fileURLWithPath:path]];
}

- (void) setCaption : (NSString *) caption{
  [descriptionTextField setStringValue:caption];
}


- (void) clear{
  [self setCaption: @""];
}  

- (IBAction)mediaBroswerForFile:(id)sender{
	[[iMediaBrowser sharedBrowserWithDelegate:self] showWindow:self];
}

- (BOOL)iMediaBrowser:(iMediaBrowser *)browser willLoadBrowser:(NSString *)browserClassname{ 
	return YES;
}

- (NSDictionary *) values{
  
  return [NSDictionary dictionaryWithObjectsAndKeys:
           filepath, @"filepath",
          [descriptionTextField stringValue], @"caption",
          nil];
}

@end
