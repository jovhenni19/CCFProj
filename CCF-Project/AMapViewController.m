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
    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self.mapView setShowsUserLocation:YES];
    
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = self.titleName;
    point.subtitle = self.snippet;
    
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
    MKPinAnnotationView *view = nil;
    static NSString *reuseIdentifier = @"MapAnnotation";
    
    // Return a MKPinAnnotationView with a simple accessory button
    view = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
    if(!view) {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        view.canShowCallout = YES;
        view.animatesDrop = YES;
    }
    
    return view;
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
