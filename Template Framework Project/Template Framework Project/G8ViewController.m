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
@property(nonatomic, copy) NSArray *batteryRect;

@end

@implementation G8ViewController

@synthesize batterPerecent;
@synthesize mylabel;
@synthesize batterVaule;
@synthesize debugLabel;
@synthesize batteryRect;

//#define DEBUG_GETBATTERY 1
-(int)getBatteryValue
{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    UIImage *tempImage = nil;
    int batteryUidevices = device.batteryLevel * 100;
    static NSString *oldBatteryValue = nil;
    NSString *batteryValue;
    int batteryVauleInt = 0;
    int readCount = 0;
    Boolean run = true;
    NSString *errorLog = @"";


    if(!inBackgournd)
    {
        do {
            NSValue *val = [batteryRect objectAtIndex:readCount];
            CGRect p = [val CGRectValue];
            tempImage = [self captureScreenWithRect:p];
//            UIImageWriteToSavedPhotosAlbum(tempImage,nil,nil,nil);
            [tesseract setImage:tempImage]; //image to check
            [tesseract recognize];
            batteryValue = [tesseract recognizedText];
#ifdef DEBUG_GETBATTERY
            NSLog(@"batterValue string before trim --%@** is %d",batteryValue,[batteryValue length]);
#endif
            batteryValue = [batteryValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
#ifdef DEBUG_GETBATTERY
            NSLog(@"batteryValue without space is--%@** and batteryValue length is %d readcount is %d",batteryValue,[batteryValue length],readCount);
#endif
            batteryVauleInt = [batteryValue intValue];
#ifdef DEBUG_GETBATTERY
            NSLog(@"batteryVaule int is %d",batteryVauleInt);
#endif
            errorLog = [errorLog stringByAppendingString:[NSString stringWithFormat:@"batteryValue without space is--%@** and batteryValue length is %d readcount is %d\n",batteryValue,[batteryValue length],readCount]];
            switch (readCount) {
                case 0:
                    if((batteryVauleInt >=0 && batteryVauleInt < 10)&&([batteryValue length] == 1))
                        
                        run = false;
                    break;
                case 1:
                    if((batteryVauleInt >=10 && batteryVauleInt <= 99) && ([batteryValue length]== 2))
                        run = false;
                    break;
                case 2:
                    if((batteryVauleInt == 100)&&([batteryValue length] == 3))
                    {
                        run = false;
                    }
                    break;
                default:
                    break;
            }
            if(!run)
                break;
            readCount++;
            if(readCount > 2)
                break;
        } while (run);
        if(readCount > 2)
        {
            //could not get the correct value
            [batterVaule setText:@""];
#ifdef DEBUG_GETBATTERY
            NSLog(@"could not find the value");
#endif
            errorLog = [errorLog stringByAppendingString:[NSString stringWithFormat:@"could not find the value\n"]];
            NSLog(@"%@",errorLog);
            [file writeData:[errorLog dataUsingEncoding:NSUTF8StringEncoding]];
            [file synchronizeFile];
        }
        else{
            ;
#ifdef DEBUG_GETBATTERY
            NSLog(@"find the value is %@",batteryValue);
#endif
        }
        
        if(![batteryValue isEqualToString:oldBatteryValue])
        {
            NSLog(@"\nnew：%@ \nold：%@\n", batteryValue,oldBatteryValue);
            oldBatteryValue = batteryValue;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            //        [formatter setDateFormat:@"yyyy"];
            
            //Optionally for time zone converstions
            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
            [formatter setDateFormat:@"MM/dd/yyyy hh:mma"];
            
            
            NSString *stringFromDate = [formatter stringFromDate:timingDate];
            
            //    [formatter release];
            NSString *content = [NSString stringWithFormat:@"%@ \n%@\n", stringFromDate,oldBatteryValue];
            [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
            [file synchronizeFile];

        }
        debugLabel.text = batteryValue;
        
        
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
    int batteryValue = [self getBatteryValue];
    NSLog(@"batteryValue is %d",batteryValue);
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//TODO test the battery value when not charge
- (UIImage *)captureScreenWithRect:(CGRect)rect {
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    if (device.batteryState == UIDeviceBatteryStateCharging || device.batteryState == UIDeviceBatteryStateFull)
    {
        rect.origin.x -= 16;
    }

//    rect.origin.x = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*2/3;
//    rect.origin.y = 0;
//    rect.origin.x = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*5/9;
//    rect.size.width = (2* [[UIApplication sharedApplication] statusBarFrame].size.width)*4/9;
//    rect.size.height = 2* [[UIApplication sharedApplication] statusBarFrame].size.height;
//    NSLog(@"x is %f width is %f",rect.origin.x,rect.size.width);
    CGImageRef image = UIGetScreenImage();
    CGImageRef imageRef = CGImageCreateWithImageInRect(image, rect);
    CGImageRelease(image);
    
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return result;
}

- (void)timerTicked:(NSTimer*)timer {
    if(inBackgournd)
        return;
    int batteryValue = [self getBatteryValue];
    static int oldBatteryValue = 0;
    if(batteryValue != oldBatteryValue)
    {
        NSLog(@"old: %d New :%d Time taken: %f", oldBatteryValue,batteryValue,[[NSDate date] timeIntervalSinceDate:timingDate]);
        
        NSString *batterVauleChanged = [NSString stringWithFormat:@"old: %d New :%d Time taken: %f", oldBatteryValue,batteryValue,[[NSDate date] timeIntervalSinceDate:timingDate]];
        
        Boolean writeFlie = true;
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
//            NSLog(@"file handler is %@ conten is %@\n",file,content);
        }
        timingDate = [NSDate date];
        oldBatteryValue = batteryValue;
    }
    //    NSLog(@"battery value is: %d\n",batteryValue);
    
}

- (NSTimer*)createTimer {
    
    // create timer on run loop
    return [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    
}

- (void) applicationWillResignActive {
    NSLog(@"carlos applicationWillResign");
    [timer invalidate];
    timer = nil;
    inBackgournd = true;
    
}
- (void) applicationDidBecomeActive {
    NSLog(@"carlos applicationDidBecomeActive");
    if(timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [self createTimer];
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
    chargeImageLength = 16;
    timer = [self createTimer];
    timingDate = [NSDate date];
    
	// Do any additional setup after loading the view, typically from a nib.
	
	tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
	//language are used for recognition. Ex: eng. Tesseract will search for a eng.traineddata file in the dataPath directory.
	//eng.traineddata is in your "tessdata" folder.
	
	[tesseract setVariableValue:@"0123456789%" forKey:@"tessedit_char_whitelist"]; //limit search
//    [tesseract setVariableValue:@"'0'3" forKey:@"language_model_penalty_non_freq_dict_word"]; //limit search
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
    
    batteryRect = [NSArray arrayWithObjects:
                   [NSValue valueWithCGRect:CGRectMake(524, 0, 26, 40)],
                   [NSValue valueWithCGRect:CGRectMake(520, 0, 30, 40)],
                   [NSValue valueWithCGRect:CGRectMake(508, 0, 42, 40)],
                     nil];
    
    [self createFfile];

    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
