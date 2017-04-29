//
//  SattelitesTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 28/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SattelitesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelLocationName;
@property (weak, nonatomic) IBOutlet UIButton *labelAddress;
@property (weak, nonatomic) IBOutlet UIButton *labelEmail;
@property (weak, nonatomic) IBOutlet UIButton *labelContacts;
@property (weak, nonatomic) IBOutlet UIButton *labelWebsite;

@end
