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
@property (assign, nonatomic) BOOL showRegisterCell;
@end
