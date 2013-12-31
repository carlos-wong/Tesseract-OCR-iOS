//
//  G8ViewController.h
//  Template Framework Project
//
//  Created by Daniele on 14/10/13.
//  Copyright (c) 2013 Daniele Galiotto - www.g8production.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TesseractOCR/TesseractOCR.h>


@interface G8ViewController : UIViewController
{
    IBOutlet UIImageView *batterPerecent;
    IBOutlet UILabel *mylabel;
    Boolean inBackgournd;
    Tesseract* tesseract;
    NSDate *timingDate;

}
- (UIImage *)captureScreenWithRect:(CGRect)rect;
@property(nonatomic,retain)IBOutlet UIImageView *batterPerecent;
@property(nonatomic,retain)IBOutlet UILabel *mylabel;



@end
