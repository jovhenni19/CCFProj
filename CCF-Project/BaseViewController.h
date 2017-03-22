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
#import "YMCAudioPlayer.h"
#import "CustomButton.h"

#import "NewsItem+CoreDataClass.h"
#import "PodcastsItem+CoreDataClass.h"
#import "EventsItem+CoreDataClass.h"
#import "SatellitesItem+CoreDataClass.h"
#import "ScrollableMenubarViewController.h"

#import "NewsObject.h"
#import "PodcastsObject.h"
#import "EventsObject.h"
#import "SatellitesObject.h"

#import "AppDelegate.h"

#define NETWORK_INDICATOR(bool)                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:bool];

#define MANAGE_CONTEXT                                                  ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext

#define TEAL_COLOR                                                      [UIColor colorWithRed:17.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f]

#define isNIL(key)                                                      (key && ![key isKindOfClass:[NSNull class]])?key:@""


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

@property (strong, nonatomic) UIProgressView *loadingProgressView;
@property (strong, nonatomic) YMCAudioPlayer *audioPlayerPauser1;
@property (strong, nonatomic) UITextField *textField1;

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

- (void) showLoadingAnimation:(UIView*)view;

- (void) removeLoadingAnimation;

- (void) reloadTables;
@end
