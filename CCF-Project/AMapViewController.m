//
//  AMapViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 13/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "AMapViewController.h"

@interface AMapViewController ()

@end

@implementation AMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    self.mapView.delegate = self;
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
//    [self.mapView setShowsUserLocation:YES];
    
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = self.titleName;
//    point.subtitle = self.snippet;
    
    [self.mapView addAnnotation:point];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getDirectionsButton:(id)sender {
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",self.mapView.userLocation.coordinate.latitude, self.mapView.userLocation.coordinate.longitude, self.latitude, self.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
}
- (IBAction)backButton:(id)sender {
    
    UIView *viewShown = [((NSArray*)self.parentViewController.view.subviews) lastObject];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.parentViewController.view.layer addAnimation:transition forKey:nil];
    
    [viewShown removeFromSuperview];
    
    [self removeFromParentViewController];
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView *view = nil;
    static NSString *reuseIdentifier = @"MapAnnotation";
    
    // Return a MKPinAnnotationView with a simple accessory button
    view = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!view) {
        
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];

        view.image = [UIImage imageNamed:@"default_marker"];
        view.canShowCallout = YES;
//        view.animatesDrop = YES;
        
        
    }
    
    
    //Adding multiline subtitle code
    
    UILabel *subTitlelbl = [[UILabel alloc]init];
    subTitlelbl.text = self.snippet;
    subTitlelbl.font = [UIFont fontWithName:@"OpenSans-Light" size:14.0f];
    
    view.detailCalloutAccessoryView = subTitlelbl;
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:subTitlelbl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:150];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:subTitlelbl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
    [subTitlelbl setNumberOfLines:0];
    [subTitlelbl addConstraint:width];
    [subTitlelbl addConstraint:height];
    
    
    

    
    return view;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    for (id<MKAnnotation> currentAnnotation in mapView.annotations) {
        [mapView selectAnnotation:currentAnnotation animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
