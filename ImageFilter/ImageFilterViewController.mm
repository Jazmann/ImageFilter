//
//  ImageFilterViewController.m
//  ImageFilter
//
//  Created by CHARU HANS on 7/17/12.
//  Copyright (c) 2012 University of Houston - Main Campus. All rights reserved.
//

#import "ImageFilterViewController.h"
#include "UIImageCVMatConverter.h"
#include "ImageFilter.h"
#import "UIImage+Resize.h"
#import "DetailViewContoller.h"
#import <Twitter/Twitter.h>


@interface ImageFilterViewController ()
@property (nonatomic, strong) UIImagePickerController * photoFromLibraryPicker;
@property (nonatomic,strong) UIImagePickerController * photoFromCameraPicker;
-(int)pixelSizeFromFloatValue:(float)theValue;
@property(nonatomic, strong) UIImage *loadImage;
@property (assign, nonatomic)  int random;
@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) BOOL activeMotion;

@end

@implementation ImageFilterViewController
@synthesize imageView;
@synthesize myToolbar;
@synthesize label;
@synthesize alphaLabel;
@synthesize filter;
@synthesize alphaSlider;
@synthesize thresholdSlider;
@synthesize doneButton;
@synthesize saveButton;
@synthesize activityIndicator;


#pragma mark - 
#pragma mark Private Propertie
@synthesize photoFromLibraryPicker;
@synthesize loadImage;
@synthesize photoFromCameraPicker;
@synthesize startPoint;
@synthesize activeMotion;
@synthesize random;



#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    filter = [[imageFilter alloc]init];
    saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProcessingResult:)];
    
    doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonAction:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    self.navigationItem.title = @"Image Effects";
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"fruits" ofType:@"jpg"];
    imageView.image = [UIImage imageWithContentsOfFile:fileName];
    CGSize desiredSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    imageView.image = [imageView.image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:desiredSize];
    loadImage = imageView.image;
    random = 14;
   // random = -1;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];;
	activityIndicator.center = CGPointMake(160, 240);
	activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    //Add buttons
    UIBarButtonItem *systemItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(showPhotoLibrary:)];
    
    UIBarButtonItem *systemItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                                 target:self
                                                                                 action:@selector(showCameraImage:)];
 
    UIBarButtonItem *systemItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                 target:self
                                                                                 action:@selector(tweetImage)];
    
    UIImage *diceImage = [UIImage imageNamed:@"dice.png"];
    UIButton *dice = [UIButton buttonWithType:UIButtonTypeCustom];
    dice.bounds = CGRectMake( 0, 0, diceImage.size.width, diceImage.size.height);
    [dice addTarget:self action:@selector(feelingLucky:) forControlEvents:UIControlEventTouchDown];
    [dice setImage:diceImage forState:UIControlStateNormal];
    [dice setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *systemItem4 = [[UIBarButtonItem alloc] initWithCustomView:dice];
    

    
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    //Add buttons to the array
    NSArray *items = [NSArray arrayWithObjects: systemItem1, flexItem, systemItem2, flexItem, systemItem3,flexItem, systemItem4, nil];
    
    //add array of buttons to toolbar
    [myToolbar setItems:items animated:NO];
    [self.view addSubview:myToolbar];
    
}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setMyToolbar:nil];
    [self setThresholdSlider:nil];
    [self setLabel:nil];
    [self setAlphaSlider:nil];
    [self setAlphaLabel:nil];
    [super viewDidUnload];
}


#pragma mark - 
#pragma mark Button Action

// http://mobiledevelopertips.com/core-services/ios-5-twitter-framework-part-1.html
-(void)tweetImage
{
// Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

// Optional: set an image, url and initial text
[twitter addImage:imageView.image];
[twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://opencv.org/"]]];

NSString *tweetMessage = [self.navigationItem.title stringByAppendingString:@" using OpenCV and iOS"];
[twitter setInitialText:tweetMessage];

// Show the controller
[self presentModalViewController:twitter animated:YES];

// Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Tweet Status";
        NSString *msg; 
    
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"Tweet was canceled.";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Tweet completed.";
    
        // Show alert to see how things went...
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
    
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
    };
}
    
    
- (IBAction)showCameraImage:(id)sender
{
    if(!photoFromCameraPicker)
        photoFromCameraPicker = [[UIImagePickerController alloc] init];
    
	photoFromCameraPicker.delegate = (id)self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    photoFromCameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentModalViewController:photoFromCameraPicker animated:YES];  
}

- (IBAction)showPhotoLibrary:(id)sender
{
	if(!photoFromLibraryPicker)
        photoFromLibraryPicker = [[UIImagePickerController alloc] init];
    photoFromLibraryPicker.delegate = (id)self;
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    photoFromLibraryPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:photoFromLibraryPicker animated:YES]; 
}

-(IBAction)feelingLucky:(id)sender
{
   
    random = arc4random()%14;
  // random = 1;
  //  random = random+1;
    alphaLabel.text = [NSString stringWithFormat:@""];
    label.text = label.text = [NSString stringWithFormat:@""];
    self.navigationItem.rightBarButtonItem = saveButton;
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    if(random == 5)
    {  
        thresholdSlider.hidden = NO;
        label.hidden = NO;
        alphaSlider.hidden = YES;
        alphaLabel.hidden = YES;
        [thresholdSlider  addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:thresholdSlider.value sliderValueTwo:0];
        self.navigationItem.title = @"BINARY";
    }
    else if(random == 0)
    {
        thresholdSlider.hidden = NO;
        label.hidden = NO;
        alphaSlider.hidden = YES;
        alphaLabel.hidden = YES;
        [thresholdSlider  addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];

        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:[self pixelSizeFromFloatValue :thresholdSlider.value] sliderValueTwo:0];

        self.navigationItem.title = @"Pixalate";
    }
    else if(random == 10)
    {
        thresholdSlider.hidden = NO;
        alphaSlider.hidden = NO;
        label.hidden = NO;
        alphaLabel.hidden = NO;
        [thresholdSlider  addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
        [alphaSlider  addTarget:self action:@selector(betaSliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];

        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:[ self betaFromFloatValue :thresholdSlider.value] sliderValueTwo:alphaSlider.value];
        
        self.navigationItem.title = @"Brightness Contrast";
    }
    else if(random == 13)
    {
        self.navigationItem.rightBarButtonItem = doneButton;
        thresholdSlider.hidden = YES;
        alphaSlider.hidden = YES;
        label.hidden = YES;
        alphaLabel.hidden = YES;
      // imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:thresholdSlider.value sliderValueTwo:alphaSlider.value];
        imageView.image = loadImage;
        self.navigationItem.title = @"Inpaint";
    }
    else
    {
        if(random == 1)
        {
            self.navigationItem.title = @"Cartoon";
        }
        else if(random == 2)
        {
            self.navigationItem.title = @"Gray Shades";
        }
        else if(random == 3)
        {
            self.navigationItem.title = @"Soft Focus";
        }
        else if(random == 4)
        {
            self.navigationItem.title = @"Inverse";
        }
        else if(random == 6)
        {
            self.navigationItem.title = @"Sepia";
        }
        else if(random == 7)
        {
            self.navigationItem.title = @"Pencil Sketch";
        }
        else if(random == 8)
        {
            self.navigationItem.title = @"Retro";
        }
        else if(random == 9)
        {
            self.navigationItem.title = @"Film Grain";
        }
        else if(random == 11)
        {
            self.navigationItem.title = @"Color Sketch";
        }
        else if(random == 12)
        {
            
            self.navigationItem.title = @"Pinhole Effect";
        }
        thresholdSlider.hidden = YES;
        label.hidden = YES;
        alphaSlider.hidden = YES;
        alphaLabel.hidden = YES;
        imageView.image = [filter processImage:loadImage  oldImage:imageView.image number:random sliderValueOne:thresholdSlider.value sliderValueTwo:alphaSlider.value];
    }
      [activityIndicator stopAnimating];
}


-(IBAction)sliderValueChangedAction:(UISlider *)sender
{
    
    if(random == 5)
    {
       
        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:thresholdSlider.value sliderValueTwo:0];
        label.text = [NSString stringWithFormat:@"%.2f", [(UISlider *)sender value]];
    }
    if(random == 0)
    {
       
        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:[self pixelSizeFromFloatValue :thresholdSlider.value] sliderValueTwo:0];
        label.text = [NSString stringWithFormat:@"%d", [ self pixelSizeFromFloatValue :[(UISlider *)sender value]]];
    }
    if(random == 10)
    {
       
        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:[ self betaFromFloatValue :thresholdSlider.value] sliderValueTwo:alphaSlider.value];
        label.text = [NSString stringWithFormat:@"%.2f", [ self betaFromFloatValue :[(UISlider *)sender value]]];
    }
}

-(IBAction)betaSliderValueChangedAction:(UISlider *)sender
{
    if(random == 10)
    {
        imageView.image = [filter processImage:loadImage oldImage:NULL number:random sliderValueOne:[ self betaFromFloatValue :thresholdSlider.value] sliderValueTwo:alphaSlider.value];
        alphaLabel.text = [NSString stringWithFormat:@"%.2f", [(UISlider *)sender value]];
    }
    
}

- (IBAction)doneButtonAction:(id)sender 
{
    if(random == 13)
    {
        imageView.image = [filter processImage:loadImage oldImage:imageView.image number:random sliderValueOne:thresholdSlider.value sliderValueTwo:alphaSlider.value];
        //imageView.image = loadImage;
        
    }
    self.navigationItem.rightBarButtonItem = saveButton;
}
- (void) saveProcessingResult:(id) sender
{
    if(imageView.image) 
    {
		UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(finishUIImageWriteToSavedPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
	}
    
    
}
- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
}

#pragma mark - 
#pragma mark Slider Value
-(int)pixelSizeFromFloatValue:(float)theValue {
    
    int pixelSize;
    pixelSize = floor(theValue*15/255) + 1;
    return pixelSize;
}
-(float)alphaFromFloatValue:(float)theValue {
    
    float alpha;
    alpha = theValue*3/255;
    return alpha;
}
-(float)betaFromFloatValue:(float)theValue {
    
    float beta; 
    beta = theValue*100/255;
    return beta;
}
#pragma mark - 
#pragma mark Touch Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // backup first touch point in  image view
    startPoint = [[touches anyObject] locationInView:imageView];
    
    // set or reset motion boolean to no
    activeMotion = NO;   
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // get new touch point in our image view
    CGPoint newPoint = [[touches anyObject] locationInView:imageView];
    
    // set motion boolean to yes
    activeMotion = YES;
    
    // draw line from last start point to new point
    if(random == 13 && [self.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"])
        [self drawLineFrom:startPoint To:newPoint];
    
    // overwrite last start point with new point
    startPoint = newPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // get new touch point in our image view
    CGPoint newPoint = [[touches anyObject] locationInView:imageView];
    
    // draw line from last start point to new point if no motion has taken place - results in a point
    if(!activeMotion && random == 13&& [self.navigationItem.rightBarButtonItem.title isEqualToString:@"Done"]) 
        [self drawLineFrom:startPoint To:newPoint];
}
#pragma mark - 
#pragma mark Draw Inpaint
- (void)drawLineFrom:(CGPoint)start To:(CGPoint)end {
    // begin image context
    UIGraphicsBeginImageContext(imageView.frame.size);
    
    // define image rect for drawing
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    
    // set line properties
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0f);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0f, 1.0f, 1.0f, 1.0);
    
    // move context to start point
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), start.x, start.y);
    
    // define path to end point
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), end.x, end.y);
    
    // stroke path
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    
    // flush context to be sure all drawing operations were processed
    CGContextFlush(UIGraphicsGetCurrentContext());
    
    // get UIImage from context and pass it to our image view 
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // end image context
    UIGraphicsEndImageContext();
}



#pragma mark - 
#pragma mark Picker View
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
    picker = nil;
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"]; 
	CGSize desiredSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	
	image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:desiredSize];
	
    imageView.image = image;
    loadImage = image;
    thresholdSlider.hidden = YES;
    label.hidden = YES;
    alphaSlider.hidden = YES;
    alphaLabel.hidden = YES;
    self.navigationItem.title = @"Image Effects";
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)finishUIImageWriteToSavedPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 
#pragma mark Switching Views
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) 
    {
        DetailViewContoller *dvc = (DetailViewContoller *) segue.destinationViewController;
        dvc.valueToRetrive = random;
        dvc.name = self.navigationItem.title;
    }
}

@end
