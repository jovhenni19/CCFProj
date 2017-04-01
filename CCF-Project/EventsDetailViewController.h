//
//  EventsDetailViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface EventsDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttondate;
@property (weak, nonatomic) IBOutlet UIButton *buttonTime;
    @property (assign, nonatomic) BOOL showRegisterCell;
    @property (assign, nonatomic) BOOL showVenueDateTime;
    @property (weak, nonatomic) IBOutlet UIView *viewForControls;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *locationName;
@property (assign, nonatomic) CGFloat locationLatitude;
@property (assign, nonatomic) CGFloat locationLongitude;
@property (strong, nonatomic) NSString *dateText;
@property (strong, nonatomic) NSString *timeText;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *detailDescription;
@property (strong, nonatomic) NSString *personName;
@property (strong, nonatomic) NSString *personMobile;
@property (strong, nonatomic) NSString *personEmail;
@property (strong, nonatomic) NSString *registerLink;

@end
