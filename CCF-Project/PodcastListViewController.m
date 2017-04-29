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
        
        [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,self.categoryImageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.categoryImageData = UIImageJPEGRepresentation(image, 100.0f);
        }];
        
        
//        [self getImageFromURL:self.categoryImageURL completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
//            if(!error) {
//                UIImage *image = (UIImage*)responseObject;
//                
//                [self.headerImage setImage:[UIImage imageWithData:UIImageJPEGRepresentation(image, 100.0f)]];
//            }
//        } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
//            
//        }];
    }
    else {
        [self.headerImage setImage:[UIImage imageNamed:@"placeholder"]];
        
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
    
    CGFloat buttonHeight = 0.0f;
    
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
    
    // add controls
    
    CGFloat buttonWidth = (tableView.bounds.size.width - 150.0f)/2; //divide per control
    
    CustomButton *buttonSpeaker = [[CustomButton alloc] initWithText:[item.category_name uppercaseString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[@"ccf center" uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    buttonHeight = 22.0f;
    for (CustomButton *button in @[buttonSpeaker,buttonVenue]) {
        if (button.frame.size.height > buttonHeight) {
            buttonHeight = button.frame.size.height;
        }
    }
    
    
    return 100.0f + buttonHeight;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
        
    NSString *identifier = @"podcastCellImage";
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@",item.title];
    [cell.podcastTitle sizeToFit];
    cell.podcastDescription.text = item.description_detail;
//    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
//    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",item.created_date] forState:UIControlStateNormal];
//    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
//    cell.podcastLocation.latitude = [NSNumber numberWithDouble:14.589221];
//    cell.podcastLocation.longitude = [NSNumber numberWithDouble:121.078906];
//    cell.podcastLocation.locationName = @"CCF CENTER";
    
    [cell.podcastLocation addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.image_data) {
        cell.podcastImage.image = [UIImage imageWithData:item.image_data];
    }
    else {
        if ([item.image_url length]) {
//            [self getImageFromURL:item.image_url onIndex:[indexPath row]];
            [cell.podcastImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,item.image_url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                item.image_data = UIImageJPEGRepresentation(image, 100.0f);
            }];
        }
        else {
            
            cell.podcastImage.image = [UIImage imageNamed:@"placeholder"];
            cell.podcastImage.contentMode = UIViewContentModeScaleToFill;
        }
    }
    
    while ([[cell.viewForControls subviews] count] > 0) {
        [[[cell.viewForControls subviews] lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

    
- (void)tableView:(UITableView *)tableView willDisplayCell:(PodcastTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PodcastsObject *item  = [self.podcastList objectAtIndex:[indexPath row]];
    
    // add controls
    
    [cell.podcastTitle sizeToFit];
    [cell.podcastDescription sizeToFit];
    CGFloat buttonWidth = (cell.contentView.bounds.size.width - 150.0f)/2; //divide per control
    
    CustomButton *buttonSpeaker = [[CustomButton alloc] initWithText:[item.category_name uppercaseString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f) locked:YES];
    buttonSpeaker.labelText.textColor = [UIColor grayColor];
    buttonSpeaker.userInteractionEnabled = NO;
    [cell.viewForControls addSubview:buttonSpeaker];
    
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[@"ccf center" uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f) locked:YES];
    buttonVenue.labelText.textColor = TEAL_COLOR;
    buttonVenue.userInteractionEnabled = YES;
    buttonVenue.button.latitude = [NSNumber numberWithDouble:14.589221];
    buttonVenue.button.longitude = [NSNumber numberWithDouble:121.078906];
    buttonVenue.button.locationName = @"CCF CENTER";
    [buttonVenue.button addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewForControls addSubview:buttonVenue];
    
//    //layout
    buttonSpeaker.translatesAutoresizingMaskIntoConstraints = NO;
    buttonVenue.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *marginLayout = cell.viewForControls.layoutMarginsGuide;
    
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];
    
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:-15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonSpeaker attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:1.0f]];
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PodcastsObject *item  = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    details.delegate = self;
    details.podcastTitle = [NSString stringWithFormat:@"%@",item.title];
    details.podcastDescription = item.description_detail;
    details.otherText = [item.category_name uppercaseString];
    details.podcastSpeaker = @"Speaker 1";
    
    details.imageURL = item.image_url;
    details.youtubeID = [item.youtubeURL length]?[item.youtubeURL substringWithRange:NSMakeRange(32, 11)]:@"";
    details.urlForAudio = [item.audioURL length]?[NSString stringWithFormat:@"%@%@%@/audio/%@",kAPI_LINK,@"/podcasts/",item.id_num,item.audioURL]:@"";
    details.audioFilePath = item.audioFilePath;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [details.view.layer addAnimation:transition forKey:nil];
    
    
    details.view.frame = self.view.bounds;
    [self.view addSubview:details.view];
    [self addChildViewController:details];
    [details didMoveToParentViewController:self];
    
    
}


- (void) getImageFromURL:(NSString*)urlPath onIndex:(NSInteger)index {
    [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            UIImage *image = (UIImage*)responseObject;
            
            
            for (PodcastsObject *item in self.podcastList) {
                if ([item.id_num integerValue] == [((PodcastsObject*)[self.podcastList objectAtIndex:index]).id_num integerValue]) {
                    item.image_data = UIImageJPEGRepresentation(image, 100.0f);
                    break;
                }
            }
            
            PodcastTableViewCell *cell = (PodcastTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.podcastImage.image = image;
            
            //            NSManagedObjectContext *context = MANAGE_CONTEXT;
            //
            //            NSFetchRequest *request = [PodcastsItem fetchRequest];
            //            [request setReturnsObjectsAsFaults:NO];
            //            NSError *error = nil;
            //
            //            NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
            //
            //            id podcastItem = nil;
            //
            //            for (PodcastsItem *item in result) {
            //                if ([item.id_num integerValue] == [((PodcastsItem*)[self.podcastList objectAtIndex:index]).id_num integerValue]) {
            //                    podcastItem = item;
            //                    break;
            //                }
            //            }
            //
            //            ((PodcastsItem*)podcastItem).image_data = UIImageJPEGRepresentation(image, 100.0f);
            //
            //            NSError *saveError = nil;
            //
            //            if([context save:&saveError]) {
            //
            //                PodcastTableViewCell *cell = (PodcastTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            //                
            //                cell.podcastImage.image = image;
            //                
            //                
            //            }
        }
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        
    }];
}


- (void)activeAudioPlayer:(AVPlayer *)player {
    self.audioPlayerPauser = player;
}

- (void)activeYoutubePlayer:(YTPlayerView *)youtubePlayer {
    self.youtubePlayerPauser = youtubePlayer;
}

@end
