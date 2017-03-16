//
//  PodcastListViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 09/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "BaseViewController.h"

@interface PodcastListViewController : BaseViewController

@property (strong, nonatomic) NSString *podcastCategoryTitle;
@property (strong, nonatomic) NSArray *podcastList;
@property (strong, nonatomic) NSString *categoryImageURL;
@end
