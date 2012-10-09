//
//  ImageFilterViewController.h
//  ImageFilter
//
//  Created by CHARU HANS on 7/17/12.
//  Copyright (c) 2012 University of Houston - Main Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class imageFilter;
@class Draw;

@interface ImageFilterViewController : UIViewController

@property (nonatomic, retain) imageFilter *filter;
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *alphaLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


- (void) saveProcessingResult:(id) sender;
- (IBAction)showPhotoLibrary:(id)sender;
- (IBAction)showCameraImage:(id)sender;
- (IBAction)feelingLucky:(id)sender;
//- (IBAction)sliderValueChangedAction:(UISlider *)sender otherSender:(UISlider*) sliderSender;
-(IBAction)sliderValueChangedAction:(UISlider *)sender;
-(IBAction)betaSliderValueChangedAction:(UISlider *)sender;
- (IBAction)doneButtonAction:(id)sender;
-(void)tweetImage;




@end
