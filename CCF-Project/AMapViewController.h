//
//  AMapViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 13/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface AMapViewController : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *snippet;

@end
