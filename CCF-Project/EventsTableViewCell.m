//
//  EventsTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 15/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsTableViewCell.h"

@implementation EventsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.eventsVenue.titleLabel.numberOfLines = 0;
    self.eventsVenue.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.eventsVenue.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.eventsVenue.titleLabel.minimumScaleFactor = -0.5f;
    
    self.eventsDate.titleLabel.numberOfLines = 0;
    self.eventsDate.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.eventsDate.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.eventsDate.titleLabel.minimumScaleFactor = -0.5f;
    
    self.eventsTime.titleLabel.numberOfLines = 0;
    self.eventsTime.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.eventsTime.titleLabel.adjustsFontSizeToFitWidth = YES;
//    self.eventsTime.titleLabel.minimumScaleFactor = -0.5f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
