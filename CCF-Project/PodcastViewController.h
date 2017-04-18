//
//  PodcastViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 01/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PodcastDetailsTableViewController.h"

@interface PodcastViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, PodcastsDetailDelegate>

@property (strong, nonatomic) AVPlayer *audioPlayerPauser;
@property (strong, nonatomic) YMCAudioPlayer *audioFilePlayerPauser;

@property (strong, nonatomic) YTPlayerView *youtubePlayerPauser;

@end
