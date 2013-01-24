//
//  MapViewController.h
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@protocol MapViewControllerDelegate <NSObject>
- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender;
- (UIImage *)mapViewController:(MapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface MapViewController : UIViewController
@property (nonatomic, strong) NSArray *photos; //segued from PhsInPlaceTVCler
@property (nonatomic, weak) id <MapViewControllerDelegate> delegate;
@end
