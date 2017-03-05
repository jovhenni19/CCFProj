//
//  MapViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 23/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface MapViewController ()
@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    NSLog(@"######### map[%f,%f]: %@ - %@",self.latitude, self.longitude, self.titleName, self.snippet);
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:24.478502
                                                            longitude:54.363266
                                                                 zoom:17];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
    [self.view addSubview:self.backButton];
    
    [self.backButton setFrame:CGRectMake(10.0f, 10.0f, self.backButton.frame.size.width, self.backButton.frame.size.height)];
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(24.478502, 54.363266);
    marker.title = self.titleName;
    marker.snippet = self.snippet;
    marker.map = self.mapView;
    
    UILayoutGuide *marginLayout = self.view.layoutMarginsGuide;
    
    [self.view addConstraint:[self.backButton.leadingAnchor constraintEqualToAnchor:marginLayout.leadingAnchor constant:0.0f]];
    [self.view addConstraint:[self.backButton.topAnchor constraintEqualToAnchor:marginLayout.topAnchor constant:20.0f]];
    [self.backButton addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:44.0f]];
    [self.backButton addConstraint:[NSLayoutConstraint constraintWithItem:self.backButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:44.0f]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
