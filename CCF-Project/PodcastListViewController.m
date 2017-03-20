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
    if (self.categoryImageData && [self.categoryImageData isKindOfClass:[NSData class]]) {
        [self.headerImage setImage:[UIImage imageWithData:self.categoryImageData]];
    }
    else if([self.categoryImageURL length]){
        [self getImageFromURL:self.categoryImageURL completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
            if(!error) {
                UIImage *image = (UIImage*)responseObject;
                
                [self.headerImage setImage:[UIImage imageWithData:UIImageJPEGRepresentation(image, 100.0f)]];
            }
        } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
            
        }];
    }
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
    
    PodcastsItem *item = [self.podcastList objectAtIndex:[indexPath row]];
        
    NSString *identifier = ([item.image length])?@"podcastCellImage":@"podcastCell";
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@",item.title];
    cell.podcastDescription.text = item.description_detail;
    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",item.created_date] forState:UIControlStateNormal];
    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
    cell.podcastLocation.latitude = [NSNumber numberWithDouble:14.589221];
    cell.podcastLocation.longitude = [NSNumber numberWithDouble:121.078906];
    cell.podcastLocation.locationName = @"CCF CENTER";
    
    [cell.podcastLocation addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.image_data) {
        cell.podcastImage.image = [UIImage imageWithData:item.image_data];
    }
    else {
        if ([item.image length]) {
            [self getImageFromURL:item.image onIndex:[indexPath row]];
        }
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PodcastsItem *item  = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    
    details.podcastTitle = [NSString stringWithFormat:@"%@",item.title];
    details.podcastDescription = item.description_detail;
    details.otherText = [item.category_name capitalizedString];
    details.podcastSpeaker = @"Speaker 1";
    
    details.imageURL = item.image;
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


- (void) getImageFromURL:(NSString*)urlPath onIndex:(NSInteger)index {
    [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            UIImage *image = (UIImage*)responseObject;
            
            
            NSManagedObjectContext *context = MANAGE_CONTEXT;
            
            NSFetchRequest *request = [PodcastsItem fetchRequest];
            [request setReturnsObjectsAsFaults:NO];
            NSError *error = nil;
            
            NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
            
            id podcastItem = nil;
            
            for (PodcastsItem *item in result) {
                if ([item.id_num integerValue] == [((PodcastsItem*)[self.podcastList objectAtIndex:index]).id_num integerValue]) {
                    podcastItem = item;
                    break;
                }
            }
            
            ((PodcastsItem*)podcastItem).image_data = UIImageJPEGRepresentation(image, 100.0f);
            
            NSError *saveError = nil;
            
            if([context save:&saveError]) {
                
                PodcastTableViewCell *cell = (PodcastTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                
                cell.podcastImage.image = image;
                
                
            }
        }
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        
    }];
}


@end
