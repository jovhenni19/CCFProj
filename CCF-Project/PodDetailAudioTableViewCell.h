//
//  PodDetailAudioTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"

@interface PodDetailAudioTableViewCell : UITableViewCell
@property (strong ,nonatomic) NSString *urlForAudio;
@property (strong, nonatomic) YMCAudioPlayer *audioPlayer;
@end
