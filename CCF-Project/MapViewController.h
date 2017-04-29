//
//  MapViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 23/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapViewController : UIViewController
@property (assign, nonatomic) CGFloat longitude;
@property (assign, nonatomic) CGFloat latitude;
@property (strong, nonatomic) NSString *titleName;
@property (strong, nonatomic) NSString *snippet;

@end
