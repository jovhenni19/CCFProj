//
//  PodcastListViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 09/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "BaseViewController.h"
#import "PodcastDetailsTableViewController.h"

@interface PodcastListViewController : BaseViewController <PodcastsDetailDelegate>

@property (strong, nonatomic) AVPlayer *audioPlayerPauser;

@property (strong, nonatomic) YTPlayerView *youtubePlayerPauser;

@property (strong, nonatomic) NSString *podcastCategoryTitle;
@property (strong, nonatomic) NSArray *podcastList;
@property (strong, nonatomic) NSString *categoryImageURL;
@property (strong, nonatomic) NSData *categoryImageData;
@end
