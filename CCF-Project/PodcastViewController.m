//
//  PodcastViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 01/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastViewController.h"
#import "PodcastTableViewCell.h"
#import "PodcastListViewController.h"

@interface PodcastViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *podcastList;
@property (strong, nonatomic) NSMutableArray *categories;
@property (strong, nonatomic) NSMutableArray *categoriesDetails;
@property (strong, nonatomic) NSMutableDictionary *categorizedPodcast;

@property (assign, nonatomic) BOOL isCategoriesShown;
@property (assign, nonatomic) NSInteger sectionExpanded;

@property (assign, nonatomic) NSInteger shownPerPage;


@end

@implementation PodcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.isCategoriesShown = NO;
    self.sectionExpanded = -1;
    
    
    self.shownPerPage = 0;
    
    
    [self reloadTables];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTables {
    [super reloadTables];
    
    if (self.podcastList) {
        [self.podcastList removeAllObjects];
        [self.categories removeAllObjects];
        
        self.podcastList = nil;
        self.categories = nil;
        self.categorizedPodcast = nil;
        
        
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        //get offline data
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OfflineData"];
        
        NSError *error = nil;
        
        NSManagedObject *offlineData = [[context executeFetchRequest:request error:&error] lastObject];
        
        NSArray *newslist = [NSKeyedUnarchiver unarchiveObjectWithData:[offlineData valueForKey:@"podcasts_list"]];
        
        [self.podcastList removeAllObjects];
        
        [self.categories removeAllObjects];
        
        self.podcastList = nil;
        self.categories = nil;
        self.categorizedPodcast = nil;
        if(!self.podcastList){
            self.podcastList = [NSMutableArray array];
        }
        
        if(!self.categories){
            self.categories = [NSMutableArray array];
        }
        
        if(!self.categorizedPodcast){
            self.categorizedPodcast = [NSMutableDictionary dictionary];
        }
        self.podcastList = [NSMutableArray arrayWithArray:newslist];
        
        for (PodcastsObject *podcastsItem in self.podcastList) {
            NSString *key = podcastsItem.category_name;
            if (![[self.categorizedPodcast allKeys] containsObject:key]) {
                NSMutableArray *array = [NSMutableArray array];
                [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
                
                NSDictionary *category = @{@"kTitle":[key uppercaseString],@"kImage":podcastsItem.image_url,@"kImageData":isNIL(podcastsItem.image_data)};
                [self.categories addObject:category];
            }
            
            NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
            [subArray addObject:podcastsItem];
            
            [self.categorizedPodcast setObject:subArray forKey:key];
        }
        
        
        [self.mainTableView reloadData];
    }
    else {
        
//        CGFloat value = 0.8f;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:[NSNumber numberWithFloat:value]];
        
//        NETWORK_INDICATOR(YES)
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendPodcastsList:) name:kOBS_PODCAST_NOTIFICATION object:nil];
        
        [self callGETAPI:kPODCAST_LINK withParameters:nil completionNotification:kOBS_PODCAST_NOTIFICATION];
        
        
    }
    
    
//    [self showLoadingAnimation:self.view];
}

- (void)appendPodcastsList:(NSNotification*)notification {
//    NSLog(@"### result:%@",notification.object);
    
    
    [self removeLoadingAnimation];
    
    
    if(!self.podcastList){
        self.podcastList = [NSMutableArray array];
    }
    
    if(!self.categories){
        self.categories = [NSMutableArray array];
    }
    
    if(!self.categorizedPodcast){
        self.categorizedPodcast = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    
    NSArray *data = result[@"data"];
    
//    NSManagedObjectContext *context = MANAGE_CONTEXT;
    
//    [self showLoadingAnimation:self.view withTotalCount:data.count];
    for (NSDictionary *item in data) {
        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PodcastsObject *podcastsItem = [[PodcastsObject alloc] init];
            
            podcastsItem.id_num = isNIL(item[@"id"]);
            podcastsItem.title = [isNIL(item[@"title"]) uppercaseString];
            podcastsItem.image_url = isNIL(item[@"image"]);
            podcastsItem.description_detail = isNIL(item[@"description"]);
            podcastsItem.category_name = [isNIL(item[@"series"][0][@"name"]) uppercaseString];
            podcastsItem.created_date = isNIL(item[@"created_at"]);
        podcastsItem.audioURL = isNIL(item[@"audiofile"]);
        podcastsItem.youtubeURL = isNIL(item[@"youtubeID"]);
        
        if ([isNIL(item[@"audiofile"]) length]) {
            
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            podcastsItem.audioFilePath = item[@"audiofile"];// [[documentsDirectoryURL URLByAppendingPathComponent:[item[@"audiofile"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]] absoluteString];
        }
        
        
        BOOL alreadyAdded = NO;
        for (PodcastsObject *i in self.podcastList) {
            if ([i.id_num integerValue] == [podcastsItem.id_num integerValue]) {
                alreadyAdded = YES;
                break;
            }
        }
        
        if (!alreadyAdded) {
            [self.podcastList addObject:podcastsItem];
            
            NSString *key = podcastsItem.category_name;
            if (![[self.categorizedPodcast allKeys] containsObject:key]) {
                NSMutableArray *array = [NSMutableArray array];
                [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
                
                NSDictionary *category = @{@"kTitle":[key uppercaseString],@"kImage":podcastsItem.image_url,@"kImageData":isNIL(podcastsItem.image_data)};
                [self.categories addObject:category];
            }
            
            NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
            [subArray addObject:podcastsItem];
            
            [self.categorizedPodcast setObject:subArray forKey:key];
            
//            CGFloat value = ((float)([data indexOfObject:item] + 1) / (float)data.count);
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:[NSNumber numberWithFloat:value]];
            
            
            [self.mainTableView reloadData];
        }
        
        
        
        
        
    }
    
//    for (PodcastsObject *item in self.podcastList) {
//        NSString *key = item.category_name;
//        if (![[self.categorizedPodcast allKeys] containsObject:key]) {
//            NSMutableArray *array = [NSMutableArray array];
//            [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
//            
//            NSDictionary *category = @{@"kTitle":key,@"kImage":item.image_url,@"kImageData":isNIL(item.image_data)};
//            [self.categories addObject:category];
//        }
//        
//        NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
//        [subArray addObject:item];
//        
//        [self.categorizedPodcast setObject:subArray forKey:key];
//    }
    
    
    
    
    [self saveOfflineData:self.podcastList forKey:@"podcasts_list"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
//    [self removeLoadingAnimation];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOBS_PODCAST_NOTIFICATION object:nil];
}

- (IBAction)changeView:(id)sender {
    
//    [self showLoadingAnimation:self.view withTotalCount:self.podcastList.count];
    if ([self.segmentedControl selectedSegmentIndex] == 1) {
        self.isCategoriesShown = YES;
    }
    else {
        self.isCategoriesShown = NO;
    }
    
    [self.mainTableView reloadData];
//    [self removeLoadingAnimation];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isCategoriesShown) {
        return _categories.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
//        if (section != self.sectionExpanded) {
//            return 0;
//        }
//        else {
        
            NSString *key = [self.categories[section] objectForKey:@"kTitle"];
        
            return [[self.categorizedPodcast objectForKey:key] count];
//        }
    }
    return self.podcastList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
        return 160.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isCategoriesShown && [indexPath section] != self.sectionExpanded) {
        return 0.0f;
    }
    
    
    CGFloat buttonHeight = 0.0f;
    
    
    PodcastsObject *item = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        item = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        item = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    // add controls
    
    CGFloat buttonWidth = (tableView.bounds.size.width - 150.0f)/2; //divide per control
    
    CustomButton *buttonSpeaker = [[CustomButton alloc] initWithText:[item.category_name uppercaseString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[@"ccf center" uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f) locked:YES];
    
    buttonHeight = 30.0f;
    for (CustomButton *button in @[buttonSpeaker,buttonVenue]) {
        if (button.frame.size.height > buttonHeight) {
            buttonHeight = button.frame.size.height;
        }
    }
    
    
    return 110.0f + buttonHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isCategoriesShown) {
        NSString *title = [self.categories[section] objectForKey:@"kTitle"];
        
        __block NSData *imageData = nil;
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.categories[section] objectForKey:@"kImageData"] && [[self.categories[section] objectForKey:@"kImageData"] isKindOfClass:[NSData class]]) {
            imageData = [self.categories[section] objectForKey:@"kImageData"];
            imageView.image = [UIImage imageWithData:imageData];
        }
        else {
            if ([[self.categories[section] objectForKey:@"kImage"] length]) {
                
                NSString *urlPath = [self.categories[section] objectForKey:@"kImage"];
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,urlPath]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    imageData = UIImageJPEGRepresentation(image, 100.0f);
                    if (imageData) {
                        NSMutableDictionary *updated = [[NSMutableDictionary alloc] initWithDictionary:self.categories[section]];
                        [updated setObject:imageData forKey:@"kImageData"];                        
                        [self.categories replaceObjectAtIndex:section withObject:updated];
                    }
                    
                }];
                
//                [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
//                    
//                    if(!error) {
//                        UIImage *image = (UIImage*)responseObject;
//                        NSMutableDictionary *updated = [[NSMutableDictionary alloc] initWithDictionary:self.categories[section]];
//                        
//                        [updated setObject:UIImageJPEGRepresentation(image, 100.0f) forKey:@"kImageData"];
//                        
//                        [self.categories replaceObjectAtIndex:section withObject:updated];
//                        
//                        [self.mainTableView reloadData];
//                    }
//                } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
//                    
//                }];
            }
        }
        
//        UIImage *image = [self.categories[section] objectForKey:@"kImage"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 160.0f)];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        button.tag = section;
        [button addTarget:self action:@selector(setSectionExpandedWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
        if (imageData && imageView.image) {
            UIImage *image = imageView.image;//[UIImage imageWithData:imageData];
            [button setImage:image forState:UIControlStateNormal];
            [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
            [button setTitle:@"" forState:UIControlStateNormal];
            button.backgroundColor = [UIColor clearColor];
        }
        else {
            button.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
        }
        
        button.layer.borderWidth = 1.0f;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        
        return button;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PodcastsObject *item = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        item = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        item = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    NSString *identifier = @"podcastCellImage";//([item.image_url length])?@"podcastCellImage":@"podcastCell";
    
    PodcastTableViewCell *cell = (PodcastTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.podcastTitle.text = [NSString stringWithFormat:@"%@",item.title];
    cell.podcastDescription.text = item.description_detail;
    
//    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",item.created_date] forState:UIControlStateNormal];
//    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
//    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
//    cell.podcastLocation.latitude = [NSNumber numberWithDouble:14.589221];
//    cell.podcastLocation.longitude = [NSNumber numberWithDouble:121.078906];
//    cell.podcastLocation.locationName = @"CCF CENTER";
//    [cell.podcastLocation addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (item.image_data) {
        cell.podcastImage.image = [UIImage imageWithData:item.image_data];
    }
    else {
        if ([item.image_url length]) {
//            [self getImageFromURL:item.image_url onIndex:[indexPath row]];
            [cell.podcastImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,item.image_url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                item.image_data = UIImageJPEGRepresentation(image, 100.0f);
            }];
        }
        else {
            cell.podcastImage.image = [UIImage imageNamed:@"placeholder"];
            cell.podcastImage.alpha = 0.8f;
        }
    }
    
    [cell.podcastTitle sizeToFit];
    
    
    
    while ([[cell.viewForControls subviews] count] > 0) {
        [[[cell.viewForControls subviews] lastObject] removeFromSuperview];
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

    
- (void)tableView:(UITableView *)tableView willDisplayCell:(PodcastTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PodcastsObject *item = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        item = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        item = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    // add controls
    
    CGFloat buttonWidth = (cell.contentView.bounds.size.width - 150.0f)/2; //divide per control
    
    CustomButton *buttonSpeaker = [[CustomButton alloc] initWithText:[item.category_name uppercaseString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f) locked:NO];
    buttonSpeaker.labelText.textColor = [UIColor grayColor];
    buttonSpeaker.userInteractionEnabled = NO;
    [cell.viewForControls addSubview:buttonSpeaker];
    
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[@"ccf center" uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f) locked:NO];
    buttonVenue.labelText.textColor = TEAL_COLOR;
    buttonVenue.userInteractionEnabled = YES;
    buttonVenue.button.latitude = [NSNumber numberWithDouble:14.589221];
    buttonVenue.button.longitude = [NSNumber numberWithDouble:121.078906];
    buttonVenue.button.locationName = @"CCF CENTER";
    [buttonVenue.button addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewForControls addSubview:buttonVenue];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewMapButton:)];
//    tap.numberOfTapsRequired = 1;
//    [buttonVenue.button addGestureRecognizer:tap];
    
//    buttonVenue.layer.borderWidth = 1.0f;
//    buttonVenue.layer.borderColor = [UIColor redColor].CGColor;
//    buttonSpeaker.layer.borderColor = [UIColor yellowColor].CGColor;
//    buttonSpeaker.layer.borderWidth = 1.0f;

    buttonSpeaker.translatesAutoresizingMaskIntoConstraints = NO;
    buttonVenue.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *marginLayout = cell.viewForControls.layoutMarginsGuide;
    
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeBottom multiplier:1.0 constant:15.0f]];

    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:-15.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonSpeaker attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0f]];
    
    [cell.viewForControls addConstraint:[NSLayoutConstraint constraintWithItem:buttonVenue attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeTrailingMargin multiplier:1.0 constant:1.0f]];
    
    
//    CGSize maximumLabelSize = CGSizeMake(viewFrame.size.width - 22.0f, CGFLOAT_MAX);
//    CGRect textRect = [[text uppercaseString] boundingRectWithSize:maximumLabelSize
//                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:11.0f]}
//                                                           context:nil];
//    
//    CGSize contentSize = textRect.size;
//    [buttonSpeaker addConstraint:[NSLayoutConstraint constraintWithItem:buttonSpeaker attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:self.computedWidth]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    PodcastsObject *item = nil;
    if (self.isCategoriesShown) {
        NSString *key = [[self.categories objectAtIndex:[indexPath section]] objectForKey:@"kTitle"];
        item = [[self.categorizedPodcast objectForKey:key] objectAtIndex:[indexPath row]];
        
    }
    else {
        item = [self.podcastList objectAtIndex:[indexPath row]];
    }
    
    PodcastDetailsTableViewController *details = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastDetailsView"];
    details.delegate = self;
    details.podcastTitle = [NSString stringWithFormat:@"%@",item.title];
    details.podcastDescription = item.description_detail;
    details.otherText = [item.category_name uppercaseString];
    details.podcastSpeaker = @"Speaker 1";
    
    details.imageURL = item.image_url;
    details.youtubeID = [item.youtubeURL length]?[item.youtubeURL substringWithRange:NSMakeRange(32, 11)]:@"";
    details.urlForAudio = [item.audioURL length]?[NSString stringWithFormat:@"%@%@%@/audio/%@",kAPI_LINK,@"/podcasts/",item.id_num,item.audioURL]:@"";
    details.audioFilePath = item.audioFilePath;
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [details.view.layer addAnimation:transition forKey:nil];
    
    
    details.view.frame = self.view.bounds;
    [self.view addSubview:details.view];
    [self addChildViewController:details];
    [details didMoveToParentViewController:self];
    
    
}

- (void) setSectionExpandedWithButton:(UIButton*)sender {
//    if (sender.tag == self.sectionExpanded) {
//        self.sectionExpanded = -1;
//        NSRange range = NSMakeRange(0, 1);
//        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.mainTableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
//    }
//    else {
//        self.sectionExpanded = sender.tag;
//        NSRange range = NSMakeRange(self.sectionExpanded, 1);
//        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
//        [self.mainTableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
//    }
//    
//    
//    [self.mainTableView layoutIfNeeded];
//    if (self.sectionExpanded > -1) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:self.sectionExpanded];
//            
//            [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        });}
//    }

    
    PodcastListViewController *podcastListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"podcastList"];
    
    NSString *key = [self.categories[sender.tag] objectForKey:@"kTitle"];
    
//    PodcastsObject *item = [[self.categorizedPodcast objectForKey:key] lastObject];
    
    podcastListVC.categoryImageURL = [self.categories[sender.tag] objectForKey:@"kImage"];
    podcastListVC.categoryImageData = [self.categories[sender.tag] objectForKey:@"kImageData"];
    podcastListVC.podcastList = [self.categorizedPodcast objectForKey:key];
    podcastListVC.podcastCategoryTitle = [key uppercaseString];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [podcastListVC.view.layer addAnimation:transition forKey:nil];
    
    ScrollableMenubarViewController *scrollerParent = (ScrollableMenubarViewController*)self.parentViewController;
    
    podcastListVC.view.frame = CGRectMake(0.0f, 0.0f, scrollerParent.containerViewForTable.frame.size.width, scrollerParent.containerViewForTable.frame.size.height);//self.view.bounds;
    [self.view addSubview:podcastListVC.view];
    [self addChildViewController:podcastListVC];
    [podcastListVC didMoveToParentViewController:self];
    
    
}


- (void) getImageFromURL:(NSString*)urlPath onIndex:(NSInteger)index {
    [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            UIImage *image = (UIImage*)responseObject;
            
            
            for (PodcastsObject *item in self.podcastList) {
                if ([item.id_num integerValue] == [((PodcastsObject*)[self.podcastList objectAtIndex:index]).id_num integerValue]) {
                    item.image_data = UIImageJPEGRepresentation(image, 100.0f);
                    break;
                }
            }
            
            PodcastTableViewCell *cell = (PodcastTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.podcastImage.image = image;
            
//            NSManagedObjectContext *context = MANAGE_CONTEXT;
//            
//            NSFetchRequest *request = [PodcastsItem fetchRequest];
//            [request setReturnsObjectsAsFaults:NO];
//            NSError *error = nil;
//            
//            NSArray *result = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//            
//            id podcastItem = nil;
//            
//            for (PodcastsItem *item in result) {
//                if ([item.id_num integerValue] == [((PodcastsItem*)[self.podcastList objectAtIndex:index]).id_num integerValue]) {
//                    podcastItem = item;
//                    break;
//                }
//            }
//            
//            ((PodcastsItem*)podcastItem).image_data = UIImageJPEGRepresentation(image, 100.0f);
//            
//            NSError *saveError = nil;
//            
//            if([context save:&saveError]) {
//                
//                PodcastTableViewCell *cell = (PodcastTableViewCell*)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
//                
//                cell.podcastImage.image = image;
//                
//                
//            }
        }
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        
    }];
}

- (void)activeAudioPlayer:(AVPlayer *)player {
    self.audioPlayerPauser = player;
}

- (void)activeYoutubePlayer:(YTPlayerView *)youtubePlayer {
    self.youtubePlayerPauser = youtubePlayer;
}

- (void) activeAudioFilePlayer:(YMCAudioPlayer *)player {
    self.audioFilePlayerPauser = player;
}

@end
