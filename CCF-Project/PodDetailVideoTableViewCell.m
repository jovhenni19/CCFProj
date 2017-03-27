//
//  PodDetailVideoTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodDetailVideoTableViewCell.h"

@implementation PodDetailVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.youtubePlayerView.delegate = self;
    [self.youtubePlayerView loadWithVideoId:self.youtubeID];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)playerView:(YTPlayerView *)playerView didPlayTime:(float)playTime {
    [self.delegate youtubeIsPlaying];
}

@end
