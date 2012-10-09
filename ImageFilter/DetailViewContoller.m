//
//  DetailViewContoller.m
//  ImageFilter
//
//  Created by CHARU HANS on 8/12/12.
//  Copyright (c) 2012 University of Houston - Main Campus. All rights reserved.
//

#import "DetailViewContoller.h"
#import "ImageFilterViewController.h"

@interface DetailViewContoller ()
//-(void) display;
@property (nonatomic, strong) NSMutableArray *descriptionArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation DetailViewContoller

@synthesize detailTextView;
@synthesize valueToRetrive;
@synthesize detailImageView;
@synthesize name;


#pragma mark - 
#pragma mark Private Properties
@synthesize descriptionArray;
@synthesize imageArray;

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
	// Do any additional setup after loading the view.
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"data.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp) 
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    // assign values
    self.imageArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Names"]];
    self.descriptionArray = [NSMutableArray arrayWithArray:[temp objectForKey:@"Description"]];
    [self display:valueToRetrive displayTitle:name];
    

}

- (void)viewDidUnload
{
    [self setDetailTextView:nil];
    [self setDetailImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) display: (unsigned int) value displayTitle:(NSString*)theDisplayTitle
{
    if(theDisplayTitle == @"Image Effects")
    {
         detailTextView.text = [descriptionArray objectAtIndex:14];    
         detailImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:14]];
     }
     else 
     {
         detailTextView.text = [descriptionArray objectAtIndex:value];    
         detailImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:value]];
     }
    
}
@end
