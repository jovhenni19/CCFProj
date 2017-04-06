//
//  DownloadsViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 07/04/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "BaseViewController.h"
#import "PodcastDetailsTableViewController.h"

@interface DownloadsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, PodcastsDetailDelegate>

@property (strong, nonatomic) AVPlayer *audioPlayerPauser;

@property (strong, nonatomic) YTPlayerView *youtubePlayerPauser;

@end


