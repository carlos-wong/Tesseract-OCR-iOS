//
//  G8ViewController.m
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import "G8ViewController.h"
#import <TesseractOCR/TesseractOCR.h>
#import <QuartzCore/QuartzCore.h>


@interface G8ViewController ()
- (IBAction)myButton:(id)sender;

@end

@implementation G8ViewController

@synthesize batterPerecent;
@synthesize mylabel;

- (IBAction)myButton:(id)sender;
{
    NSLog(@"some on press the button");
    CGRect tempRect;
    UIImage *tempImage = [self crop:tempRect];
//    CGSize imageSize;
//    imageSize.height = 30;
//    imageSize.width = 90;
//    UIImage *tempImage1 = [self reSizeImage:tempImage toSize:imageSize];
    UIImageWriteToSavedPhotosAlbum(tempImage,nil,nil,nil);

}




- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                           message:@"Unable to save image to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    else
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil];
    [alert show];
}
- (UIImage *)captureScreen
{
    
    // Retrieve the screenshot image
    UIImage *image = [self captureImageOfView:self.view];
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    // Write image to PNG
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    // Let's check to see if files were successfully written...
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);

    return image;
}

/****README****/
/*
 tessdata group is linked into the template project, from the main project.
 TesseractOCR.framework is linked into the template project under the Framework group. It's builded by the main project.
 
 If you are using iOS7 or greater, import libstdc++.6.0.9.dylib (not libstdc++)!!!!!
 
 Follow the readme at https://github.com/gali8/Tesseract-OCR-iOS for first step.
 */
-(UIImage *) captureImageOfView:(UIView *)srcView
{
    UIGraphicsBeginImageContext(srcView.bounds.size);
    [srcView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *anImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return anImage;
}

-(UIImage *) captureRectOfScreen:(CGRect) rect
{
    UIImage *wholeScreen = [self screenshot];
    
    //Add status bar height
    rect.origin.y += UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ? [[UIApplication sharedApplication] statusBarFrame].size.width : [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    //NSLog(@"%@",NSStringFromCGSize([wholeScreen size]));
    
    CGFloat scale = wholeScreen.scale;
    
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    
    UIImage *cropped = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([wholeScreen CGImage], rect) scale:wholeScreen.scale orientation:wholeScreen.imageOrientation];
    
    //NSLog(@"Whole Screen Capt :%@ Scale: %f",NSStringFromCGSize([wholeScreen size]), wholeScreen.scale);
    //NSLog(@"Rect to Crop :%@ Cropped :%@",NSStringFromCGRect(rect), NSStringFromCGSize([cropped size]));
    
    return cropped;
}
-(UIImage *) screenshotold
{
    UIScreen *screen = [UIScreen mainScreen];
    UIView *view = [screen snapshotViewAfterScreenUpdates:YES];
    
    UIGraphicsBeginImageContextWithOptions(screen.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *) reSizeImage:(UIImage *)image toSize:(CGSize)reSize {
    NSLog(@"srcimage is %@",image);
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"reszieimage end");
    return reSizeImage;
}
- (UIImage *)crop:(CGRect)rect {
    rect.origin.x = (2*[[UIApplication sharedApplication] statusBarFrame].size.width)*3/4;
    rect.origin.y = 0;
    rect.size.width = (2*[[UIApplication sharedApplication] statusBarFrame].size.width)*1/4;
    rect.size.height = 2* [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGImageRef imageRef = CGImageCreateWithImageInRect(UIGetScreenImage(), rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}
-(UIImage *) screenshot
{
    
    CGImageRef screen = UIGetScreenImage();
	UIImage* image = [UIImage imageWithCGImage:screen];
    
	CGImageRelease(screen);
    return image;
}
-(UIImage *) screenshotold2
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSLog(@"run screenshot");
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        NSLog(@"window is: %@",window);
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            NSLog(@"draw");
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    NSLog(@"run screenshot end");

    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
	//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
	//eng.traineddata is in your "tessdata" folder.
	
	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
	[tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]]; //image to check
	[tesseract recognize];
	
	NSLog(@"hello carlos:%@", [tesseract recognizedText]);
	[tesseract clear];
//    UIImageWriteToSavedPhotosAlbum([self captureImageOfView:self.view],nil,nil,nil);
//    UIImageWriteToSavedPhotosAlbum([self screenshot],nil,nil,nil);

//    [self captureScreen];
    
//    NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//    NSLog(@"png path is: %@",pngPath);
//    UIImage* image = [UIImage imageNamed:pngPath];
//    batterPerecent.image = image;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
