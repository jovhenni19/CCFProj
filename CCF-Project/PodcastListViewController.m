//
//  PodcastListViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 09/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastListViewController.h"
#import "PodcastTableViewCell.h"
#import "PodcastDetailsTableViewController.h"

@interface PodcastListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;


@end

@implementation PodcastListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.headerImage setImage:self.categoryImage];
    self.categoryTitleLabel.text = self.podcastCategoryTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.podcastList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120.0f;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"podcastCell"];
    
    NSDictionary *dictionary = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@ %li",[dictionary objectForKey:@"kTitle"],(long)[indexPath row]];
    cell.podcastDescription.text = [dictionary objectForKey:@"kDescription"];
    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
    [cell.podcastDate setTitle:@"  03/04/2017" forState:UIControlStateNormal];
    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
    [cell.podcastImage setImage:[UIImage imageNamed:[dictionary objectForKey:@"kCategory"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dictionary = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    
    details.podcastTitle = [NSString stringWithFormat:@"%@ %li",[dictionary objectForKey:@"kTitle"],(long)[indexPath row]];
    details.podcastDescription = [dictionary objectForKey:@"kDescription"];
    NSMutableString *category = [[dictionary objectForKey:@"kCategory"] mutableCopy];
    [category replaceOccurrencesOfString:@"-" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, category.length)];
    details.otherText = [category capitalizedString];
    details.podcastSpeaker = @"Speaker 1";
    details.image = self.categoryImage;//[[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kImage"];
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




@end
