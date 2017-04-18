//
//  PodDetailAudioDownloadedTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"

@protocol AudioDownloadedCellDelegate <NSObject>

- (void) audioFileIsPlaying;

@end

@interface PodDetailAudioDownloadedTableViewCell : UITableViewCell
@property (strong ,nonatomic) NSString *audioFilePath;
@property (strong, nonatomic) YMCAudioPlayer *audioPlayer;
@property (strong, nonatomic) id<AudioDownloadedCellDelegate> delegate;


- (void)initAudioPlayer;
@end
