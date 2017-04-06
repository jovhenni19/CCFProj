//
//  PodDetailAudioTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

@protocol AudioCellDelegate <NSObject>

- (void) audioIsPlaying;

@end

@interface PodDetailAudioTableViewCell : UITableViewCell
@property (strong ,nonatomic) NSString *urlForAudio;
@property (strong, nonatomic) YMCAudioPlayer *audioPlayer;
@property (strong, nonatomic) id<AudioCellDelegate> delegate;
@property (strong, nonatomic) AVPlayer *audioStreamerPlayer;

- (void)initAudioPlayer;
@end
