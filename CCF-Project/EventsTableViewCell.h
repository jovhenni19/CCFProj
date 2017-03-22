//
//  EventsTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 15/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *eventsImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventsTitle;
@property (weak, nonatomic) IBOutlet UIButton *eventsTime;
@property (weak, nonatomic) IBOutlet UIButton *eventsDate;
@property (weak, nonatomic) IBOutlet UIButton *eventsVenue;
@property (weak, nonatomic) IBOutlet UIView *viewControls;

@end
