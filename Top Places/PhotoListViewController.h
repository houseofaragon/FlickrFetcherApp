//
//  PhotoDescriptionViewController.h
//  Top Places
//
//  Created by David Barton on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define TITLE_KEY @"title"
#define DESCRIPTION_KEY @"description._content"

@interface PhotoListViewController : UITableViewController

@property (nonatomic, strong) NSArray *photoList;
- (void) setPhotoList:(NSArray *)photoList withTitle:(NSString *)title;

@end
