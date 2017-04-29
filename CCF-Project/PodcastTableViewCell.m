//
//  PodcastTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 01/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastTableViewCell.h"

@implementation PodcastTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.podcastImage.contentMode = UIViewContentModeScaleAspectFill;
    self.podcastImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
