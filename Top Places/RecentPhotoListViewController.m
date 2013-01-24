//
//  RecentlyViewedViewController.m
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentPhotoListViewController.h"

#define RECENT_PHOTOS_KEY @"RecentlyViewedPhotos.key"


@implementation RecentPhotoListViewController


- (void)setupModel {
	
	// Load photo list from NSUserDefaults
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.photoList = [[[defaults objectForKey:RECENT_PHOTOS_KEY] reverseObjectEnumerator] 
							allObjects];
		
	[self.tableView reloadData];

}

- (void) viewWillAppear:(BOOL)animated {
	// Hide the navigation bar for view controllers when this view appears
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];
	[self setupModel];
}

- (void) viewWillDisappear:(BOOL)animated {
	// Show the navigation bar for view controllers when this view disappears
	[self.navigationController setNavigationBarHidden:NO animated:animated];
	[super viewWillDisappear:animated];
}

@end
