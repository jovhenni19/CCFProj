//
//  BaseViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) TWTRLogInButton *twitterLoginButton;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewMapButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
//    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapsVC"];
//    mapVC.titleName = button.locationName;
//    mapVC.snippet = button.locationSnippet;
//    mapVC.longitude = [button.longitude floatValue];
//    mapVC.latitude = [button.latitude floatValue];
    
    AMapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"amapsVC"];
    mapVC.titleName = button.locationName;
    mapVC.snippet = button.locationSnippet;

    mapVC.longitude = [button.longitude floatValue];
    mapVC.latitude = [button.latitude floatValue];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [mapVC.view.layer addAnimation:transition forKey:nil];
    
    
    mapVC.view.frame = self.view.bounds;
    [self.view addSubview:mapVC.view];
    [self addChildViewController:mapVC];
    [mapVC didMoveToParentViewController:self];
}

- (IBAction)saveDateCalendar:(id)sender {
    
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        // handle access here
        //            [self updateAuthorizationStatusToAccessEventStore];
        
        if(!granted) {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Calendar." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
        }
        else {
            self.isAccessToEventStoreGranted = YES;
            EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
            event.title = [NSString stringWithFormat:@"%@",@"YOUTH GATHERING"];
            
            NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc] init];
            [dateFormmatter setDateFormat:@"MM/dd/yyyy"];
            
            event.startDate = [dateFormmatter dateFromString:@"11/05/2017"];
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
            event.calendar = [self.eventStore defaultCalendarForNewEvents];
            event.notes = [NSString stringWithFormat:@"Event Details:\nAddress:%@\n",@"CCF CENTER"];
            NSTimeInterval aInterval = -1 * 60 * 60;
            EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
            [event addAlarm:alaram];
            
            NSError *err = nil;
            BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
            
            if (success) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Success" message:@"YOUTH GATHERING saved in calendar" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *close = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [ac addAction:close];
                [self presentViewController:ac animated:YES completion:^{
                    
                }];
            }
            else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"YOUTH GATHERING failed to saved in calendar.\nPlease allow the app to save in calendar." preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *close = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [ac addAction:close];
                [self presentViewController:ac animated:YES completion:^{
                    
                }];
            }
        }
        
    }];
    
    
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [[EKEventStore alloc] init];
    }
    return _eventStore;
}

- (EKCalendar *)calendar {
    if (!_calendar) {
        NSArray *calendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
        
        NSString *calendarTitle = @"YOUTH GATHERING";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title matches %@", calendarTitle];
        NSArray *filtered = [calendars filteredArrayUsingPredicate:predicate];
        
        if ([filtered count]) {
            _calendar = [filtered firstObject];
        } else {
            
            // 3
            _calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
            _calendar.title = @"YOUTH GATHERING";
            _calendar.source = self.eventStore.defaultCalendarForNewEvents.source;
            
            // 4
            NSError *calendarErr = nil;
            BOOL calendarSuccess = [self.eventStore saveCalendar:_calendar commit:YES error:&calendarErr];
            if (!calendarSuccess) {
                // Handle error
            }
        }
    }
    return _calendar;
}

- (void)updateAuthorizationStatusToAccessEventStore {
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    
    switch (authorizationStatus) {
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            self.isAccessToEventStoreGranted = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Access Denied"
                                                                message:@"This app doesn't have access to your Calendar." delegate:nil
                                                      cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alertView show];
            
            
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.isAccessToEventStoreGranted = YES;
            
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {
            __weak BaseViewController *weakSelf = self;
            [self.eventStore requestAccessToEntityType:EKEntityTypeEvent
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    weakSelf.isAccessToEventStoreGranted = granted;
                                                    
                                                });
                                            }];
            break;
        }
    }
}


- (IBAction)backButton:(id)sender {
    
    UIView *viewShown = [[[(self.parentViewController.view) viewWithTag:1990] subviews] lastObject];
    
    if (viewShown == nil) {
        NSLog(@"ERROR !!");
        
        return;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.parentViewController.view.layer addAnimation:transition forKey:nil];
    
    [viewShown removeFromSuperview];
    
    [self removeFromParentViewController];
    
    
}

- (IBAction)facebookButton:(id)sender {
//    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Facebook?" message:@"Would you like to follow our Facebook Page?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showWebViewWithURL:@"https://www.facebook.com/TheCCFCenter"];
//    }];
//    
//    [ac addAction:cancel];
//    [ac addAction:ok];
//    
//    [self presentViewController:ac animated:YES completion:nil];
    
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // TODO: publish content.
        
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentDescription = [NSString stringWithFormat:@"Join us!"];
        content.contentTitle = @"CCF Share!";
//        content.contentURL = [NSURL URLWithString:_restaurantURL];
//        content.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,_imageLogoURL]];
        
        FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
        dialog.fromViewController = self;
        dialog.shareContent = content;
        dialog.delegate = self;
        dialog.mode = FBSDKShareDialogModeFeedWeb;
        [dialog show];
        
        
        //        FBSDKShareAPI *share = [FBSDKShareAPI shareWithContent:content delegate:self];
        //        [share share];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        loginManager.loginBehavior = FBSDKLoginBehaviorWeb;
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                              NSLog(@"RESULT FACEBOOK:%@",result);
                                          }];
    }

}


- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
//    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Successfully shared restaurant on Facebook." delegate:self buttons:nil];
    //    [alert showAlertView];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
//    AlertView *alert = [[AlertView alloc] initAlertWithMessage:@"Failed to shared restaurant on Facebook." delegate:self buttons:nil];
    //    [alert showAlertView];
}



- (IBAction)twitterButton:(id)sender {
//    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Twitter?" message:@"Would you like to follow our Twitter?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showWebViewWithURL:@"https://twitter.com/CCFmain"];
//    }];
//    
//    [ac addAction:cancel];
//    [ac addAction:ok];
//    
//    [self presentViewController:ac animated:YES completion:nil];
    
    
    // Users must be logged-in to compose Tweets
    TWTRSession *session = [Twitter sharedInstance].sessionStore.session;
    
    if (session) {
        
        TWTRComposer *composer = [[TWTRComposer alloc] init];
        
        [composer setText:@"just setting up my Fabric"];
        [composer setImage:[UIImage imageNamed:@"fabric"]];
        
        // Called from a UIViewController
        [composer showFromViewController:self completion:^(TWTRComposerResult result) {
            if (result == TWTRComposerResultCancelled) {
                NSLog(@"Tweet composition cancelled");
            }
            else {
                NSLog(@"Sending Tweet!");
            }
        }];
    }
    else {
        
        UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Share with Twitter" message:@"Would you like to tweet this?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    NSLog(@"signed in as %@", [session userName]);
                    
                    [self twitterButton:sender];
                } else {
                    NSLog(@"error: %@", [error localizedDescription]);
                }
            }];
            
        }];
        
        [ac addAction:cancel];
        [ac addAction:ok];
        
        [self presentViewController:ac animated:YES completion:nil];
        
        
    }
    
}

- (void)closeTwitterLogin {
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.twitterLoginButton.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
}


- (IBAction)googleplusButton:(id)sender {
//    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Google+?" message:@"Would you like to follow our Google+?" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self showWebViewWithURL:@"https://plus.google.com/110122766101184546528"];
//    }];
//    
//    [ac addAction:cancel];
//    [ac addAction:ok];
//    
//    [self presentViewController:ac animated:YES completion:nil];
    
    // Construct the Google+ share URL
    NSURLComponents* urlComponents = [[NSURLComponents alloc]
                                      initWithString:@"https://plus.google.com/share"];
    urlComponents.queryItems = @[[[NSURLQueryItem alloc]
                                  initWithName:@"url"
                                  value:@"https://plus.google.com/110122766101184546528"]];
    NSURL* url = [urlComponents URL];
    
    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 9+)
        SFSafariViewController* controller = [[SFSafariViewController alloc]
                                              initWithURL:url];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

- (IBAction)youtubeButton:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Youtube?" message:@"Would you like to follow our Youtube?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showWebViewWithURL:@"https://www.youtube.com/user/CCFmainTV"];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void) showWebViewWithURL:(NSString*)urlString {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    
    [window addSubview:self.backgroundView];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.backgroundView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.backgroundView addSubview:blurEffectView];
    } else {
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
    }
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, self.backgroundView.frame.size.width - 30.0f, self.backgroundView.frame.size.height - 30.0f)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.scrollView.bounces = NO;
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    
    self.webview.layer.borderColor = [UIColor blackColor].CGColor;
    self.webview.layer.borderWidth = 2.0f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close-button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(-15.0f, -15.0f, 28.0f, 28.0f)];
    button.layer.zPosition = 1.0f;
    
    [self.webview addSubview:button];
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWebView)];
    [self.backgroundView addGestureRecognizer:tapClose];
    
    [self.backgroundView addSubview:self.webview];
    
    self.webview.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.webview.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.webview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            [self.webview loadRequest:request];
        }];
    }];
    
    
}

- (void) closeWebView {
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.webview.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
    
}

- (IBAction)callNumber:(id)sender {
    NSString *urlString = ((UIButton*)sender).titleLabel.text;
    [self openURL:[NSString stringWithFormat:@"tel://%@",urlString]];
}

- (IBAction)mailAddress:(id)sender {
    NSString *urlString = ((UIButton*)sender).titleLabel.text;
    [self openURL:[NSString stringWithFormat:@"mailto://%@",urlString]];
}

- (void) openURL:(NSString*)urlstring {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Error Loading Page" message:@"We experienced loading the page. Try again later." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [ac addAction:cancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully {
    
}

@end
