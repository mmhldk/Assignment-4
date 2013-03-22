//
//  Images.m
//  SPOT
//
//  Created by Martin on 21/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import "FlickrImages.h"
#import "FlickrFetcher.h"

@interface FlickrImages ()

@end

@implementation FlickrImages

-(NSArray *)imagesInfo
{
    if(!_imagesInfo)
    {
        //Retreives image data from stanford by using FlickrFetcher
        _imagesInfo = [FlickrFetcher stanfordPhotos];
    }
    return _imagesInfo;
}

-(NSDictionary *)imagesInfoByTag
{
    if(!_imagesInfoByTag){
        NSMutableDictionary *imagesInfobyTagMuable = [[NSMutableDictionary alloc] init];
        
        //Looks at all the image info that was retreived from flickr
        for (NSDictionary *imageInfo in self.imagesInfo)
        {
            //Selects all the tags from the picture and saves them in an array
            NSArray *tags = [[imageInfo valueForKey:FLICKR_TAGS] componentsSeparatedByString:@" "];
            for (NSString *tag in tags)
            {
                //Removing tags that isen't good
                if([tag isEqualToString:@"landscape"] ||
                   [tag isEqualToString:@"portrait"] ||
                   [tag isEqualToString:@"cs193pspot"]) continue;
                
                //retreives an array that contains all the image info for a given tag. 
                NSMutableArray *images = [imagesInfobyTagMuable objectForKey:tag];
                
                //See if the dictionary exists
                if(images)
                {   //adds the image info to the array
                    [images addObject:imageInfo];
                }else
                {
                    //Creates and add an array for the given tag that wasn't in the dictionary 
                    images = [[NSMutableArray alloc] initWithObjects:imageInfo, nil];
                    [imagesInfobyTagMuable setObject:images forKey:tag];
                }
                
            }
        }
        _imagesInfoByTag = imagesInfobyTagMuable;
    }
    
    return _imagesInfoByTag;
}


-(NSArray *)imagesFromAGivenTag:(NSString *)tag
{
    return [self.imagesInfoByTag valueForKey:tag];
}

@end
