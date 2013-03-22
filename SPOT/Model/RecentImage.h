//
//  RecentImage.h
//  SPOT
//
//  Created by Martin on 22/03/13.
//  Copyright (c) 2013 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentImage : NSObject

+(NSArray *)imagesInfo; // Retreives all the recent seen images from the NSDefaultser (internal storage)
+(void) addImagesInfo:(NSDictionary *)objects; // adds the object to the NSDefaultser (internal storage)
@end
