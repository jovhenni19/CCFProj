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

@property (strong, nonatomic) UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *labelNotificationBadge;
@property (weak, nonatomic) IBOutlet UIImageView *leftarrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightarrow;
@property (weak, nonatomic) IBOutlet UIView *containerViewForTable;
@property (weak, nonatomic) IBOutlet UITableView *horizontalTableview;

@property (assign, nonatomic) BOOL fromViewLoad;
@property (assign, nonatomic) BOOL settingView;

@property (assign, nonatomic) CGFloat preOffsetX;

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
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    if (self.fromViewLoad) {
//        self.fromViewLoad = NO;
//        [self setCurrentViewController:0];
//        
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.horizontalTableview.frame;
    frame.size.width = self.containerViewForTable.frame.size.height;
    frame.size.height = self.containerViewForTable.frame.size.width;
    self.horizontalTableview.frame = frame;
    
    self.horizontalTableview.transform=CGAffineTransformMakeRotation(-M_PI_2);
    
    
    frame = self.horizontalTableview.frame;
    frame.origin = CGPointZero;
    self.horizontalTableview.frame = frame;
    
//    if(self.fromViewLoad){
//        self.fromViewLoad = NO;
//        self.selectedIndex = 0;
//    }
    
    
//    self.horizontalTableview.layer.borderWidth = 3.0f;
//    self.horizontalTableview.layer.borderColor = [UIColor redColor].CGColor;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) changeSelectedViewController:(UIButton*)sender {
//    [self setCurrentViewController:sender.tag];
    
    [self.horizontalTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.indicatorView.frame = CGRectMake(sender.frame.origin.x + 10.0f, 32.0f, sender.frame.size.width - 20.0f, 2.0f);
    
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.scrollViewBar]) {
        self.leftarrow.hidden = NO;
        self.rightarrow.hidden = NO;
        if (scrollView.contentOffset.x <= 0) {
            self.leftarrow.hidden = YES;
        }
        else if(scrollView.contentOffset.x + scrollView.bounds.size.width >= scrollView.contentSize.width) {
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
        CGFloat pageWidth = self.containerViewForTable.bounds.size.width;
        NSInteger index = (long)floor((self.horizontalTableview.contentOffset.y - pageWidth / 2) / pageWidth) + 1;
        self.selectedIndex = index;
        UIButton *button = [self.menuButtonList objectAtIndex:self.selectedIndex];
        self.indicatorView.frame = CGRectMake(button.frame.origin.x + 10.0f, 32.0f, button.frame.size.width - 20.0f, 2.0f);
        [self.scrollViewBar scrollRectToVisible:self.indicatorView.bounds animated:YES];
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

#pragma mark Table Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewControllers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.containerViewForTable.bounds.size.width;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForViewController"];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellForViewController"];
    }
    
    cell.contentView.transform=CGAffineTransformMakeRotation(M_PI_2);
    cell.contentView.clipsToBounds = YES;
    
//    BaseViewController *vc = [self.viewControllers objectAtIndex:[indexPath row]];
//    [vc reloadTables];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self loadViewControllerWithContentView:cell.contentView index:[indexPath row]];
}


- (void) loadViewControllerWithContentView:(UIView*)contentView index:(NSInteger)index {
    
    self.selectedIndex = index;
    BaseViewController *vc = [self.viewControllers objectAtIndex:self.selectedIndex];
    
    while ([[contentView subviews] count] > 0) {
        [[[contentView subviews] lastObject] removeFromSuperview];
    }

    
    vc.view.frame = self.containerViewForTable.bounds;
    
    [contentView addSubview:vc.view];
    [self addChildViewController:vc];
    [vc didMoveToParentViewController:self];

    contentView.tag = 1990 + index;
    
}



@end
