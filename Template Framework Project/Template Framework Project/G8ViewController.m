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
@property (weak, nonatomic) IBOutlet UILabel *batterVaule;
- (IBAction)myButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *debugLabel;

@end

@implementation G8ViewController

@synthesize batterPerecent;
@synthesize mylabel;
@synthesize batterVaule;
@synthesize debugLabel;


-(int)getBatteryValue
{
    CGRect tempRect;
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    UIImage *tempImage = nil;
    int batteryUidevices = device.batteryLevel * 100;
    
    if(!inBackgournd)
    {
        tempImage = [self captureScreenWithRect:tempRect];
        //        NSLog(@"screen captured image is: %@",tempImage);
        //    UIImageWriteToSavedPhotosAlbum(tempImage,nil,nil,nil);
        
        //    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        //	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
        [tesseract setImage:tempImage]; //image to check
        [tesseract recognize];
        NSString *batteryValue = [tesseract recognizedText];
        debugLabel.text = batteryValue;
        
        //    [tesseract clear];
        
        int batteryValueInt = [batteryValue intValue];
        mylabel.text = [NSString stringWithFormat:@"%d:%d", batteryUidevices,batteryValueInt];
        if(batteryValueInt > (batteryUidevices - 5) && batteryValueInt < (batteryUidevices  + 5))
        {
            batterVaule.text = batteryValue;
            
            return batteryValueInt;
        }
        else
        {
            NSString *string = [NSString stringWithFormat:@"%d", batteryUidevices];
            batterVaule.text = string;
            return batteryUidevices;
        }
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%d", batteryUidevices];
        batterVaule.text = string;
        return batteryUidevices;
    }
}

- (IBAction)myButton:(id)sender;
{
    NSLog(@"some on press the button");
    CGRect tempRect;
    UIImage *tempImage = [self captureScreenWithRect:tempRect];
    
    UIImageWriteToSavedPhotosAlbum(tempImage,nil,nil,nil);
    
    //    tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    //
    //	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
	[tesseract setImage:tempImage]; //image to check
    NSLog(@"the tesseract is %@",tesseract);
	[tesseract recognize];
	NSString *batteryValue = [tesseract recognizedText];
    //    [tesseract clear];
    batterVaule.text = batteryValue;
	NSLog(@"hello carlos:%@", batteryValue);
    int batteryValueInt = [batteryValue intValue];
    NSLog(@"batteryValueInt:%d", batteryValueInt);
}
//TODO test the battery value when not charge
- (UIImage *)captureScreenWithRect:(CGRect)rect {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    //    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)
    //    {
    //        rect.origin.x = 497;
    //    }
    //    else
    //    {
    //        rect.origin.x = 510;
    //    }
    rect.origin.x = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*3/4;
    rect.origin.y = 0;
    rect.size.width = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*1/4;
    rect.size.height = 2* [[UIApplication sharedApplication] statusBarFrame].size.height;
    //    NSLog(@"x is %f width is %f",rect.origin.x,rect.size.width);
    CGImageRef image = UIGetScreenImage();
    CGImageRef imageRef = CGImageCreateWithImageInRect(image, rect);
    CGImageRelease(image);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}
- (void)timerTicked:(NSTimer*)timer {
    
    int batteryValue = [self getBatteryValue];
    static int oldBatteryValue = 0;
    if(batteryValue != oldBatteryValue)
    {
        NSLog(@"old: %d New :%d Time taken: %f", oldBatteryValue,batteryValue,[[NSDate date] timeIntervalSinceDate:self->timingDate]);
        self->timingDate = [NSDate date];
        oldBatteryValue = batteryValue;
    }
    //    NSLog(@"battery value is: %d\n",batteryValue);
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    
}

- (void) applicationWillResignActive {
    NSLog(@"carlos applicationWillResign");
    inBackgournd = true;
}
- (void) applicationDidBecomeActive {
    NSLog(@"carlos applicationDidBecomeActive");
    inBackgournd = false;
}
/****README****/
/*
 tessdata group is linked into the template project, from the main project.
 TesseractOCR.framework is linked into the template project under the Framework group. It's builded by the main project.
 
 If you are using iOS7 or greater, import libstdc++.6.0.9.dylib (not libstdc++)!!!!!
 
 Follow the readme at https://github.com/gali8/Tesseract-OCR-iOS for first step.
 */

- (void)viewDidLoad
{
    NSLog(@"viewdidload");
    [super viewDidLoad];
    [self createTimer];
    self->timingDate = [NSDate date];
    
	// Do any additional setup after loading the view, typically from a nib.
	
	tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
	//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
	//eng.traineddata is in your "tessdata" folder.
	
	[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
    //	[tesseract setImage:[UIImage imageNamed:@"image_sample.jpg"]]; //image to check
    //	[tesseract recognize];
    //
    //	NSLog(@"hello carlos:%@", [tesseract recognizedText]);
    //	[tesseract clear];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive)
     name:UIApplicationWillResignActiveNotification
     object:NULL];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidBecomeActive)
     name:UIApplicationDidBecomeActiveNotification
     object:NULL];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
