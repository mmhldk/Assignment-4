//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "RecentImage.h"

@interface FlickrPhotoTVC() <UISplitViewControllerDelegate>
@end

@implementation FlickrPhotoTVC

- (void)setPhotos:(NSArray *)photos
{
    //Setting photos and reloads the view
    _photos = photos;
    [self.tableView reloadData];
}

#pragma mark - UISplitViewControllerDelegate

- (void)awakeFromNib
{
    self.splitViewController.delegate = self;
}

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Looking for if it is the right class who are calling the method
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            //Looking for if the segue has the right identifer.
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                //Looking at the destination controller and see if it has the method that it wants to run.
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:FlickrPhotoFormatLarge];
                    //Saving the image info for the image in the internal storage.
                    [RecentImage addImagesInfo:self.photos[indexPath.row]];
                    //Setting the url in the destination controller
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    //Setting the title in the destination controller
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Returning the amount of images entries that are in the self.photo
    //for setting the amount of cells in the tableview
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    //Retreiving the title of a image
    NSString *string = [self.photos[row][FLICKR_PHOTO_TITLE] description]; // description because could be NSNull
    
    //Setting the first letter uppercase.
    NSString *firstCapChar = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return cappedString;
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    //Retreiving the description of a image
    return [self.photos[row][FLICKR_PHOTO_DESCRIPTION_WITHOUT_CONTENT][FLICKR_PHOTO_CONTENT] description]; // description because could be NSNull
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Retreiving a cell from the table view.
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Setting the title and the subtitle of the current cell. 
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
