//
//  DataCache.h
//  Top Places
//
//  Created by David Barton on 20/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface DataCache : NSObject

// Constant to define the maximum size of the cache
#define MAXIMUM_CACHE_SIZE 10485760 // 10Mb

// Constant to define the trim size of the cache
#define TRIM_CACHE_SIZE 5242880 // 5Mb

// Used to fetch data from the cache
+ (NSData *) fetchData: (NSString *) key;

// Used to store data in the cache
+ (void) storeData: (NSString *)key: (NSData *) data;

@end
