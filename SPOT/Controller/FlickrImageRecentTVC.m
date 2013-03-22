//
//  FlickrImageRecentTVC.m
//  SPOT
//
//  Created by Martin on 22/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FlickrImageRecentTVC.h"
#import "RecentImage.h"

@interface FlickrImageRecentTVC ()

@end

@implementation FlickrImageRecentTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Retrieves the recent images from the stored data.
	self.photos = [RecentImage imagesInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Everytime the view appears on the screen,
    //the view retreives the data from the internal storage.
    [super viewWillAppear:animated];
    self.photos = [RecentImage imagesInfo];
}

@end
