//
//  FlickrImageByTag.m
//  SPOT
//
//  Created by Martin on 21/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FlickrImageByTag.h"
#import "FlickrImages.h"
#import "FlickrFetcher.h"

@interface FlickrImageByTag ()<UISplitViewControllerDelegate>
@property (strong, nonatomic)FlickrImages *flickrImage;

@end

@implementation FlickrImageByTag 

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.flickrImageSortedInTags = [self.flickrImage imagesInfoByTag];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Looking for if it is the right class who are calling the method
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
             //seeing if the segue has the right identifer.
            if ([segue.identifier isEqualToString:@"ImageByTag"]) {
                //Looking at the destination controller and see if it has the method that it wants to run.
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    //Retreiving the tag from the choosen cell 
                    NSString *tag = [[self.flickrImageSortedInTags allKeys][indexPath.row] description];
                    //Retreiving all the image infos for the certain tag.
                    NSArray *imageInfo = [self.flickrImage imagesFromAGivenTag:tag];
                    //Setting the image infos in the destination controller
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:imageInfo];
                    //Setting the title in the destination controller
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}
-(FlickrImages *) flickrImage
{
    if(!_flickrImage){
        _flickrImage = [[FlickrImages alloc] init];
    }
    return _flickrImage;
}

-(void) setFlickrImageSortedInTags:(NSDictionary *)flickrImageSortedInTags
{
    _flickrImageSortedInTags = flickrImageSortedInTags;
}
-(void)flickrImageSortedInTags:(NSDictionary *)flickrImageSortedInTags{
    //Setting flickr Image and reloads the view
    _flickrImageSortedInTags = flickrImageSortedInTags;
    [self.tableView reloadData];
}
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
- (NSString *)titleForRow:(NSUInteger)row
{
    //Retreiving the tag name for a category
    NSString *string = [[self.flickrImageSortedInTags allKeys][row] description]; // description because could be NSNull
   //Setting the first letter uppercase.
    NSString *firstCapChar = [[string substringToIndex:1] capitalizedString];
    NSString *cappedString = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:firstCapChar];
    return cappedString;
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    //Counting how many images there are in the category for a certain tag.
    NSString *key = [self.flickrImageSortedInTags allKeys][row];
    return [NSString stringWithFormat:@"%d", [[self.flickrImageSortedInTags valueForKey:key] count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Returning the amount of images entries that are in the self.flickrImageSortedInTags
    //for setting the amount of cells in the tableview
    return [self.flickrImageSortedInTags count];
}

#define CELL_IDENTIFIER @"Tag Cell"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Retreiving a cell from the table view.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];

    //Setting the title and the subtitle of the current cell. 
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}




@end
