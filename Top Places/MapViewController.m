//
//  MapViewController.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University. All rights reserved.
//

#import "MapViewController.h"
#import "FlickrPhotoAnnotation.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

@interface MapViewController() <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong)NSArray *annotations;//of id <MKAnnotation, by reading property photos

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize photos = _photos;
@synthesize delegate = _delegate;

#pragma mark - Synchronize Model and View

- (void)updateMapView
{
    // remove annotation already there
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    // add new annotations
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}


- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos){
        [annotations addObject:[FlickrPhotoAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    self.annotations = [self mapAnnotations];
    [self updateMapView];

}

#pragma mark - MKMapViewDelegate - SHOW ANNOTATION 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    NSLog(@"annotation: %@", annotation);

    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) {
        aView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        aView.leftCalloutAccessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    aView.annotation = annotation;

    return aView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    NSLog(@"aView %@", aView.annotation);

    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr thumbnail downloader", NULL);
    dispatch_async(downloadQueue, ^{
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)aView.annotation;
        NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
        NSData *data = [NSData dataWithContentsOfURL:url];

        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
             aView.leftCalloutAccessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
            [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        });
    });
}

- (PhotoViewController *)splitViewPhotoViewController {
    id pvc = [self.splitViewController.viewControllers lastObject];
    if (![pvc isKindOfClass:[PhotoViewController class]]) pvc = nil;
    return pvc;
}

// segue from the map view to photo
// if ipad show photoview
- (void) mapView:(MKMapView *)mapView
  annotationView:(MKAnnotationView *)view
  calloutAccessoryControlTapped:(UIControl *)control {

//if ([self splitViewPhotoViewController]) {
        FlickrPhotoAnnotation *fpa = (FlickrPhotoAnnotation *)view.annotation;
        [self splitViewPhotoViewController].photo = fpa.photo;
        [[self splitViewPhotoViewController] refreshWithPhoto:fpa.photo];
//   } else {
       // [self performSegueWithIdentifier:@"MapPhoto" sender:view];
//    }
    NSLog(@"Control Tapped %@", view.annotation);

}


#pragma mark - View Controller Lifecycle


- (void)viewWillAppear:(BOOL)animated
{
    MKMapRect regionToDisplay = [self mapRectForAnnotations:self.annotations];
    if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = regionToDisplay;
}

// Position the map so that all overlays and annotations are visible on screen.
- (MKMapRect) mapRectForAnnotations:(NSArray*)annotations
{
    MKMapRect mapRect = MKMapRectNull;
    
    //annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotations) {
        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        
        if (MKMapRectIsNull(mapRect))
        {
            mapRect = pointRect;
        } else
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    
    return mapRect;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
