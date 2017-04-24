//
//  ScrollableMenubarViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "ScrollableMenubarViewController.h"
#import "NewsTableViewController.h"
#import "MapViewController.h"
#import "EventsTableViewController.h"
#import "SattelitesTableViewController.h"
#import "LiveStreamingViewController.h"
#import "PodcastViewController.h"
#import "SettingsTableViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "DownloadsViewController.h"
//#import "SRScreenRecorder.h"


@interface ScrollableMenubarViewController ()

@property (strong, nonatomic) UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotificationBadge;
@property (weak, nonatomic) IBOutlet UIImageView *leftarrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightarrow;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *imageLogoTop;

@property (assign, nonatomic) BOOL fromViewLoad;
@property (assign, nonatomic) BOOL settingView;

@property (assign, nonatomic) CGFloat preOffsetX;

@property (assign, nonatomic) BOOL networkActivityIsShown;

@property (strong, nonatomic) NSMutableArray *eventBindingArray;

@end

@implementation ScrollableMenubarViewController
@synthesize pusherClient = _pusherClient;

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder])) {
        // setup code
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
//    UIApplication *app = [UIApplication sharedApplication];
//    UIWindow *window = [app keyWindow];
//    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -app.statusBarFrame.size.height, window.rootViewController.view.bounds.size.width + 200.0f, app.statusBarFrame.size.height)];
//    statusBarView.backgroundColor = [UIColor colorWithRed:17.0f/255.0f green:179.0f/255.0f blue:196.0f/255.0f alpha:1.0f];
//    
//    [window addSubview:statusBarView];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetworkActivityIndicator:) name:@"obs_progress" object:nil];
    
    self.viewForProgressLoading.frame = CGRectMake(self.viewForProgressLoading.frame.origin.x, self.viewForProgressLoading.frame.origin.y, 0.0f, 2.0f);
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(self.menuBarView.bounds.origin.x, self.menuBarView.bounds.origin.y, self.menuBarView.bounds.size.width + 10.0f, 30.0f)];
    self.menuBarView.layer.masksToBounds = NO;
    self.menuBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.menuBarView.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.menuBarView.layer.shadowOpacity = 0.35f;
    self.menuBarView.layer.shadowPath = shadowPath.CGPath;
    
    
    self.labelNotificationBadge.clipsToBounds = YES;
    self.labelNotificationBadge.layer.cornerRadius = 6.0f;
    self.labelNotificationBadge.text = @"1";
    
    NewsTableViewController *newsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"news"];
    PodcastViewController *podcastViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"podcast"];
    EventsTableViewController *eventsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"events"];
    SattelitesTableViewController *sViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sattelites"];
    LiveStreamingViewController *streamViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"live"];
    DownloadsViewController *downloadedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"downloaded"];
    SettingsTableViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:newsViewController, podcastViewController, eventsViewController,sViewController,streamViewController,downloadedViewController,settingsViewController, nil];
    
//    self.scrollViewBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.menuBarView.bounds.size.width, 34.0f)];
    [self.scrollViewBar setZoomScale:0.0f];
    [self.scrollViewBar setScrollEnabled:YES];
    [self.scrollViewBar setBounces:NO];
    [self.scrollViewBar setDelegate:self];
    [self.scrollViewBar setContentSize:CGSizeZero];
//    [self.scrollView setPagingEnabled:YES];
    self.scrollViewBar.backgroundColor = [UIColor clearColor];
    [self.scrollViewBar setShowsVerticalScrollIndicator:NO];
    [self.scrollViewBar setShowsHorizontalScrollIndicator:NO];
//    [self.menuBarView addSubview:self.scrollViewBar];
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 32.0f, 80.0f, 2.0f)];
    self.indicatorView.backgroundColor = (!self.foreColor)?[UIColor whiteColor]:self.foreColor;
    self.indicatorView.hidden = NO;
    [self.scrollViewBar addSubview:self.indicatorView];
    
    self.leftarrow.hidden = YES;
    self.rightarrow.hidden = YES;
    // CREATE THE MENU BAR ITEMS
    NSMutableArray *menuBarTitles = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (UIViewController *vc in self.viewControllers) {
        NSString *title = vc.title;
        if (title.length == 0) {
            title = @"???";
        }
        [menuBarTitles addObject:title];
    }
    
    self.menuButtonList = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
    
    CGFloat x = 0.0f;
    CGFloat defaultWidth = 100.0f;
    for (NSInteger index = 0; index < menuBarTitles.count; index++) {
        NSString *title = [menuBarTitles[index] uppercaseString];
        CGFloat computedWidth = defaultWidth;
        
        CGSize maximumLabelSize = CGSizeMake(FLT_MAX, 32.0f);
        
        CGSize expectedLabelSize = [title boundingRectWithSize:maximumLabelSize options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:19.0f]} context:nil].size;
        
        if (expectedLabelSize.width > computedWidth) {
            computedWidth = expectedLabelSize.width;
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, 0.0f, computedWidth, 32.0f);
        button.tag = index;
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        button.backgroundColor = [UIColor clearColor];
        [button setTitleColor:(!self.foreColor)?[UIColor whiteColor]:self.foreColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeSelectedViewController:) forControlEvents:UIControlEventTouchUpInside];
//        button.layer.borderWidth = 2.0f;
        [self.scrollViewBar addSubview:button];
        
        [self.menuButtonList addObject:button];
        
        if (x + computedWidth > self.scrollViewBar.contentSize.width) {
            [self.scrollViewBar setContentSize:CGSizeMake(self.scrollViewBar.contentSize.width + computedWidth, 0.0f)];
            
            self.rightarrow.hidden = NO;
        }
        
        x += computedWidth;
//        if (index == 0) {
//            [self changeSelectedViewController:button];
//        }
    }
    
    self.fromViewLoad = YES;
    self.settingView = NO;
    
//    self.horizontalTableview.transform=CGAffineTransformMakeRotation(-M_PI_2);
    
//    self.horizontalTableview.backgroundColor = [UIColor greenColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize = CGSizeMake(412.0f, 625.0f);
//    layout.sectionInset = UIEdgeInsetsMake(0.0f, 1.0f, 0.0f, 1.0f);
//    layout.estimatedItemSize =  CGSizeMake(408.0f, 620.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 0.0f;
//    layout.minimumInteritemSpacing = 0.0f;
    
    [self.horizontalTableview setCollectionViewLayout:layout];
    
    
//    UILongPressGestureRecognizer *holdGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recorderGesture:)];
//    holdGesture.numberOfTouchesRequired = 1;
//    holdGesture.minimumPressDuration = 10;
//    
//    [self.imageLogoTop addGestureRecognizer:holdGesture];
    [self.pusherClient connect];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callGroupsData:) name:kOBS_GROUPS_NOTIFICATION object:nil];
    
    [self callGETAPI:kGROUPS_LINK withParameters:nil completionNotification:kOBS_GROUPS_NOTIFICATION];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
//    if (self.fromViewLoad) {
//        self.fromViewLoad = NO;
//        [self.horizontalTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        [self.horizontalTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_news_from_pusher" object:self.newsFromPusher];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
//    NSLog(@"## __%s__[%@]",__FUNCTION__,NSStringFromCGSize(self.containerViewForTable.frame.size));
//    [self rearrangeLayout];
    
//    CGRect frame = self.horizontalTableview.frame;
//    frame.size.width = self.containerViewForTable.frame.size.height;
//    frame.size.height = self.containerViewForTable.frame.size.width;
//    self.horizontalTableview.frame = frame;
//    
//    self.horizontalTableview.transform=CGAffineTransformMakeRotation(-M_PI_2);
//    frame = self.horizontalTableview.frame;
//    frame.origin = CGPointZero;
//    self.horizontalTableview.frame = frame;
//    
//    
//    [self.horizontalTableview reloadData];
    
    if(self.fromViewLoad){
        self.fromViewLoad = NO;
        
        [[NSUserDefaults standardUserDefaults] setFloat:self.containerViewForTable.frame.size.width forKey:@"horizontal_width"];
        [[NSUserDefaults standardUserDefaults] setFloat:self.containerViewForTable.frame.size.height forKey:@"horizontal_height"];
        
        [self.horizontalTableview reloadData];
        
        [self performSelector:@selector(reloadNews) withObject:self afterDelay:1];
        [self performSelector:@selector(reloadPodcast) withObject:self afterDelay:2];
    }
    
    
    
}

- (void)callGroupsData:(NSNotification*)notification {
    //    NSLog(@"## result:%@",notification.object);
    
    
    //    NETWORK_INDICATOR(NO)
    
    if(!self.groupList){
        self.groupList = [NSMutableArray array];
    }
    
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    NSArray *data = result[@"data"];
    
    BOOL allIsOn = YES;
    
    for (NSDictionary *item in data) {
        [self.groupList addObject:item];
        
        
        
        NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
        
        BOOL switchValue = [[NSUserDefaults standardUserDefaults] boolForKey:valueKey];
        
        if (switchValue == YES) {
            allIsOn = NO;
        }
    }
    
    if (allIsOn) {
        for (NSDictionary *item in self.groupList) {
            [self subscribeEvent:item[@"interest"]];
        }
    }
    else {
        for (NSDictionary *item in self.groupList) {
            
            NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
            
            BOOL switchValue = [[NSUserDefaults standardUserDefaults] boolForKey:valueKey];
            
            if (switchValue == YES) {
                [self subscribeEvent:item[@"interest"]];
            }
            else {
                [self unSubscribeEvent:item[@"interest"]];
            }
        }
    }
        
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOBS_GROUPS_NOTIFICATION object:nil];
}


- (void)callGETAPI:(NSString*)method withParameters:(NSDictionary*)parameters completionNotification:(NSString*)notificationName{
    
    NSURL *baseURL = [NSURL URLWithString:kAPI_LINK];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //    NSLog(@"base:%@ method:%@",baseURL,method);
    [self callGetSessionManager:manager :method :parameters :notificationName];
}

- (void)callGetSessionManager:(AFHTTPSessionManager*)manager :(NSString*)method :(NSDictionary*)parameters :(NSString*)notificationName {
    
    
    NETWORK_INDICATOR(YES)
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@YES];
    
    
    [manager GET:method parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //        NSLog(@"#GET# progress:%f",[downloadProgress fractionCompleted]);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NETWORK_INDICATOR(NO)
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
        if ([responseObject isKindOfClass:[NSError class]] || ([responseObject isKindOfClass:[NSDictionary class]] && [[responseObject allKeys] containsObject:@"error"])) {
            if ([responseObject isKindOfClass:[NSError class]]) {
                
                NSError *error = (NSError*)responseObject;
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)error.code] message:error.description preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [alert dismissViewControllerAnimated:YES completion:^{
                    }];
                }];
                [alert addAction:actionOK];
                
                [self presentViewController:alert animated:YES completion:^{
                    
                }];
            }
            else {
                
                ;
            }
            
        }
        else if ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSDictionary class]]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:responseObject];
        }
        else {
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NETWORK_INDICATOR(NO)
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Error %li",(long)[error code]] message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:actionOK];
        
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }];
    
    
}

- (void) reloadNews {
    
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
//    notification.alertBody = @"THIS IS a LocalNotification";
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    notification.applicationIconBadgeNumber = 1;
//    
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    
    [self.horizontalTableview reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    UIButton *buttonMenuNews = self.menuButtonList[0];
    
    self.indicatorView.frame = CGRectMake(buttonMenuNews.frame.origin.x + 10.0f, 32.0f, buttonMenuNews.frame.size.width - 20.0f, 2.0f);
    
    
    [self autoScrollMenuViewBarWithButton:buttonMenuNews];
}

- (void) reloadPodcast {
    
    [self.horizontalTableview reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:1 inSection:0]]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    [self.horizontalTableview layoutSubviews];
//    [self.horizontalTableview reloadData];
}


- (BOOL)shouldAutorotate {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        return NO;
    }
    
    
    return NO;
}

- (void) rearrangeLayout {
    
//    self.containerViewForTable.layer.borderColor = [UIColor redColor].CGColor;
//    self.containerViewForTable.layer.borderWidth = 1.0f;
//    self.horizontalTableview.layer.borderWidth = 1.0f;
//    self.horizontalTableview.layer.borderColor = [UIColor blueColor].CGColor;
    
    CGRect frame = self.horizontalTableview.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    frame.size.width = [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_width"];//self.containerViewForTable.frame.size.height;
    frame.size.height = [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_height"];//self.containerViewForTable.frame.size.width;
    self.horizontalTableview.frame = frame;
    
//    self.horizontalTableview.backgroundColor = [UIColor greenColor];
    
//    NSLog(@"##_%s_:%@",__FUNCTION__,NSStringFromCGRect(self.horizontalTableview.frame));
    
    [self.horizontalTableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeSelectedViewController:(UIButton*)sender {
//    [self setCurrentViewController:sender.tag];
    self.horizontalTableview.delegate = nil;
    [self.horizontalTableview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    [self.horizontalTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.indicatorView.frame = CGRectMake(sender.frame.origin.x + 10.0f, 32.0f, sender.frame.size.width - 20.0f, 2.0f);
    
    BaseViewController *vc = [self.viewControllers objectAtIndex:sender.tag];
    [vc reloadTables];
    self.horizontalTableview.delegate = self;
    
    [self autoScrollMenuViewBarWithButton:sender];
}

//- (void) setCurrentViewController:(NSInteger)index {
//    self.settingView = YES;
//    self.selectedIndex = index;
//    self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
//    
//    UIButton *button = [self.menuButtonList objectAtIndex:self.selectedIndex];
//
//    [UIView animateWithDuration:0.5f animations:^{
//        self.indicatorView.frame = CGRectMake(button.frame.origin.x + 10.0f, 32.0f, button.frame.size.width - 20.0f, 2.0f);
//        
//    } completion:^(BOOL finished) {
//        
//        [self.scrollView scrollRectToVisible:self.indicatorView.bounds animated:YES];
//        
//        while ([[self.containerView subviews] count] > 0) {
//            [[[self.containerView subviews] lastObject] removeFromSuperview];
//        }
//
//        
//        self.selectedViewController.view.frame = self.containerView.bounds;
//        [self.containerView addSubview:self.selectedViewController.view];
//        [self addChildViewController:self.selectedViewController];
//        [self.selectedViewController didMoveToParentViewController:self];
//        
//        [self.pagingScrollview addSubview:self.containerView];
//        
//        CGSize viewSize = self.containerView.bounds.size;
//        
//        UIView *prevView = nil;
//        
//        UIView *nextView = nil;
//        
//        [self.pagingScrollview setContentSize:viewSize];
//        
//        if (self.selectedIndex > 0) {
//            prevView = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width*-1, 0.0f, viewSize.width, viewSize.height)];
//            prevView.backgroundColor = [UIColor greenColor];
//            
//            [self.pagingScrollview addSubview:prevView];
//            
//            
//            UIViewController *prevVC = [self.viewControllers objectAtIndex:self.selectedIndex-1];
//            prevVC.view.frame = prevView.bounds;
//            [prevView addSubview:prevVC.view];
//            
//            [self.pagingScrollview setContentSize:CGSizeMake(self.pagingScrollview.contentSize.width + viewSize.width, 0.0f)];
//            
////            CGRect frame = prevView.frame;
////            frame.origin = CGPointMake(0.0f, 0.0f);
////            prevView.frame = frame;
////            
////            frame = self.containerView.frame;
////            frame.origin = CGPointMake(viewSize.width, 0.0f);
////            self.containerView.frame = frame;
////            
////            [self.pagingScrollview setContentOffset:CGPointMake(viewSize.width, 0.0f)];
//            
//        }
//        
//        
//        if (self.selectedIndex < self.viewControllers.count-1) {
//            nextView = [[UIView alloc] initWithFrame:CGRectMake(self.containerView.frame.origin.x + self.containerView.frame.size.width, 0.0f, viewSize.width, viewSize.height)];
//            nextView.backgroundColor = [UIColor yellowColor];
//            
//            [self.pagingScrollview addSubview:nextView];
//            
//            UIViewController *nextVC = [self.viewControllers objectAtIndex:self.selectedIndex+1];
//            nextVC.view.frame = nextView.bounds;
//            [nextView addSubview:nextVC.view];
//            
//            [self.pagingScrollview setContentSize:CGSizeMake(self.pagingScrollview.contentSize.width + viewSize.width, 0.0f)];
//        }
//        
//        self.settingView = NO;
//    }];
//    
//    
//}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)showNotifications:(id)sender {
    [self.horizontalTableview scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    [self.horizontalTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.scrollViewBar]) {
        self.leftarrow.hidden = NO;
        self.rightarrow.hidden = NO;
        if (scrollView.contentOffset.x <= 0) {
            self.leftarrow.hidden = YES;
        }
        else if(scrollView.contentOffset.x + scrollView.bounds.size.width + 20.0f >= scrollView.contentSize.width) {
            self.rightarrow.hidden = YES;
        }
    }
    else if ([scrollView isEqual:self.pagingScrollview] && !self.settingView) {
        
//        if (scrollView.contentOffset.x < ((scrollView.frame.size.width/3)-10)*-1) {
//            if (self.selectedIndex > 0) {
//                [self setCurrentViewController:self.selectedIndex-1];
//            }
//        }
//        else if (scrollView.contentOffset.x > ((scrollView.frame.size.width/3)-10)) {
//            if (self.selectedIndex < self.viewControllers.count-1) {
//                [self setCurrentViewController:self.selectedIndex+1];
//            }
//        }
        
    }
    
    else if([scrollView isEqual:self.horizontalTableview]){
        
//        CGFloat xOffset = ((self.horizontalTableview.contentOffset.x - self.preOffsetX) * 0.25);
//        self.indicatorView.frame = CGRectMake(self.indicatorView.frame.origin.x + xOffset, self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
//        self.preOffsetX = self.horizontalTableview.contentOffset.x;
        
//        if (self.indicatorView.frame.origin.x < self.scrollViewBar.contentOffset.x + 10.0f) {
//            self.scrollViewBar.contentOffset = CGPointMake(self.scrollViewBar.contentOffset.x - (xOffset*2) , self.scrollViewBar.contentOffset.y);
//        }
//        else if ((self.indicatorView.frame.origin.x + self.indicatorView.frame.size.width) > (self.scrollViewBar.contentOffset.x + self.scrollViewBar.frame.size.width)) {
//            self.scrollViewBar.contentOffset = CGPointMake(self.scrollViewBar.contentOffset.x + (xOffset*2), self.scrollViewBar.contentOffset.y);
//        }
        
        
//        CGFloat pageWidth = self.containerViewForTable.bounds.size.width;
//        NSInteger index = (long)floor((self.horizontalTableview.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
//        self.selectedIndex = index;
//        UIButton *button = [self.menuButtonList objectAtIndex:self.selectedIndex];
//        self.indicatorView.frame = CGRectMake(button.frame.origin.x + 10.0f, 32.0f, button.frame.size.width - 20.0f, 2.0f);
//
//        CGFloat result = 0.0f;
//        CGFloat buttonWidth = button.bounds.size.width + 5.0f;
////        CGFloat contentWidth = self.menuBarView.bounds.size.width;
//        
//        CGFloat xPoint = buttonWidth * (self.selectedIndex + 1);
//        
////        CGFloat diff = (contentWidth/2.0f) - (buttonWidth/2.0f);
////        
////        
////        if (offsetX - diff > 0) {
////            if (offsetX + self.scrollViewBar.bounds.size.width + diff) {
////                result = self.scrollViewBar.contentSize.width - self.scrollViewBar.bounds.size.width;
////            }
////            else {
////                result = offsetX - diff;
////            }
////        }
//        
//        if (xPoint > self.menuBarView.bounds.size.width) {
//            result = xPoint - self.menuBarView.bounds.size.width;
//        }
//        else if (xPoint < self.scrollViewBar.contentOffset.x) {
//            result = xPoint;
//        }
//            
//        [self.scrollViewBar setContentOffset:CGPointMake(result, 0.0f) animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.horizontalTableview]) {
        
        CGFloat pageWidth = self.containerViewForTable.bounds.size.width;
        NSInteger index = (long)floor((self.horizontalTableview.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        
//        NSLog(@"index:%li",(long)index);
        
        UIButton *button = [self.menuButtonList objectAtIndex:index];
        self.indicatorView.frame = CGRectMake(button.frame.origin.x + 10.0f, 32.0f, button.frame.size.width - 20.0f, 2.0f);
        
        [self autoScrollMenuViewBarWithButton:button];
    }
}

- (void) autoScrollMenuViewBarWithButton:(UIButton*)button {
    
    CGFloat offsetX = button.frame.origin.x;// + ((self.scrollViewBar.frame.size.width/2) - (button.frame.size.width/2));
    
    if (offsetX < 0.0f) {
        offsetX = 0.0f;
    }
    else if (offsetX + self.scrollViewBar.frame.size.width > self.scrollViewBar.contentSize.width) {
        offsetX = self.scrollViewBar.contentSize.width - self.scrollViewBar.frame.size.width;
    }
    
    [self.scrollViewBar setContentOffset:CGPointMake(offsetX, 0.0f) animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 414.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForViewController"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForViewController"];
    }
    
    cell.transform=CGAffineTransformMakeRotation(M_PI_2);
    cell.clipsToBounds = YES;
    cell.contentView.tag = 1990 + ([indexPath row]);
    cell.contentView.layer.borderWidth = 1.0f;
    
    
//    BaseViewController *vc = [self.viewControllers objectAtIndex:[indexPath row]];
//    [vc reloadTables];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
//    if (self.selectedIndex == 3) {
//       SattelitesTableViewController *vc = [self.viewControllers objectAtIndex:self.selectedIndex];
//        [vc.searchTextfield resignFirstResponder];
//    }
    
    
//    if (self.selectedIndex == 1) {
//        PodcastDetailsTableViewController *vc = [self.viewControllers objectAtIndex:1];
//        if ([vc respondsToSelector:@selector(audioPlayer)]) {
//            [vc.audioPlayer pauseAudio];
//        }
//    }
    
    
//    CGRect frame = self.containerViewForTable.frame;
//    frame.origin.x = 0.0f;
//    frame.origin.y = 0.0f;
//    frame.size.width = [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_width"];//self.containerViewForTable.frame.size.height;
//    frame.size.height = [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_height"];//self.containerViewForTable.frame.size.width;
//    self.containerViewForTable.frame = frame;
    
    [self loadViewControllerWithContentView:cell.contentView index:[indexPath row]];
    
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
//    cell.transform=CGAffineTransformMakeRotation(M_PI_2);
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self loadViewControllerWithContentView:cell.contentView index:[indexPath row]];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize mElementSize = self.containerViewForTable.frame.size;
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}



- (void) loadViewControllerWithContentView:(UIView*)contentView index:(NSInteger)index {
    [self.view endEditing:YES];
    self.selectedIndex = index;
    
    BaseViewController *vc = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_podcast_pause1" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_podcast_pause2" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_podcast_pause3" object:nil];
    
//    if (![vc respondsToSelector:@selector(audioPlayerPauser)] || ![vc respondsToSelector:@selector(youtubePlayerPauser)]) {
//        PodcastViewController *vc1 = [self.viewControllers objectAtIndex:1];
//        
//        if ([vc1 respondsToSelector:@selector(audioPlayerPauser)]) {
//            [vc1.audioPlayerPauser pause];
//            vc1.audioPlayerPauser = nil;
//        }
//        
//        if ([vc1 respondsToSelector:@selector(youtubePlayerPauser)]) {
//            [vc1.youtubePlayerPauser pauseVideo];
//            [vc1.youtubePlayerPauser stopVideo];
//            vc1.youtubePlayerPauser = nil;
//        }
//        
//    }
    
    while ([[contentView subviews] count] > 0) {
        [[[contentView subviews] lastObject] removeFromSuperview];
    }

    [contentView layoutIfNeeded];
    
    CGFloat width = self.containerViewForTable.frame.size.width;// [[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_width"];
    CGFloat height = self.containerViewForTable.frame.size.height;//[[NSUserDefaults standardUserDefaults] floatForKey:@"horizontal_height"];
    
    
    vc.view.frame = CGRectMake(0.0f, 0.0f, width, height);
    
    
//    NSLog(@"### %f / %f - (%@)",width,height,NSStringFromCGSize(vc.view.frame.size));
    
    [contentView addSubview:vc.view];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];
    
    [contentView setNeedsLayout];
    
    if (self.selectedIndex == 6 /*settings index*/) {
        
    }
    else {
        
        vc.loadingProgressView = self.progressView;
        
        if (self.fromViewLoad) {
        
            //[vc reloadTables];
        }
    }
    
    [contentView layoutSubviews];
    
}

- (void) showNetworkActivityIndicator:(NSNotification*)notification {
    
    BOOL shown = [((NSNumber*)notification.object) boolValue];
    
    self.networkActivityIsShown = shown;
    NETWORK_INDICATOR(shown)
    [self customNetworkActivityIndicator];

}

- (void) customNetworkActivityIndicator {
    
    if(CGRectEqualToRect(self.viewForProgressLoading.frame, CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, 0.0f, 2.0f))) {
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
        
        // side to side animation
        
//        NETWORK_INDICATOR(YES)
//        [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.viewForProgressLoading.frame = CGRectMake((self.view.frame.size.width/2) - 100.0f, self.viewForProgressLoading.frame.origin.y, 200.0f, 2.0f);
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                self.viewForProgressLoading.frame = CGRectMake(self.view.frame.size.width - 10.0f, self.viewForProgressLoading.frame.origin.y, 10.0f, 2.0f);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
//                    self.viewForProgressLoading.frame = CGRectMake((self.view.frame.size.width/2) - 100.0f, self.viewForProgressLoading.frame.origin.y, 200.0f, 2.0f);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
//                        self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, 10.0f, 2.0f);
//                    } completion:^(BOOL finished) {
//                        self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, 0.0f, 2.0f);
//                        NETWORK_INDICATOR(NO)
//                        //[self showNetworkActivityIndicator:[NSNotification notificationWithName:@"obs_progress" object:@YES]];
//                        
//                    }];
//                }];
//            }];
//        }];
//        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //progressive? animation
            
            CGFloat thirdWidth = (self.view.frame.size.width/3);
            
            
            double val = ((double)arc4random() / 0x100000000) + 0.1;
            
            NETWORK_INDICATOR(YES)
            [UIView animateWithDuration:val delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, thirdWidth * 1, 2.0f);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:val delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, thirdWidth * 2, 2.0f);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:val delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, thirdWidth * 3, 2.0f);
                    } completion:^(BOOL finished) {
                        self.viewForProgressLoading.frame = CGRectMake(0.0f, self.viewForProgressLoading.frame.origin.y, 0.0f, 2.0f);
                        NETWORK_INDICATOR(NO)
                    }];
                }];
            }];

        });
        
    }
    
}

- (PTPusher*) pusherClient {
    if (!_pusherClient) {
        _pusherClient = [PTPusher pusherWithKey:@"6b3550ae7aa57f259d34" delegate:self encrypted:YES cluster:@"ap1"];
        [_pusherClient connect];
        _pusherClient.reconnectDelay = 5;
    }
    
    return _pusherClient;
}

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection {
    
    NSLog(@"pusher connected:%@",[connection isConnected]?@"YES":@"NO");
    
}

- (BOOL)pusher:(PTPusher *)pusher connectionWillConnect:(PTPusherConnection *)connection {
    return YES;
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection failedWithError:(NSError *)error {
    
    NSLog(@"pusher failed error:%@",[error description]);
}


- (void)pusher:(PTPusher *)pusher didReceiveErrorEvent:(PTPusherErrorEvent *)errorEvent {
    
    NSLog(@"pusher failed error:%@",[errorEvent name]);
}


- (BOOL)pusher:(PTPusher *)pusher connectionWillAutomaticallyReconnect:(PTPusherConnection *)connection afterDelay:(NSTimeInterval)delay {
    return YES;
}

- (void)pusher:(PTPusher *)pusher connection:(PTPusherConnection *)connection didDisconnectWithError:(NSError *)error willAttemptReconnect:(BOOL)willAttemptReconnect {
    NSLog(@"pusher error:%@",[error description]);
}

- (void)pusher:(PTPusher *)pusher didSubscribeToChannel:(PTPusherChannel *)channel {
    NSLog(@"pusher channel:%@",[channel name]);
}

- (void)pusherConnection:(PTPusherConnection *)connection didFailWithError:(NSError *)error wasConnected:(BOOL)wasConnected {
    NSLog(@"pusher error:%@",[error description]);
    
}

- (void)pusher:(PTPusher *)pusher didFailToSubscribeToChannel:(PTPusherChannel *)channel withError:(NSError *)error {
    
    NSLog(@"pusher error:%@",[error description]);
}

- (void) updateNotificationCounter {
    self.labelNotificationBadge.text = [NSString stringWithFormat:@"%li",(long)self.newsFromPusher.count];
}


- (void) subscribeEvent:(NSString*)eventName{
    PTPusherChannel *channel = [self.pusherClient subscribeToChannelNamed:@"news"];
    PTPusherEventBinding *eventBind = [channel bindToEventNamed:eventName handleWithBlock:^(PTPusherEvent *channelEvent) {
        // channelEvent.data is a NSDictionary of the JSON object received
        
        /*
         data:{
         date = "April 14, 2017";
         datestamp =     {
         date = "2017-04-14 21:08:03.000000";
         timezone = "Asia/Manila";
         "timezone_type" = 3;
         };
         id = 45;
         module = news;
         title = "test push 11";
         }
         */
        
        NSLog(@"##[%@]data:%@",eventName,channelEvent.data);
        
        //        UILocalNotification *notification = [[UILocalNotification alloc] init];
        //        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        //        notification.alertBody = [NSString stringWithFormat:@"NEWS: %@",channelEvent.data[@"title"]];
        //        notification.timeZone = [NSTimeZone defaultTimeZone];
        //        notification.soundName = UILocalNotificationDefaultSoundName;
        //        notification.applicationIconBadgeNumber = [channelEvent.data[@"id"] integerValue];
        //
        //        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        if (!self.newsFromPusher) {
            self.newsFromPusher = [NSMutableArray array];
        }
        
        NSDictionary *dictionary = @{@"id":channelEvent.data[@"id"],@"date_posted":channelEvent.data[@"date"],@"title":channelEvent.data[@"title"],@"read":@NO};
        
        [self.newsFromPusher addObject:dictionary];
        
        if (self.selectedIndex == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_news_from_pusher" object:self.newsFromPusher];
        }
        
        [self updateNotificationCounter];
    }];
    
    if (!self.eventBindingArray) {
        self.eventBindingArray = [NSMutableArray array];
    }
    
    BOOL alreadyAdded = NO;
    for (PTPusherEventBinding *event in self.eventBindingArray) {
        if ([event.eventName isEqualToString:eventName]) {
            alreadyAdded = YES;
            break;
        }
    }
    
    if (!alreadyAdded) {
        [self.eventBindingArray addObject:eventBind];
    }
    
}


- (void) unSubscribeEvent:(NSString*)eventName{
    PTPusherChannel *channel = [self.pusherClient subscribeToChannelNamed:@"news"];
    
    for (PTPusherEventBinding *event in self.eventBindingArray) {
        if ([event.eventName isEqualToString:eventName]) {
            [channel removeBinding:event];
            break;
        }
    }
    
}

@end
