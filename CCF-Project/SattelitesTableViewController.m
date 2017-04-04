//
//  SattelitesTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 28/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SattelitesTableViewController.h"
#import "SattelitesTableViewCell.h"


@interface SattelitesTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *allLocations;
@property (strong, nonatomic) NSArray *alphabetSections;
@property (strong, nonatomic) NSArray *nearbySections;
@property (strong, nonatomic) NSDictionary *nearbyLocations;
@property (strong, nonatomic) NSDictionary *currentLocationList;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBox;
@property (weak, nonatomic) IBOutlet UIView *containerViewSearchResult;

@property (assign, nonatomic) BOOL isAllLocationSelected;
@property (assign, nonatomic) BOOL isLocationFinished;

@property (assign, nonatomic) CGFloat heightSearchResult;

@property (assign, nonatomic) NSInteger shownPerPage;

@property (strong, nonatomic) NSMutableArray *sattelites_list;

@property (strong, nonatomic) NSMutableArray *searchResultList;
@property (strong, nonatomic) UITableView *tableSearchResult;

@property (assign, nonatomic) CGFloat keyboardHeight;

@property (strong, nonatomic) UITapGestureRecognizer *yourTap;

@end

@implementation SattelitesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    self.viewSearchBox.layer.zPosition = 3.0f;
//    self.containerViewSearchResult.layer.zPosition = 2.0f;
    self.tableView.tableHeaderView.layer.zPosition = 2.0f;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    self.textField1 = self.searchTextfield;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myNotificationMethod:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    self.isAllLocationSelected = NO;
    self.isLocationFinished = NO;
    
    self.viewSearchBox.layer.borderColor = [UIColor grayColor].CGColor;
    self.viewSearchBox.layer.borderWidth = 1.0f;
    self.viewSearchBox.layer.cornerRadius = 5.0f;
    self.viewSearchBox.clipsToBounds = YES;
    
    
    self.shownPerPage = 0;
    
    
    
    
    [self reloadTables];

    
    
//    [self showLoadingAnimation:self.view];
    
    self.yourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollTap:)];
    [self.tableView addGestureRecognizer:self.yourTap];
    
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.heightSearchResult = self.containerViewSearchResult.frame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)scrollTap:(UIGestureRecognizer*)gestureRecognizer {
    
    //make keyboard disappear , you can use resignFirstResponder too, it's depend.
    
    [self.searchTextfield resignFirstResponder];
    [self.view endEditing:YES];
}


- (void)reloadTables {
    [super reloadTables];
    
    if (self.sattelites_list) {
        
        [self.sattelites_list removeAllObjects];
        [self.allLocations removeAllObjects];
        self.sattelites_list = nil;
        self.allLocations = nil;
        
    }
    
    if([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable){
        //get offline data
        
        NSManagedObjectContext *context = ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
        
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"OfflineData"];
        
        NSError *error = nil;
        
        NSManagedObject *offlineData = [[context executeFetchRequest:request error:&error] lastObject];
        
        NSArray *newslist = [NSKeyedUnarchiver unarchiveObjectWithData:[offlineData valueForKey:@"satellites_list"]];
        
        [self.sattelites_list removeAllObjects];
        [self.allLocations removeAllObjects];
        self.sattelites_list = nil;
        self.allLocations = nil;
        
        self.sattelites_list = [NSMutableArray arrayWithArray:newslist];
        
        for (SatellitesObject *sattelite in self.sattelites_list) {
            NSString *letter_key = [sattelite.name substringWithRange:NSMakeRange(0, 1)];
            if (![[self.allLocations allKeys] containsObject:letter_key]) {
                NSMutableArray *array = [NSMutableArray array];
                [self.allLocations setObject:[array mutableCopy] forKey:letter_key];
                
            }
            
            NSMutableArray *subArray = [self.allLocations objectForKey:letter_key];
            [subArray addObject:sattelite];
            
            
            
            [self.allLocations setObject:subArray forKey:letter_key];
        }
        
        
        [self.tableView reloadData];
    }
    else {
        
//        CGFloat value = 0.8f;
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:[NSNumber numberWithFloat:value]];
//        
//        NETWORK_INDICATOR(YES)
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendSattelitesList:) name:kOBS_SATTELITES_NOTIFICATION object:nil];
        
        [self callGETAPI:kSATTELITES_LINK withParameters:nil completionNotification:kOBS_SATTELITES_NOTIFICATION];
        
        
    }
    
//    [self showLoadingAnimation:self.view];
}

- (void)appendSattelitesList:(NSNotification*)notification {
//    NSLog(@"### result:%@",notification.object);
    
//    [self removeLoadingAnimation];
    
    NETWORK_INDICATOR(NO)
    
    if(!self.sattelites_list){
        self.sattelites_list = [NSMutableArray array];
    }
    if(!self.allLocations){
        self.allLocations = [NSMutableDictionary dictionary];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    NSArray *data = result[@"data"];
    
//    [self showLoadingAnimation:self.view withTotalCount:data.count];
    for (NSDictionary *item in data) {
        
//        NSDictionary *sattelite = @{@"kLocationName":item[@"name"],@"kLatitude":item[@"latitude"],@"kLongitude":item[@"longitude"],@"kAddress":item[@"address_full"],@"kCreatedTime":item[@"created_at"]};
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            SatellitesObject *sattelite = [[SatellitesObject alloc] init];
            sattelite.name = item[@"name"];
            sattelite.latitude = item[@"latitude"];
            sattelite.longitude = item[@"longitude"];
        
        if ([item[@"address_full"] rangeOfString:@"-,   " options:NSLiteralSearch range:NSMakeRange(0, 5)].location != NSNotFound) {
            sattelite.address_full = [item[@"address_full"] substringFromIndex:5];
        }
        else {
            sattelite.address_full = item[@"address_full"];
        }
            sattelite.created_date = item[@"created_at"];
        
        
        
        
        BOOL alreadyAdded = NO;
        for (SatellitesObject *i in self.sattelites_list) {
            if ([i.id_num integerValue] == [sattelite.id_num integerValue]) {
                alreadyAdded = YES;
                break;
            }
        }
        
        if (!alreadyAdded) {
            [self.sattelites_list addObject:sattelite];
        }
        
        
        
        
        [self progressValue:((float)self.sattelites_list.count/(float)data.count)];
        
            
            NSString *letter_key = [sattelite.name substringWithRange:NSMakeRange(0, 1)];
            if (![[self.allLocations allKeys] containsObject:letter_key]) {
                NSMutableArray *array = [NSMutableArray array];
                [self.allLocations setObject:[array mutableCopy] forKey:letter_key];
                
            }
            
            NSMutableArray *subArray = [self.allLocations objectForKey:letter_key];
            [subArray addObject:sattelite];
        
        
        
            [self.allLocations setObject:subArray forKey:letter_key];
            
        
//        CGFloat value = ((float)([data indexOfObject:item] + 1) / (float)data.count);
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:[NSNumber numberWithFloat:value]];
//        });
    }
    
    
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[self.allLocations allKeys]];
    self.alphabetSections = [sortArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    //    NSLog(@"locations:%@\n\n\nsections:%@",self.allLocations,self.alphabetSections);
    
//    [self removeLoadingAnimation];
    
    
    [self saveOfflineData:self.sattelites_list forKey:@"satellites_list"];
    
    NETWORK_INDICATOR(YES)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateFinished:) name:kOBS_LOCATIONFINISHED_NOTIFICATION object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    
//    [self showLoadingAnimation:self.view];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.tableSearchResult]) {
        return 1;
    }
    else {
        if (self.isAllLocationSelected) {
            return self.alphabetSections.count;
        }
        else if(self.isLocationFinished) {
            return self.nearbySections.count;
        }
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.tableSearchResult]) {
        return self.searchResultList.count?:1;
    }
    else {
        if (self.isAllLocationSelected) {
            return [[self.allLocations objectForKey:self.alphabetSections[section]] count];
        }
        return [[self.nearbyLocations objectForKey:self.nearbySections[section]] count];
        
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGFloat height = 235.0f;
//    if (![tableView isEqual:self.tableSearchResult]) {
//        
//    }
//    return height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SatellitesObject *location = nil;
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (self.isAllLocationSelected) {
        location = [[self.allLocations objectForKey:self.alphabetSections[section]] objectAtIndex:row];
    }
    else {
        location = [[self.nearbyLocations objectForKey:self.nearbySections[section]] objectAtIndex:row];
    }
    
    if ([tableView isEqual:self.tableSearchResult]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if (self.searchResultList.count) {
            cell.textLabel.text = [location.name capitalizedString];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else {
            cell.textLabel.text = @"No Result Found";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        
        return cell;
    }
    else {
        
        
        SattelitesTableViewCell *cell = (SattelitesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"sattelitesCell"];
        
        cell.labelLocationName.text = location.name;
        
        [cell.labelAddress setTitle:location.address_full forState:UIControlStateNormal];
        cell.labelAddress.latitude = [NSNumber numberWithDouble:[location.latitude  doubleValue]];
        cell.labelAddress.longitude = [NSNumber numberWithDouble:[location.longitude doubleValue]];
        cell.labelAddress.locationName = location.name;
        cell.labelAddress.locationSnippet = location.address_full;
        
        
        [cell.labelAddress addTarget:self action:@selector(viewMapButton1:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.labelEmail setTitle:@"---"/*[location objectForKey:@"kEmail"]*/ forState:UIControlStateNormal];
        [cell.labelEmail addTarget:self action:@selector(emailButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.labelContacts setTitle:@"---"/*[location objectForKey:@"kContact"]*/ forState:UIControlStateNormal];
        [cell.labelContacts addTarget:self action:@selector(contactButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.labelWebsite setTitle:@"---"/*[location objectForKey:@"kWebsite"]*/ forState:UIControlStateNormal];
        [cell.labelWebsite addTarget:self action:@selector(webURLButton:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([tableView isEqual:self.tableSearchResult] && self.searchResultList.count) {
        NSString *selected = [self.searchResultList objectAtIndex:[indexPath row]];
        NSInteger section = 0;
        NSInteger row = 0;
        if (self.isAllLocationSelected) {
            
            for (NSString *key in self.alphabetSections) {
                if ([key isEqualToString:[selected substringWithRange:NSMakeRange(0, 1)]]) {
                    for (SatellitesObject *item in [self.allLocations objectForKey:key]) {
                        if ([item.name isEqualToString:selected]) {
                            [self scrollToLocation:[NSIndexPath indexPathForRow:row inSection:section]];
                            break;
                        }
                        row += 1;
                    }
                }
                section += 1;
            }
            
        }
        else {
            
            for (NSString *key in self.nearbySections) {
                if ([key isEqualToString:[selected substringWithRange:NSMakeRange(0, 1)]]) {
                    for (SatellitesObject *item in [self.nearbyLocations objectForKey:key]) {
                        if ([item.name isEqualToString:selected]) {
                            [self scrollToLocation:[NSIndexPath indexPathForRow:row inSection:section]];
                            break;
                        }
                        row += 1;
                    }
                }
                section += 1;
            }
            
        }
    }
    else {
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 30.0f)];
    view.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 30.0f)];
    label.text = [self tableView:tableView titleForHeaderInSection:section];
    label.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0f];
    label.backgroundColor = [UIColor darkGrayColor];
    label.textColor = [UIColor whiteColor];
    
    [view addSubview:label];
    
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:self.tableSearchResult]) {
    }
    else {
        if (self.isAllLocationSelected) {
            return [NSString stringWithFormat:@"   %@",[self.alphabetSections objectAtIndex:section]];
        }
        else {
            NSString *title = @"";
            NSInteger km = [[self.nearbySections objectAtIndex:section] integerValue];
            switch (km) {
                case 6:
                    title = @"   More than 5 KM";
                    break;
                    
                default:
                    title = [NSString stringWithFormat:@"   Within %li KM",(long)km];
                    break;
            }
            return title;
        }
    }
    
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isAllLocationSelected) {
//        NSMutableArray *sections = [NSMutableArray array];
//        for (NSString *key in self.alphabetSections) {
//            [sections addObject:[NSString stringWithFormat:@"%@     \n",key]];
//        }
//        
        
        return self.alphabetSections;
    }
    return nil;
}

- (void) scrollToLocation:(NSIndexPath*)indexPath {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)segmentedControlChange:(id)sender {
    [self.searchTextfield resignFirstResponder];
//    [self showLoadingAnimation:self.view];
    if ([self.segmentedControl selectedSegmentIndex] == 1) {
        self.isAllLocationSelected = YES;
        self.currentLocationList = self.allLocations;
    }
    else {
        self.isAllLocationSelected = NO;
        self.currentLocationList = self.nearbyLocations;
        
        [self.locationManager startUpdatingLocation];
    }
    
    [self.tableView reloadData];
    
    [self removeLoadingAnimation];
}

#pragma mark - CLLocationDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *currentLocation = [locations objectAtIndex:0];
    //    CGFloat userLatitude = currentLocation.coordinate.latitude;
    //    CGFloat userLongitude = currentLocation.coordinate.longitude;
    
    __block NSArray *userCurrentAddressLine = [NSArray array];
    
    [manager stopUpdatingLocation];
    
    
//    NSLog(@"locations:%@",self.allLocations);
    
//    [self removeLoadingAnimation];
//    NETWORK_INDICATOR(YES)
//    [self showLoadingAnimation:self.view withTotalCount:self.sattelites_list.count];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@YES];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //             NSLog(@"\nCurrent Location Detected\n");
             //             NSLog(@"placemark %@",placemark);
             //             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             //             NSString *Address = [[NSString alloc]initWithString:locatedAt];
             //             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             //             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             //             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             //             NSLog(@"%@",CountryArea);
             userCurrentAddressLine = [placemark.addressDictionary valueForKey:@"FormattedAddressLines"];
             
             NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

             NSInteger index = 0;
             for (NSString *keys in self.alphabetSections) {
                 for (SatellitesObject *location in [self.allLocations objectForKey:keys]) {
                     
                     CLLocationDegrees latitude = [location.latitude doubleValue];
                     CLLocationDegrees longitude = [location.longitude doubleValue];
                     
                     CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                     CLLocationDistance meters = [restaurantLocation distanceFromLocation:currentLocation];
//                     NSLog(@"[%@]meters: %f",location.name,meters);
                     
                     index++;
                     
                     [self progressValue:(float)index/(float)self.sattelites_list.count];
                     
                     if (meters <= 10000) {
                         [self insertLocation:location withKey:@"1" inDictionary:dictionary];
                     }
                     else if (meters <= 20000) {
                         [self insertLocation:location withKey:@"2" inDictionary:dictionary];
                     }
                     else if (meters <= 30000) {
                         [self insertLocation:location withKey:@"3" inDictionary:dictionary];
                     }
                     else if (meters <= 40000) {
                         [self insertLocation:location withKey:@"4" inDictionary:dictionary];
                     }
                     else if (meters <= 50000) {
                         [self insertLocation:location withKey:@"5" inDictionary:dictionary];
                     }
                     else {
                         [self insertLocation:location withKey:@"6" inDictionary:dictionary];
                     }
                     
                 }
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kOBS_LOCATIONFINISHED_NOTIFICATION object:[NSDictionary dictionaryWithDictionary:dictionary]];
         }
         else
         {
             
//             [self removeLoadingAnimation];
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GPS Failed" message:@"Please enable Locations or go outside for better GPS Signal." preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [alert dismissViewControllerAnimated:YES completion:nil];
             }];
             [alert addAction:actionOK];
             
             [self presentViewController:alert animated:YES completion:^{
                 
             }];
             
         }
         
//         NETWORK_INDICATOR(NO)
         /*---- For more results
          placemark.region);
          placemark.country);
          placemark.locality);
          placemark.name);
          placemark.ocean);
          placemark.postalCode);
          placemark.subLocality);
          placemark.location);
          ------*/
     }];
    
    
    
}

- (void) locationUpdateFinished:(NSNotification*)notification {
//    NETWORK_INDICATOR(YES)
    self.nearbyLocations = nil;
    self.nearbySections = nil;
    self.nearbyLocations = [NSDictionary dictionaryWithDictionary:[notification object]];
    
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[self.nearbyLocations allKeys]];
    self.nearbySections = [sortArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    self.isLocationFinished = YES;
    
    
//    NETWORK_INDICATOR(NO)
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
//    [self removeLoadingAnimation];
}

- (void) insertLocation:(SatellitesObject*)location withKey:(NSString*)key inDictionary:(NSMutableDictionary*)dictionary {
    
    if (![[dictionary allKeys] containsObject:key]) {
        NSMutableArray *array = [NSMutableArray array];
        [dictionary setObject:[array mutableCopy] forKey:key];
    }
    
    NSMutableArray *subArray = [dictionary objectForKey:key];
    [subArray addObject:location];
}

- (IBAction) viewMapButton1:(UIButton*)sender {
    [self.searchTextfield resignFirstResponder];
    
    [self viewMapButton:sender];
}

- (IBAction) webURLButton:(UIButton*)sender {
    [self.searchTextfield resignFirstResponder];
    NSString *urlString = sender.titleLabel.text;
    [self showWebViewWithURL:urlString];
}

- (IBAction) emailButton:(UIButton*)sender {
    [self.searchTextfield resignFirstResponder];
    [self mailAddress:sender];
//    NSString *urlString = sender.titleLabel.text;
//    [self openURL:[NSString stringWithFormat:@"mailto://%@",urlString]];
}

- (IBAction) contactButton:(UIButton*)sender {
    [self.searchTextfield resignFirstResponder];
    [self callNumber:sender];
//    NSString *urlString = sender.titleLabel.text;
//    [self openURL:[NSString stringWithFormat:@"tel://%@",urlString]];
}


- (void)removeFromParentViewController {
    [self.searchTextfield resignFirstResponder];
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchTextfield resignFirstResponder];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    CGFloat height = self.tableView.frame.size.height -  self.keyboardHeight - 50.0f;
    
    self.tableSearchResult = [[UITableView alloc] initWithFrame:CGRectMake(5.0f, self.heightSearchResult, self.containerViewSearchResult.frame.size.width - 10.0f, height - self.heightSearchResult - 5.0f) style:UITableViewStylePlain];
    self.tableSearchResult.delegate = self;
    self.tableSearchResult.dataSource = self;
    
    [self.containerViewSearchResult addSubview:self.tableSearchResult];
    
    [self.tableSearchResult removeGestureRecognizer:self.yourTap];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.containerViewSearchResult.frame;
        frame.size.height = height;
        self.containerViewSearchResult.frame = frame;
    } completion:^(BOOL finished) {
        [self searchString:textField.text];
    }];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchResultList = nil;
    [self.tableSearchResult removeFromSuperview];
    self.tableSearchResult = nil;
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.containerViewSearchResult.frame;
        frame.size.height = self.heightSearchResult;
        self.containerViewSearchResult.frame = frame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *searchString = [NSString stringWithFormat:@"%@%@",textField.text,string];
    
    [self searchString:searchString];
    
    return YES;
}

- (void) searchString:(NSString*)string {
    if(!self.searchResultList){
        self.searchResultList = [NSMutableArray array];
    }
    for (SatellitesObject *item in self.sattelites_list) {
        
        if ([item.name rangeOfString:string options:NSCaseInsensitiveSearch].location != NSNotFound) {
            if (![self.searchResultList containsObject:item.name]) {
                [self.searchResultList addObject:item.name];
            }
        }
    }
    
    [self.tableSearchResult reloadData];
}

- (void)myNotificationMethod:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    self.keyboardHeight = keyboardFrameBeginRect.size.height;
}

@end
