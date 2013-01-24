//
//  main.m
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TopPlacesAppDelegate.h"
#import "FlickrFetcher.h"

int main(int argc, char *argv[])
{
	@autoreleasepool {
		
		/*
		 
		// First get a pointer to the topPlaces using the given FlickrFetcher method
		NSArray *topPlaces = [FlickrFetcher topPlaces];
		
		// How many top places in the array?
		NSLog(@"Number of top places returned: %i", [topPlaces count]);
		
		// What type of object is the value in the array?
		Class arrayObjectClass = [[topPlaces objectAtIndex:0] class];
		NSLog(@"Top places is an array of: %@", NSStringFromClass(arrayObjectClass));
		
		// Display the contents of the first item in the array
		NSLog(@"The description of the first top place is %@:", 
				[[topPlaces objectAtIndex:0] description]);
		
		// Get a pointer to the photos for the first top place
		NSArray *photosInPlace = [FlickrFetcher photosInPlace:[topPlaces objectAtIndex:0] 
																 maxResults:1];
		
		NSLog(@"The photos for the first top place description is %@:", 
				[photosInPlace description]);
		 
		*/		
		return UIApplicationMain(argc, argv, nil, 
										 NSStringFromClass([TopPlacesAppDelegate class]));
		 
	}
}
