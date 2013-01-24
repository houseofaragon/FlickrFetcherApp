//
//  TopPlacesViewController.m
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "FlickrFetcher.h"
#import "PhotoListViewController.h"

@interface TopPlacesViewController() 

@property (strong, nonatomic) NSDictionary *placesByCountry;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@end

@implementation TopPlacesViewController

@synthesize topPlaces = _topPlaces;

@synthesize placesByCountry = _placesByCountry;
@synthesize sectionHeaders = _sectionHeaders;
@synthesize spinner = _spinner;


#define CONTENT_KEY @"_content"


#pragma mark - Setup methods

- (NSString *)parseForCountry: (NSDictionary *) topPlace {
	
	// Get the place information from the given topPlace
	NSString *placeInformation = [topPlace objectForKey:CONTENT_KEY];
	
	// Search the place information for the last comma. 
	NSRange lastComma = [placeInformation rangeOfString:@"," options:NSBackwardsSearch];
	
	// Return the text that comes after the last comma
	if (lastComma.location != NSNotFound) {
		return [placeInformation substringFromIndex:lastComma.location + 2];
	} else return @"";
	
	
}

- (UIActivityIndicatorView *)spinner {
	
	// If we don't have a spinner, then set one up
	if (!_spinner) {
		
	 	// Setup the spinner
		_spinner =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
					  UIActivityIndicatorViewStyleWhite];		
		
		// Add the spinner to the tab bar
		[self.tabBarController.tabBar addSubview:_spinner];			
		
	}
	
	return _spinner;
}



- (void)loadTopPlaces {
	
	
	// Only load data if not set up already
	if (self.topPlaces) return;
   
	// Create a sorted array of place descriptions
	NSArray *sortDescriptors = [NSArray arrayWithObject:
										 [NSSortDescriptor sortDescriptorWithKey:CONTENT_KEY 
																				 ascending:YES]];
	
	// Set up the array of top places, organised by place descriptions
	self.topPlaces = [[FlickrFetcher topPlaces] sortedArrayUsingDescriptors:sortDescriptors];
	
	// divide the places up by country, so we can use a dictionary with the 
	// country names as key and the places as values
	NSMutableDictionary *placesByCountry = [NSMutableDictionary dictionary];
			
	// For each place
	for (NSDictionary *place in self.topPlaces) {
		// extract the country name
		NSString *country = [self parseForCountry:place];	
		// If the country isn't already in the dictionary, add it with a new array
		if (![placesByCountry objectForKey:country]) {
			[placesByCountry setObject:[NSMutableArray array] forKey:country];
		}
		// Add the place to the countries' value array
		[(NSMutableArray *)[placesByCountry objectForKey:country] addObject:place];		
	}
			
	// Set the place by country
	self.placesByCountry = [NSDictionary dictionaryWithDictionary:placesByCountry];
			
	// Set up the section headers in alphabetical order	
	self.sectionHeaders = [[placesByCountry allKeys] sortedArrayUsingSelector: 
								  @selector(caseInsensitiveCompare:)];

}


- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	// Animate the spinner
	[self.spinner startAnimating];
	
	// Initialise the queue used to download from flickr
	dispatch_queue_t dispatchQueue = dispatch_queue_create("q_loadTopPlaces", NULL);
	
	// Use the download queue to asynchronously get the list of Top Places
	dispatch_async(dispatchQueue, ^{ 
		
		[self loadTopPlaces];
		
		// Use the main queue to refresh update the view
		dispatch_async(dispatch_get_main_queue(), ^{	
			[self.tableView reloadData]; // Seems to be ok without check for self.tableView.window
			[self.spinner stopAnimating];
		});
		
	});	
	// Release the queue
	
	// Preserve selection between presentations.
   self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	

}

- (void) viewWillAppear:(BOOL)animated {
	// Hide the navigation bar for view controllers when this view appears
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	[super viewWillAppear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

	// Return the number of sections
	return self.sectionHeaders.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// Return the header at the given index
	return [self.sectionHeaders objectAtIndex:section];	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
	// Return the number of rows for the given the section
	return [[self.placesByCountry objectForKey:
				[self.sectionHeaders objectAtIndex:section]] count];

}



- (UITableViewCell *)tableView:(UITableView *)tableView 
			cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
	static NSString *CellIdentifier = @"Top Place Descriptions";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];


	// Get a handle the dictionary that contains the selected top place information
	NSDictionary *topPlaceDictionary = 
	[[self.placesByCountry objectForKey:[self.sectionHeaders objectAtIndex:indexPath.section]] 
	 objectAtIndex:indexPath.row];

	// Extract the place name information for the cell
	NSString *topPlaceDescription = [topPlaceDictionary objectForKey:CONTENT_KEY];
	
	// Format the top place description into the cell's title and subtitle
	// Check to see if place description has a comma
	NSRange firstComma = [topPlaceDescription rangeOfString:@","];
	
	// If no comma, then title is place description and we have no subtitle, otherwise set the 
	// title to everything before the comma and the subtitle to everything after it.
	if (firstComma.location == NSNotFound) {
		cell.textLabel.text = topPlaceDescription;
		cell.detailTextLabel.text = @"";
	} else {
		cell.textLabel.text = [topPlaceDescription substringToIndex:firstComma.location];
		cell.detailTextLabel.text = [topPlaceDescription substringFromIndex:
											  firstComma.location + 1];		
	}	
   return cell;	 
}


#pragma mark - Segueing

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	int section = self.tableView.indexPathForSelectedRow.section;
	int row = self.tableView.indexPathForSelectedRow.row;
	
	
	// Identify the selected place from within the places by country dictionary
	NSDictionary *placeDictionary = 
		[[self.placesByCountry valueForKey:
		  [self.sectionHeaders objectAtIndex:section]] objectAtIndex:row];
	
	[self.topPlaces objectAtIndex:self.tableView.indexPathForSelectedRow.row];
	
	

	// Initialise the queue used to download from flickr
	dispatch_queue_t dispatchQueue = dispatch_queue_create("q_photosInPlace", NULL);
	[self.spinner startAnimating];	
	
	// Using the dowload queue, fetch the array of photos based on the selected dictionary
	dispatch_async(dispatchQueue, ^{ 
		
		NSArray *photos = [FlickrFetcher photosInPlace:placeDictionary maxResults:50];		

		// Use the main queue to prepare for segue 
		dispatch_async(dispatch_get_main_queue(), ^{	
			// Set up the photo descriptions in the PhotoDescriptionViewController
			[[segue destinationViewController] setPhotoList:photos
															  withTitle:[[sender textLabel] text]];			
			[[[segue destinationViewController] tableView] reloadData];
			[self.spinner stopAnimating];
		});
		
	});	
	
}





























@end
