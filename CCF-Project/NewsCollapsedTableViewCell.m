//
//  NewsCollapsedTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 27/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "NewsCollapsedTableViewCell.h"

@implementation NewsCollapsedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _buttonDate.titleLabel.adjustsFontSizeToFitWidth = YES;
    _buttonLocation.titleLabel.adjustsFontSizeToFitWidth = YES;
    _buttonGroupName.titleLabel.adjustsFontSizeToFitWidth = YES;
    _buttonSpeaker.titleLabel.adjustsFontSizeToFitWidth = YES;
    _buttonDate.titleLabel.minimumScaleFactor = -5.0f;
    _buttonLocation.titleLabel.minimumScaleFactor = -5.0f;
    _buttonGroupName.titleLabel.minimumScaleFactor = -5.0f;
    _buttonSpeaker.titleLabel.minimumScaleFactor = -5.0f;
    
    _buttonDate.titleLabel.numberOfLines = 0;
    _buttonLocation.titleLabel.numberOfLines = 0;
    _buttonGroupName.titleLabel.numberOfLines = 0;
    _buttonSpeaker.titleLabel.numberOfLines = 0;
    _buttonDate.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonLocation.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonGroupName.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _buttonSpeaker.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)showLocation:(id)sender {
    
    [self.delegate buttonLocationPressed:self.indexPath];
    
}
- (IBAction)saveDate:(id)sender {
    
    [self.delegate buttonDatePressed:self.indexPath];
    
}

@end
