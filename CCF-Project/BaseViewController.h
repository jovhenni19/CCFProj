//
//  BaseViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "MapViewController.h"
#import "UIButton+LocationValues.h"

@interface BaseViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *mapButton;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) EKCalendar *calendar;

- (void) showWebViewWithURL:(NSString*)urlString;
- (void) openURL:(NSString*)urlstring;
- (IBAction)viewMapButton:(id)sender;
- (IBAction)saveDateCalendar:(id)sender;
- (IBAction)callNumber:(id)sender;
- (IBAction)mailAddress:(id)sender;
@end
