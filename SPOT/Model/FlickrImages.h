//
//  Images.h
//  SPOT
//
//  Created by Martin on 21/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrImages : NSObject

@property (strong, nonatomic)NSArray *imagesInfo; // of Dictionaries
@property (strong, nonatomic)NSDictionary *imagesInfoByTag; //with tags contaning arrays of Dictionaries
-(NSArray *)imagesFromAGivenTag:(NSString *)tag;

@end
