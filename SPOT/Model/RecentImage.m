//
//  RecentImage.m
//  SPOT
//
//  Created by Martin on 22/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "RecentImage.h"

@implementation RecentImage

#define IMAGE_INFO_KEY @"imagae_info_key"
// Retreives all the recent seen images from the NSDefaultser (internal storage)
+(NSArray *)imagesInfo
{
    //creating a link to the internal storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //returns the data that are stored with the IMAGE_INFO_KEY key
    return [defaults objectForKey:IMAGE_INFO_KEY];

    
}
#define RECENT_IMAGE_MAX 20
+(void) addImagesInfo:(NSDictionary *)object
{
    //Creating a mutable array from the data that are retreived from the internal storage
    NSMutableArray *imagesInfoMutable = [[NSMutableArray alloc] initWithArray:[self imagesInfo]];
    
    //See if the array is bigger them a certain size.
    //if it is then removing the last object from the array.
    if([imagesInfoMutable count] >= RECENT_IMAGE_MAX){
        [imagesInfoMutable removeLastObject];
    }
    //See if the array contains the image info.
    //if it does then it is removed. This is done because we don't want dublicates.
    if([imagesInfoMutable containsObject:object])
    {
        [imagesInfoMutable removeObject:object];
    }
    //adding the image info to the front of the array
    [imagesInfoMutable replaceObjectsInRange:NSMakeRange(0,0)
                        withObjectsFromArray:@[object]];
    
    //creating a link to the internal storage, adding the array to the internal storage
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:imagesInfoMutable forKey:IMAGE_INFO_KEY];
    //Saving the add data to the internal storage.
    [defaults synchronize];
}

@end
