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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendPodcastsList:) name:kOBS_PODCAST_NOTIFICATION object:nil];
    
    [self callGETAPI:kPODCAST_LINK withParameters:nil completionNotification:kOBS_PODCAST_NOTIFICATION];
    
//    [self showLoadingAnimation:self.view];
    
    
//    self.podcastList = [NSMutableArray array];
//    self.categories = [NSMutableArray array];
//    
//    NSString *title = @"Podcast Title";
//    NSString *description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    NSString *category = @"all-access";
//    
//    UIImage *image = [UIImage imageNamed:@"all-access"];
//    NSDictionary *catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    
//    title = @"Podcast Title";
//    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    category = @"life";
//    
//    image = [UIImage imageNamed:@"life-unboxed"];
//    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    [self.podcastList addObject:dictionary];
//
//
//    
//    
//    title = @"Podcast Title";
//    description = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//    category = @"everyday-conversation";
//    
//    image = [UIImage imageNamed:@"everyday-conversation"];
//    catDict = [NSDictionary dictionaryWithObjectsAndKeys:category,@"kTitle",image,@"kImage", nil];
//    
//    dictionary = [NSDictionary dictionaryWithObjectsAndKeys:title,@"kTitle",description,@"kDescription",category,@"kCategory", nil];
//    
//    [self.categories addObject:catDict];
//    [self.podcastList addObject:dictionary];
//    
//    [self.podcastList addObject:dictionary];
//    
//    self.categorizedPodcast = [NSMutableDictionary dictionary];
//    for (NSDictionary *dictionary in self.podcastList) {
//        NSString *key = [dictionary objectForKey:@"kCategory"];
//        if (![[self.categorizedPodcast allKeys] containsObject:key]) {
//            NSMutableArray *array = [NSMutableArray array];
//            [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
//        }
//        
//        NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
//        [subArray addObject:dictionary];
//        
//        [self.categorizedPodcast setObject:subArray forKey:key];
//    }
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
    
    [self showLoadingAnimation:self.view withTotalCount:data.count];
    for (NSDictionary *item in data) {
        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PodcastsObject *podcastsItem = [[PodcastsObject alloc] init];
            
            podcastsItem.id_num = isNIL(item[@"id"]);
            podcastsItem.title = isNIL(item[@"title"]);
            podcastsItem.image_url = isNIL(item[@"image"]);
            podcastsItem.description_detail = isNIL(item[@"description"]);
            podcastsItem.category_name = isNIL(item[@"series"][0][@"name"]);
            podcastsItem.created_date = isNIL(item[@"created_at"]);
        podcastsItem.audioURL = isNIL(item[@"audiofile"]);
        podcastsItem.youtubeURL = isNIL(item[@"youtubeID"]);
        
            [self.podcastList addObject:podcastsItem];
            
            NSString *key = podcastsItem.category_name;
            if (![[self.categorizedPodcast allKeys] containsObject:key]) {
                NSMutableArray *array = [NSMutableArray array];
                [self.categorizedPodcast setObject:[array mutableCopy] forKey:key];
                
                NSDictionary *category = @{@"kTitle":key,@"kImage":podcastsItem.image_url,@"kImageData":isNIL(podcastsItem.image_data)};
                [self.categories addObject:category];
            }
            
            NSMutableArray *subArray = [self.categorizedPodcast objectForKey:key];
            [subArray addObject:podcastsItem];
            
            [self.categorizedPodcast setObject:subArray forKey:key];
            
        
        [self progressValue:((float)self.podcastList.count/(float)data.count)];
//            dispatch_sync(dispatch_get_main_queue(), ^{
        
                [self.mainTableView reloadData];
//            });
//            
//        });
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
    
    
    
    
    
    [self removeLoadingAnimation];
    
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
    return 120.0f;
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
    [cell.podcastSpeaker setTitle:@"  Speaker 1" forState:UIControlStateNormal];
    [cell.podcastDate setTitle:[NSString stringWithFormat:@"  %@",item.created_date] forState:UIControlStateNormal];
    [cell.podcastLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
    cell.podcastLocation.latitude = [NSNumber numberWithDouble:14.589221];
    cell.podcastLocation.longitude = [NSNumber numberWithDouble:121.078906];
    cell.podcastLocation.locationName = @"CCF CENTER";
    [cell.podcastLocation addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
    details.otherText = [item.category_name capitalizedString];
    details.podcastSpeaker = @"Speaker 1";
    
    details.imageURL = item.image_url;
    details.youtubeID = [item.youtubeURL length]?[item.youtubeURL substringWithRange:NSMakeRange(32, 11)]:@"";
    details.urlForAudio = [item.audioURL length]?[NSString stringWithFormat:@"%@%@{%@}/audio/%@",kAPI_LINK,kPODCAST_LINK,item.id_num,item.audioURL]:@"";
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [details.view.layer addAnimation:transition forKey:nil];
    
    
    details.view.frame = self.view.bounds;
    [[self.view superview] addSubview:details.view];
    [[self parentViewController] addChildViewController:details];
    [details didMoveToParentViewController:[self parentViewController]];
    
    
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
    podcastListVC.podcastCategoryTitle = [key capitalizedString];
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [podcastListVC.view.layer addAnimation:transition forKey:nil];
    
    
    podcastListVC.view.frame = self.view.bounds;
    [[self.view superview] addSubview:podcastListVC.view];
    [[self parentViewController] addChildViewController:podcastListVC];
    [podcastListVC didMoveToParentViewController:[self parentViewController]];
    
    
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

- (void)activeAudioPlayer:(YMCAudioPlayer *)player {
    self.audioPlayerPauser = player;
}

- (void)activeYoutubePlayer:(YTPlayerView *)youtubePlayer {
    self.youtubePlayerPauser = youtubePlayer;
}

@end
