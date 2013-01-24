//
//  DisplayPhotoViewController.h
//  Top Places
//
//  Created by David Barton on 19/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (strong, nonatomic) NSDictionary *photo;

- (void)refreshWithPhoto:(NSDictionary *) photoDictionary;

@end
