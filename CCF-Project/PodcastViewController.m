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

@interface PodcastViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *podcastList;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *categoriesDetails;
@property (strong, nonatomic) NSMutableDictionary *categorizedPodcast;

@property (assign, nonatomic) BOOL isCategoriesShown;
@property (assign, nonatomic) NSInteger sectionExpanded;

@end

@implementation PodcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.isCategoriesShown = NO;
    self.sectionExpanded = -1;
    
    self.podcastList = [NSMutableArray array];
    self.categories = [NSMutableArray array];
    
    NSString *title = @"Podcast Title";
    NSString *description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    NSString *category = @"fridays";
    
    UIImage *image = [UIImage imageNamed:@"fridays"];
    NSDictionary *catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
    
    [self.categories addObject:catDict];
    [self.podcastList addObject:dictionary];
    [self.podcastList addObject:dictionary];
    
    [self.podcastList addObject:dictionary];
    
    
    title = @"Podcast Title";
    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    category = @"life";
    
    image = [UIImage imageNamed:@"life"];
    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
    
    [self.categories addObject:catDict];
    [self.podcastList addObject:dictionary];
    [self.podcastList addObject:dictionary];
    
    [self.podcastList addObject:dictionary];
    
    [self.podcastList addObject:dictionary];
    
    [self.podcastList addObject:dictionary];
    [self.podcastList addObject:dictionary];


    
    
    title = @"Podcast Title";
    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    category = @"everyday conversation";
    
    image = [UIImage imageNamed:@"everydays"];
    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
    
    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
    
    [self.categories addObject:catDict];
    [self.podcastList addObject:dictionary];
    
    [self.podcastList addObject:dictionary];
    
    self.categorizedPodcast = [NSMutableDictionary dictionary];
    for (NSDictionary *dictionary in self.podcastList) {
        NSString *key = [dictionary objectForKey:@"kCategory"];
        if (![[self.categorizedPodcast allKeys] containsObject:key]) {
            NSMutableArray *array = [NSMutableArray array];
            [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
        }
        
        NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
        [subArray addObject:dictionary];
        
        [self.categorizedPodcast setObject:subArray forKey:key];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        if (section != self.sectionExpanded) {
            return 0;
        }
        else {
            
            NSString *key = [self.categories[section] objectForKey:@"kTitle"];
            return [[self.categorizedPodcast objectForKey:key] count];
        }
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
        UIImage *image = [self.categories[section] objectForKey:@"kImage"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 160.0f)];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        button.tag = section;
        [button addTarget:self action:@selector(setSectionExpandedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    cell.podcastTitle = [dictionary objectForKey:@"kTitle"];
    cell.podcastDescription = [dictionary objectForKey:@"kDescription"];
    [cell.podcastSpeaker setTitle:@"Speaker 1" forState:UIControlStateNormal];
    [cell.podcastDate setTitle:@"03/04/2017" forState:UIControlStateNormal];
    
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
    
    details.podcastTitle = [dictionary objectForKey:@"kTitle"];
    details.podcastDescription = [dictionary objectForKey:@"kDescription"];
    details.podcastSpeaker = @"Speaker 1";
    details.image = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kImage"];
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
    if (sender.tag == self.sectionExpanded) {
        self.sectionExpanded = -1;
    }
    else {
        self.sectionExpanded = sender.tag;
    }
    
    [self.mainTableView reloadData];
    
    [self.mainTableView layoutIfNeeded];
    if (self.sectionExpanded > -1) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sectionExpanded];
            
            [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });}
    }


@end
