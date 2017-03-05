//
//  PodDetailVideoTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YouTubeiOSPlayerHelper.h"

@interface PodDetailVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayerView;
@property (strong, nonatomic) NSString *youtubeID;
@end
