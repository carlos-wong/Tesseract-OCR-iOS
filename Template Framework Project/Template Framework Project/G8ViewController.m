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
    static NSString *oldBatteryValue = nil;
    if(!inBackgournd)
    {
        tempImage = [self captureScreenWithRect:tempRect];
        //NSLog(@"screen captured image is: %@",tempImage);
        //UIImageWriteToSavedPhotosAlbum(tempImage,nil,nil,nil);
        
        //tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
        //[tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
        [tesseract setImage:tempImage]; //image to check
        [tesseract recognize];
        NSString *batteryValue = [tesseract recognizedText];
        
        if(![batteryValue isEqualToString:oldBatteryValue])
        {
            NSLog(@"%@ \n%@\n", batteryValue,oldBatteryValue);
            oldBatteryValue = batteryValue;
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//            //        [formatter setDateFormat:@"yyyy"];
//            
//            //Optionally for time zone converstions
//            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
//            [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
//            
//            
//            NSString *stringFromDate = [formatter stringFromDate:timingDate];
//            
//            //    [formatter release];
//            NSString *content = [NSString stringWithFormat:@"%@ \n%@\n", stringFromDate,oldBatteryValue];
//            [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
//            [file synchronizeFile];

        }
//        NSLog(@"batteryValue is %@ ",batteryValue);
        debugLabel.text = batteryValue;

        
        //[tesseract clear];
        
        int batteryValueInt = [batteryValue intValue];
        mylabel.text = [NSString stringWithFormat:@"%d:%d", batteryUidevices,batteryValueInt];
        if(batteryValueInt > (batteryUidevices - 10) && batteryValueInt < (batteryUidevices  + 10))
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
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
//    rect.origin.x = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*2/3;
    rect.origin.y = 0;
    rect.origin.x = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*5/9;
    rect.size.width = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*4/9;
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
        NSLog(@"old: %d New :%d Time taken: %f", oldBatteryValue,batteryValue,[[NSDate date] timeIntervalSinceDate:timingDate]);
        
        NSString *batterVauleChanged = [NSString stringWithFormat:@"old: %d New :%d Time taken: %f", oldBatteryValue,batteryValue,[[NSDate date] timeIntervalSinceDate:timingDate]];
        
        Boolean writeFlie = false;
        if(writeFlie)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //        [formatter setDateFormat:@"yyyy"];
            
            //Optionally for time zone converstions
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
            [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
            
            
            NSString *stringFromDate = [formatter stringFromDate:timingDate];
            
            //    [formatter release];
            NSString *content = [NSString stringWithFormat:@"%@ \n%@\n", stringFromDate,batterVauleChanged];
            [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
            [file synchronizeFile];
            NSLog(@"file handler is %@ conten is %@\n",file,content);
        }
        timingDate = [NSDate date];
        oldBatteryValue = batteryValue;
    }
    //    NSLog(@"battery value is: %d\n",batteryValue);
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    
}

- (void) applicationWillResignActive {
    NSLog(@"carlos applicationWillResign");
    inBackgournd = true;
}
- (void) applicationDidBecomeActive {
    NSLog(@"carlos applicationDidBecomeActive");
    inBackgournd = false;
}
-(void)createFfile{
    //Get the file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"myFileName.txt"];
    
    //TODO remove the old log
    //    NSError *error;
    //    [[NSFileManager defaultManager] removeItemAtPath:fileName error:&error];
    //    NSLog(@"remove item error:%@", error);
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //append text to file (you'll probably want to add a newline every write)
    file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy"];
    
    //Optionally for time zone converstions
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    //    [formatter setDateStyle:kCFDateFormatterFullStyle];
    [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
    
    NSString *stringFromDate = [formatter stringFromDate:timingDate];
    
    //    [formatter release];
    NSString *content = [NSString stringWithFormat:@"\n\nhello carlos %@\n\n\n", stringFromDate];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file synchronizeFile];
    
    NSLog(@"file handler is %@ conten is %@\n",file,content);
    
    //        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //        NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"myFileName.txt"];
    
    //read the whole file as a single string
    NSString *readOutput = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"read file start:");
    NSLog(@"%@",readOutput);
    NSLog(@"read file end");
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
    timingDate = [NSDate date];
    
	// Do any additional setup after loading the view, typically from a nib.
	
	tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"ita"];
	//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
	//eng.traineddata is in your "tessdata" folder.
	
	[tesseract setVariableValue:@"0123456789%" forKey:@"tessedit_char_whitelist"]; //limit search
//    [tesseract setVariableValue:@"0" forKey:@"language_model_penalty_non_freq_dict_word"]; //limit search
//    [tesseract setVariableValue:@"0" forKey:@"language_model_penalty_non_dict_word"]; //limit search

    
    
//	[tesseract setVariableValue:@"'` " forKey:@"tessedit_char_blacklist"];

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
    
//    [self createFfile];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
