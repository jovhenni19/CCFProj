//
//  PodcastViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 01/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastViewController.h"
#import "PodcastTableViewCell.h"
#import "PodcastDetailsTableViewController.h"
#import "PodcastListViewController.h"

@interface PodcastViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *podcastList;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *categoriesDetails;
@property (strong, nonatomic) NSMutableDictionary *categorizedPodcast;

@property (assign, nonatomic) BOOL isCategoriesShown;
@property (assign, nonatomic) NSInteger sectionExpanded;

@property (assign, nonatomic) NSInteger shownPerPage;

@end

@implementation PodcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.isCategoriesShown = NO;
    self.sectionExpanded = -1;
    
    
    self.shownPerPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendPodcastsList:) name:kOBS_PODCAST_NOTIFICATION object:nil];
    
    [self callGETAPI:kPODCAST_LINK withParameters:nil completionNotification:kOBS_PODCAST_NOTIFICATION];
    
    
    
//    self.podcastList = [NSMutableArray array];
//    self.categories = [NSMutableArray array];
//    
//    NSString *title = @"Podcast Title";
//    NSString *description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    NSString *category = @"all-access";
//    
//    UIImage *image = [UIImage imageNamed:@"all-access"];
//    NSDictionary *catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    
//    title = @"Podcast Title";
//    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    category = @"life";
//    
//    image = [UIImage imageNamed:@"life-unboxed"];
//    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//
//
//    
//    
//    title = @"Podcast Title";
//    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    category = @"everyday-conversation";
//    
//    image = [UIImage imageNamed:@"everyday-conversation"];
//    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    self.categorizedPodcast = [NSMutableDictionary dictionary];
//    for (NSDictionary *dictionary in self.podcastList) {
//        NSString *key = [dictionary objectForKey:@"kCategory"];
//        if (![[self.categorizedPodcast allKeys] containsObject:key]) {
//            NSMutableArray *array = [NSMutableArray array];
//            [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
//        }
//        
//        NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
//        [subArray addObject:dictionary];
//        
//        [self.categorizedPodcast setObject:subArray forKey:key];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)appendPodcastsList:(NSNotification*)notification {
//    NSLog(@"### result:%@",notification.object);
    
    if(!self.podcastList){
        self.podcastList = [NSMutableArray array];
    }
    
    if(!self.categories){
        self.categories = [NSMutableArray array];
    }
    
    if(!self.categorizedPodcast){
        self.categorizedPodcast = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    
    NSArray *data = result[@"data"];
    
    for (NSDictionary *item in data) {
        
        NSDictionary *podcasts = @{@"kTitle":item[@"title"],@"kImage":item[@"image"],@"kDescription":item[@"description"],@"kCategory":item[@"series"][0][@"name"],@"kCreatedTime":item[@"created_at"]};
        
        
        
        [self.podcastList addObject:podcasts];
    }
    
    for (NSDictionary *dictionary in self.podcastList) {
        NSString *key = [dictionary objectForKey:@"kCategory"];
        if (![[self.categorizedPodcast allKeys] containsObject:key]) {
            NSMutableArray *array = [NSMutableArray array];
            [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
            
            NSDictionary *category = @{@"kTitle":key,@"kImage":dictionary[@"kImage"]};
            [self.categories addObject:category];
        }
        
        NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
        [subArray addObject:dictionary];
        
        [self.categorizedPodcast setObject:subArray forKey:key];
    }


    [self.mainTableView reloadData];
    
}


- (IBAction)changeView:(id)sender {
    if ([self.segmentedControl selectedSegmentIndex] == 1) {
        self.isCategoriesShown = YES;
    }
    else {
        self.isCategoriesShown = NO;
    }
    
    [self.mainTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isCategoriesShown) {
        return _categories.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
//        if (section != self.sectionExpanded) {
//            return 0;
//        }
//        else {
        
            NSString *key = [self.categories[section] objectForKey:@"kTitle"];
        
            return [[self.categorizedPodcast objectForKey:key] count];
//        }
    }
    return self.podcastList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
        return 160.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCategoriesShown && [indexPath section] != self.sectionExpanded) {
        return 0.0f;
    }
    return 120.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
        NSString *title = [self.categories[section] objectForKey:@"kTitle"];
        
        NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAPI_LINK,[self.categories[section] objectForKey:@"kImage"]]];
        
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
//        UIImage *image = [self.categories[section] objectForKey:@"kImage"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 160.0f)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        button.tag = section;
        [button addTarget:self action:@selector(setSectionExpandedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
        
        return button;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"podcastCell"];
    
    NSDictionary *dictionary = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        dictionary = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        dictionary = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@ %li",[dictionary objectForKey:@"kTitle"],(long)[indexPath row]];
    cell.podcastDescription.text = [dictionary objectForKey:@"kDescription"];
    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",dictionary[@"kCreatedTime"]] forState:UIControlStateNormal];
    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
    
//    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAPI_LINK,[dictionary objectForKey:@"kImage"]]];
//    [cell.podcastImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]]];

    [self getImageFromURL:[dictionary objectForKey:@"kImage"] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [cell.podcastImage setImage: (UIImage*) responseObject];
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        
    }];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        dictionary = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        dictionary = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    
    details.podcastTitle = [NSString stringWithFormat:@"%@ %li",[dictionary objectForKey:@"kTitle"],(long)[indexPath row]];
    details.podcastDescription = [dictionary objectForKey:@"kDescription"];
    NSMutableString *category = [[dictionary objectForKey:@"kCategory"] mutableCopy];
    [category replaceOccurrencesOfString:@"-" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, category.length)];
    details.otherText = [category capitalizedString];
    details.podcastSpeaker = @"Speaker 1";
    
    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAPI_LINK,[dictionary objectForKey:@"kImage"]]];
    
    details.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
    details.youtubeID = @"Xd_6MSWz2J4";
    details.urlForAudio = @"audiofile";
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [details.view.layer addAnimation:transition forKey:nil];
    
    
    details.view.frame = self.view.bounds;
    [[self.view superview] addSubview:details.view];
    [[self parentViewController] addChildViewController:details];
    [details didMoveToParentViewController:[self parentViewController]];
    
    
}

- (void) setSectionExpandedWithButton:(UIButton*)sender {
//    if (sender.tag == self.sectionExpanded) {
//        self.sectionExpanded = -1;
//        NSRange range = NSMakeRange(0, 1);
//        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.mainTableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else {
//        self.sectionExpanded = sender.tag;
//        NSRange range = NSMakeRange(self.sectionExpanded, 1);
//        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.mainTableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//    
//    [self.mainTableView layoutIfNeeded];
//    if (self.sectionExpanded > -1) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sectionExpanded];
//            
//            [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        });}
//    }

    
    PodcastListViewController *podcastListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastList"];
    
    NSString *key = [self.categories[sender.tag] objectForKey:@"kTitle"];
    
    NSURL *urlImage = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kAPI_LINK,[self.categories[sender.tag] objectForKey:@"kImage"]]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlImage]];
    podcastListVC.categoryImage = image;
    podcastListVC.podcastList = [self.categorizedPodcast objectForKey:key];
    
    NSMutableString *category = [[self.categories[sender.tag] objectForKey:@"kTitle"] mutableCopy];
    [category replaceOccurrencesOfString:@"-" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, category.length)];
    podcastListVC.podcastCategoryTitle = [category capitalizedString];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [podcastListVC.view.layer addAnimation:transition forKey:nil];
    
    
    podcastListVC.view.frame = self.view.bounds;
    [[self.view superview] addSubview:podcastListVC.view];
    [[self parentViewController] addChildViewController:podcastListVC];
    [podcastListVC didMoveToParentViewController:[self parentViewController]];
    
    
}


@end
