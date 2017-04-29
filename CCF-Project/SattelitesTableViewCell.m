//
//  SattelitesTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 28/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SattelitesTableViewCell.h"

@implementation SattelitesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelAddress.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelAddress.titleLabel.numberOfLines = 0;
    
    self.labelEmail.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelEmail.titleLabel.numberOfLines = 0;
    
    self.labelWebsite.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelWebsite.titleLabel.numberOfLines = 0;
    
    self.labelContacts.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelContacts.titleLabel.numberOfLines = 0;
    
    self.labelLocationName.lineBreakMode = NSLineBreakByWordWrapping;
    self.labelLocationName.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
