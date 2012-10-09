//
//  DetailViewContoller.h
//  ImageFilter
//
//  Created by CHARU HANS on 8/12/12.
//  Copyright (c) 2012 University of Houston - Main Campus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageFilterViewController;

@interface DetailViewContoller : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (assign, nonatomic) unsigned int valueToRetrive;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (copy, nonatomic) NSString *name;

@end
