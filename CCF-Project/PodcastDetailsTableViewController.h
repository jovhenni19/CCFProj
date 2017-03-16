//
//  PodcastDetailsTableViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PodcastDetailsTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *podcastTitle;
@property (strong, nonatomic) NSString *podcastSpeaker;
@property (strong, nonatomic) NSString *otherText;
@property (strong, nonatomic) NSString *podcastDescription;
@property (strong, nonatomic) NSString *urlForAudio;
@property (strong, nonatomic) NSString *youtubeID;

@end
