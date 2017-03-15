//
//  BaseViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <SafariServices/SafariServices.h>
#import <TwitterKit/TwitterKit.h>
#import "MapViewController.h"
#import "AMapViewController.h"
#import "UIButton+LocationValues.h"
#import "AFNetworking.h"



#define NETWORK_INDICATOR(bool)                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:bool];

//api links
extern NSString * const kAPI_LINK;
extern NSString * const kNEWS_LINK;
extern NSString * const kPODCAST_LINK;
extern NSString * const kEVENTS_LINK;
extern NSString * const kSATTELITES_LINK;

//observers
extern NSString * const kOBS_NEWS_NOTIFICATION;
extern NSString * const kOBS_PODCAST_NOTIFICATION;
extern NSString * const kOBS_EVENTS_NOTIFICATION;
extern NSString * const kOBS_SATTELITES_NOTIFICATION;
extern NSString * const kOBS_LOCATIONFINISHED_NOTIFICATION;

@interface BaseViewController : UIViewController <UIWebViewDelegate, FBSDKSharingDelegate, SFSafariViewControllerDelegate>
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


- (void)callAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionNotification:( nullable NSString*)notificationName;
- (void)callGETAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionNotification:( nullable NSString*)notificationName;

- (void)callPOSTAPI:( nullable NSString*)method withParameters:( nullable NSDictionary*)parameters completionHandler:(void  (^_Nullable)(id _Nullable response))completion;

- (void)getImageFromURL:(NSString*)urlPath  completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler andProgress:(void (^)(NSInteger expectedBytesToReceive, NSInteger receivedBytes))progress;
@end
