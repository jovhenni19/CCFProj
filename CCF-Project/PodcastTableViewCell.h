//
//  PodcastTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 01/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PodcastTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *podcastImage;
@property (weak, nonatomic) IBOutlet UILabel *podcastTitle;
@property (weak, nonatomic) IBOutlet UILabel *podcastDescription;
@property (weak, nonatomic) IBOutlet UIButton *podcastSpeaker;
@property (weak, nonatomic) IBOutlet UIButton *podcastDate;

@end
