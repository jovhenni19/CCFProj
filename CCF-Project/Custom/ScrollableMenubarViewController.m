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

@interface ScrollableMenubarViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotificationBadge;
@property (weak, nonatomic) IBOutlet UIImageView *leftarrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightarrow;

@property (assign, nonatomic) BOOL fromViewLoad;
@property (assign, nonatomic) BOOL settingView;

@end

@implementation ScrollableMenubarViewController
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
    PodcastViewController *downloadedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"downloaded"];
    SettingsTableViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    self.viewControllers = [[NSArray alloc] initWithObjects:newsViewController, podcastViewController, eventsViewController,sViewController,streamViewController,downloadedViewController,settingsViewController, nil];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.menuBarView.bounds.size.width, 34.0f)];
    [self.scrollView setZoomScale:0.0f];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBounces:NO];
    [self.scrollView setDelegate:self];
    [self.scrollView setContentSize:self.view.bounds.size];
//    [self.scrollView setPagingEnabled:YES];
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.menuBarView addSubview:self.scrollView];
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 25.0f, 80.0f, 1.0f)];
    self.indicatorView.backgroundColor = (!self.foreColor)?[UIColor whiteColor]:self.foreColor;
    self.indicatorView.hidden = NO;
    [self.scrollView addSubview:self.indicatorView];
    
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
        [self.scrollView addSubview:button];
        
        [self.menuButtonList addObject:button];
        
        if (x + computedWidth > self.scrollView.contentSize.width) {
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width + computedWidth, 0.0f)];
            
            self.rightarrow.hidden = NO;
        }
        
        x += computedWidth;
//        if (index == 0) {
//            [self changeSelectedViewController:button];
//        }
    }
    
    self.fromViewLoad = YES;
    self.settingView = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.fromViewLoad) {
        self.fromViewLoad = NO;
        [self setCurrentViewController:0];
        
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeSelectedViewController:(UIButton*)sender {
    [self setCurrentViewController:sender.tag];
}

- (void) setCurrentViewController:(NSInteger)index {
    self.settingView = YES;
    self.selectedIndex = index;
    self.selectedViewController = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    UIButton *button = [self.menuButtonList objectAtIndex:self.selectedIndex];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.indicatorView.frame = CGRectMake(button.frame.origin.x + 10.0f, 32.0f, button.frame.size.width - 20.0f, 2.0f);
        
    } completion:^(BOOL finished) {
        
        [self.scrollView scrollRectToVisible:button.bounds animated:YES];
        
        while ([[self.containerView subviews] count] > 0) {
            [[[self.containerView subviews] lastObject] removeFromSuperview];
        }
        
        
        self.selectedViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:self.selectedViewController.view];
        [self addChildViewController:self.selectedViewController];
        [self.selectedViewController didMoveToParentViewController:self];
        
        [self.pagingScrollview addSubview:self.containerView];
        
        CGSize viewSize = self.containerView.bounds.size;
        
        UIView *prevView = nil;
        
        UIView *nextView = nil;
        
        [self.pagingScrollview setContentSize:viewSize];
        
        if (self.selectedIndex > 0) {
            prevView = [[UIView alloc] initWithFrame:CGRectMake(viewSize.width*-1, 0.0f, viewSize.width, viewSize.height)];
            prevView.backgroundColor = [UIColor greenColor];
            
            [self.pagingScrollview addSubview:prevView];
            
            
            UIViewController *prevVC = [self.viewControllers objectAtIndex:self.selectedIndex-1];
            prevVC.view.frame = prevView.bounds;
            [prevView addSubview:prevVC.view];
            
            [self.pagingScrollview setContentSize:CGSizeMake(self.pagingScrollview.contentSize.width + viewSize.width, 0.0f)];
            
//            CGRect frame = prevView.frame;
//            frame.origin = CGPointMake(0.0f, 0.0f);
//            prevView.frame = frame;
//            
//            frame = self.containerView.frame;
//            frame.origin = CGPointMake(viewSize.width, 0.0f);
//            self.containerView.frame = frame;
//            
//            [self.pagingScrollview setContentOffset:CGPointMake(viewSize.width, 0.0f)];
            
        }
        
        
        if (self.selectedIndex < self.viewControllers.count-1) {
            nextView = [[UIView alloc] initWithFrame:CGRectMake(self.containerView.frame.origin.x + self.containerView.frame.size.width, 0.0f, viewSize.width, viewSize.height)];
            nextView.backgroundColor = [UIColor yellowColor];
            
            [self.pagingScrollview addSubview:nextView];
            
            UIViewController *nextVC = [self.viewControllers objectAtIndex:self.selectedIndex+1];
            nextVC.view.frame = nextView.bounds;
            [nextView addSubview:nextVC.view];
            
            [self.pagingScrollview setContentSize:CGSizeMake(self.pagingScrollview.contentSize.width + viewSize.width, 0.0f)];
        }
        
        self.settingView = NO;
    }];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)showNotifications:(id)sender {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.scrollView]) {
        self.leftarrow.hidden = NO;
        self.rightarrow.hidden = NO;
        if (scrollView.contentOffset.x <= 0) {
            self.leftarrow.hidden = YES;
        }
        else if(scrollView.contentOffset.x + scrollView.bounds.size.width >= scrollView.contentSize.width - 20.0f) {
            self.rightarrow.hidden = YES;
        }
    }
    else if ([scrollView isEqual:self.pagingScrollview] && !self.settingView) {
        
        if (scrollView.contentOffset.x < ((scrollView.frame.size.width/3)-10)*-1) {
            if (self.selectedIndex > 0) {
                [self setCurrentViewController:self.selectedIndex-1];
            }
        }
        else if (scrollView.contentOffset.x > ((scrollView.frame.size.width/3)-10)) {
            if (self.selectedIndex < self.viewControllers.count-1) {
                [self setCurrentViewController:self.selectedIndex+1];
            }
        }
        
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
