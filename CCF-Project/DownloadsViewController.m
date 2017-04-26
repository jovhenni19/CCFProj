//
//  DownloadsViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 07/04/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "DownloadsViewController.h"
#import "PodcastTableViewCell.h"

@interface DownloadsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *podcastList;
@property (assign, nonatomic) NSInteger shownPerPage;
@end

@implementation DownloadsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.shownPerPage = 0;
    
    
    [self reloadTables];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTables {
    [super reloadTables];
    
    if (self.podcastList) {
        [self.podcastList removeAllObjects];
        
        self.podcastList = nil;
        
    }
    
    NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OfflineData"];
    
    NSError *error = nil;
    
    NSManagedObject *offlineData = [[context executeFetchRequest:request error:&error] lastObject];
    
    NSArray *newslist = [NSKeyedUnarchiver unarchiveObjectWithData:[offlineData valueForKey:@"podcasts_list"]];
    
    [self.podcastList removeAllObjects];
    
    
    self.podcastList = nil;
    
    self.podcastList = [NSMutableArray array];
    
    for (PodcastsObject *podcastsItem in newslist) {
        
        NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        
        NSString* foofile = [documentsPath stringByAppendingPathComponent:podcastsItem.audioURL];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        if ([podcastsItem.audioURL length] && fileExists) {
            [self.podcastList addObject:podcastsItem];
        }
        
        
    }
    
    
    [self.mainTableView reloadData];
    
    
    //    [self showLoadingAnimation:self.view];
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"count:%i",self.podcastList.count);
    return self.podcastList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat buttonHeight = 0.0f;
    
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    // add controls
    
    CGFloat buttonWidth = (tableView.bounds.size.width - 150.0f)/2; //divide per control
    
    CustomButton *buttonSpeaker = [[CustomButton alloc] initWithText:[item.category_name uppercaseString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[@"ccf center" uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    buttonHeight = 30.0f;
    for (CustomButton *button in @[buttonSpeaker,buttonVenue]) {
        if (button.frame.size.height > buttonHeight) {
            buttonHeight = button.frame.size.height;
        }
    }
    
    
    return 110.0f + buttonHeight;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    NSString *identifier = @"podcastCellImage";//([item.image_url length])?@"podcastCellImage":@"podcastCell";
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@",item.title];
    cell.podcastDescription.text = item.description_detail;
    
    //    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",item.created_date] forState:UIControlStateNormal];
    //    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
    //    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
    //    cell.podcastLocation.latitude = [NSNumber numberWithDouble:14.589221];
    //    cell.podcastLocation.longitude = [NSNumber numberWithDouble:121.078906];
    //    cell.podcastLocation.locationName = @"CCF CENTER";
    //    [cell.podcastLocation addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
            cell.podcastImage.alpha = 0.8f;
        }
    }
    
    [cell.podcastTitle sizeToFit];
    
    
    
    while ([[cell.viewForControls subviews] count] > 0) {
        [[[cell.viewForControls subviews] lastObject] removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(PodcastTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    // add controls
    
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
    
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMapButton:)];
    //    tap.numberOfTapsRequired = 1;
    //    [buttonVenue.button addGestureRecognizer:tap];
    
    
    buttonSpeaker.translatesAutoresizingMaskIntoConstraints = NO;
    buttonVenue.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *marginLayout = cell.viewForControls.layoutMarginsGuide;
    
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];
    
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:-15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonSpeaker attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PodcastsObject *item = [self.podcastList objectAtIndex:[indexPath row]];
    
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    details.delegate = self;
    details.podcastTitle = [NSString stringWithFormat:@"%@",item.title];
    details.podcastDescription = item.description_detail;
    details.otherText = [item.category_name uppercaseString];
    details.podcastSpeaker = @"Speaker 1";
    
    details.imageURL = item.image_url;
    details.youtubeID = @"";//[item.youtubeURL length]?[item.youtubeURL substringWithRange:NSMakeRange(32, 11)]:@"";
    
    NSString *filePath = @"";
    if ([item.audioURL length]) {
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES) objectAtIndex:0]
                    stringByAppendingPathComponent:item.audioURL];
    }
    
    
    
    details.urlForAudio = @"";//[filePath length]?filePath:@"";
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
