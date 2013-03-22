//
//  ImageViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (strong, nonatomic) UIPopoverController *urlPopover;
@end

@implementation ImageViewController

// returns whether the "Show URL" segue should be allowed to fire
// prohibits the segue if we don't have a URL set in us yet or
//  if a popover showing the URL is already visible

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"Show URL"]) {
        return (self.imageURL && !self.urlPopover.popoverVisible) ? YES : NO;
    } else {
        return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
    }
}


// sets the title of the titleBarButtonItem (if connected) to the passed title
- (void)setTitle:(NSString *)title
{
    super.title = title;
    self.titleBarButtonItem.title = title;
}

- (void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //Calculating the delta-width and -height to set the image to fill the screen.
    CGFloat deltaWidth = self.scrollView.bounds.size.width / self.imageView.bounds.size.width;
    CGFloat deltaHeight = self.scrollView.bounds.size.height / self.imageView.bounds.size.height;
    //Checking if the image is height than width and setting the zoomScale such as the image fit the screen.
    if (deltaHeight > deltaWidth) self.scrollView.zoomScale = deltaHeight;
    else self.scrollView.zoomScale = deltaWidth;
}

- (void)resetImage
{
    //Reseting the scrollview and adds new image.
    if (self.scrollView) {
        //removing the old image and setting the scrollview boundings to zero
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        //Creating a new image from by retreiving it from a url.
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        //Init the scrollview with the image
        if (image) {
            self.scrollView.zoomScale = 1.0;
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

// sets the title of the titleBarButtonItem (if connected) to self.title
//  (just in case setTitle: was called before self.titleBarButtonItem outlet was loaded)

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    
    //Setting the possibility to zoom,
    //Setting the maximum and minimum that it is possible to zoom on a image.
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5.0;
    self.scrollView.delegate = self;
    [self resetImage];
    //Setting the tilte that apper in the navigetionbar.
    self.titleBarButtonItem.title = self.title;
}

@end
