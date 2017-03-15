//
//  SattelitesTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 28/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SattelitesTableViewController.h"
#import "SattelitesTableViewCell.h"


@interface SattelitesTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableDictionary *allLocations;
@property (strong, nonatomic) NSArray *alphabetSections;
@property (strong, nonatomic) NSArray *nearbySections;
@property (strong, nonatomic) NSDictionary *nearbyLocations;
@property (strong, nonatomic) NSDictionary *currentLocationList;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBox;

@property (assign, nonatomic) BOOL isAllLocationSelected;
@property (assign, nonatomic) BOOL isLocationFinished;


@property (assign, nonatomic) NSInteger shownPerPage;

@property (strong, nonatomic) NSMutableArray *sattelites_list;



@end

@implementation SattelitesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.isAllLocationSelected = NO;
    self.isLocationFinished = NO;
    
    self.viewSearchBox.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewSearchBox.layer.borderWidth = 1.0f;
    self.viewSearchBox.layer.cornerRadius = 5.0f;
    self.viewSearchBox.clipsToBounds = YES;
    
    
    self.shownPerPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendSattelitesList:) name:kOBS_SATTELITES_NOTIFICATION object:nil];
    
    [self callGETAPI:kSATTELITES_LINK withParameters:nil completionNotification:kOBS_SATTELITES_NOTIFICATION];
    
    
    
    
    
    
//    NSMutableDictionary *mutableAllLocations = [NSMutableDictionary dictionary];
//    /*dummy start*/
//    NSMutableArray *locationsPerLetter = [NSMutableArray array];
//    
//    NSMutableDictionary *location = [NSMutableDictionary dictionary];
//    
//    [location setObject:@"Abu Dhabi" forKey:@"kLocationName"];
//    [location setObject:@"Foodlands Restaurant, Airport Road, Abu Dhabi, UAE Abu Dhabi, International" forKey:@"kAddress"];
//    [location setObject:@"ccf.abudhabi13@gmail.com" forKey:@"kEmail"];
//    [location setObject:@"+971-526422303" forKey:@"kContact"];
//    [location setObject:@"http://www.ccf.org.ph" forKey:@"kWebsite"];
//    [location setObject:@"24.478502" forKey:@"kLatitude"];
//    [location setObject:@"54.363265" forKey:@"kLongitude"];
//    
//    [locationsPerLetter addObject:location];
//    
//    [mutableAllLocations setObject:locationsPerLetter forKey:@"A"];
//    
//    locationsPerLetter = nil;
//    location = nil;
//    locationsPerLetter = [NSMutableArray array];
//    location = [NSMutableDictionary dictionary];
//    
//    
//    [location setObject:@"Bacoor" forKey:@"kLocationName"];
//    [location setObject:@"V. Central Mall Molino Rd., Molino Blvd, Bacoor City, Cavite" forKey:@"kAddress"];
//    [location setObject:@"ccfbacoor@gmail.com" forKey:@"kEmail"];
//    [location setObject:@"+63-9434770020" forKey:@"kContact"];
//    [location setObject:@"http://www.ccf.org.ph" forKey:@"kWebsite"];
//    [location setObject:@"14.4063622" forKey:@"kLatitude"];
//    [location setObject:@"120.9734334" forKey:@"kLongitude"];
//    
//    [locationsPerLetter addObject:location];
//    
//    [mutableAllLocations setObject:locationsPerLetter forKey:@"B"];
//    
//    locationsPerLetter = nil;
//    location = nil;
//    locationsPerLetter = [NSMutableArray array];
//    location = [NSMutableDictionary dictionary];
//    
//    [location setObject:@"C. Raymundo" forKey:@"kLocationName"];
//    [location setObject:@"Danny Floro Bldg., C. Raymundo Ave., Canlogan, Pasig City, Pasig, Metro Manila" forKey:@"kAddress"];
//    [location setObject:@"ccf.abudhabi13@gmail.com" forKey:@"kEmail"];
//    [location setObject:@"+632-9111111" forKey:@"kContact"];
//    [location setObject:@"http://www.ccf.org.ph" forKey:@"kWebsite"];
//    [location setObject:@"14.572164" forKey:@"kLatitude"];
//    [location setObject:@"121.083508" forKey:@"kLongitude"];
//    
//    [locationsPerLetter addObject:location];
//    
//    [mutableAllLocations setObject:locationsPerLetter forKey:@"C"];
//    
//    locationsPerLetter = nil;
//    location = nil;
//    locationsPerLetter = [NSMutableArray array];
//    location = [NSMutableDictionary dictionary];
//    
//    [location setObject:@"Makati" forKey:@"kLocationName"];
//    [location setObject:@"3rd Floor A. Venue Mall, Makati Ave, Makati City, Makati, Metro Manila" forKey:@"kAddress"];
//    [location setObject:@"marco.ccfmakati@gmail.com" forKey:@"kEmail"];
//    [location setObject:@"+632-7953019, +63-9177700251" forKey:@"kContact"];
//    [location setObject:@"http://www.ccf.org.ph" forKey:@"kWebsite"];
//    [location setObject:@"14.566184" forKey:@"kLatitude"];
//    [location setObject:@"121.029731" forKey:@"kLongitude"];
//    
//    [locationsPerLetter addObject:location];
//    
//    [mutableAllLocations setObject:locationsPerLetter forKey:@"M"];
//    
//    locationsPerLetter = nil;
//    location = nil;
//    
//    /*dummy end*/
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)appendSattelitesList:(NSNotification*)notification {
//    NSLog(@"### result:%@",notification.object);
    
    
    if(!self.sattelites_list){
        self.sattelites_list = [NSMutableArray array];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    NSArray *data = result[@"data"];
    
    for (NSDictionary *item in data) {
        
        NSDictionary *sattelite = @{@"kLocationName":item[@"name"],@"kLatitude":item[@"latitude"],@"kLongitude":item[@"longitude"],@"kAddress":item[@"address_full"],@"kCreatedTime":item[@"created_at"]};
        
        
        [self.sattelites_list addObject:sattelite];
    }
    
    for (NSDictionary *dictionary in self.sattelites_list) {
        NSString *letter_key = [[dictionary objectForKey:@"kLocationName"] substringWithRange:NSMakeRange(0, 1)];
        if (![[self.allLocations allKeys] containsObject:letter_key]) {
            NSMutableArray *array = [NSMutableArray array];
            [self.allLocations setObject:[array mutableCopy] forKey:letter_key];
            
        }
        
        NSMutableArray *subArray = [self.allLocations objectForKey:letter_key];
        [subArray addObject:dictionary];
        
        [self.allLocations setObject:subArray forKey:letter_key];
    }
    
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[self.allLocations allKeys]];
    self.alphabetSections = [sortArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateFinished:) name:kOBS_LOCATIONFINISHED_NOTIFICATION object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isAllLocationSelected) {
        return self.alphabetSections.count;
    }
    else if(self.isLocationFinished) {
        return self.nearbySections.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isAllLocationSelected) {
        return [[self.allLocations objectForKey:self.alphabetSections[section]] count];
    }
    return [[self.nearbyLocations objectForKey:self.nearbySections[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *location = nil;
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    if (self.isAllLocationSelected) {
        location = [NSDictionary dictionaryWithDictionary:[[self.allLocations objectForKey:self.alphabetSections[section]] objectAtIndex:row]];
    }
    else {
        location = [NSDictionary dictionaryWithDictionary:[[self.nearbyLocations objectForKey:self.nearbySections[section]] objectAtIndex:row]];
    }
    
    SattelitesTableViewCell *cell = (SattelitesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"sattelitesCell"];
    
    cell.labelLocationName.text = [location objectForKey:@"kLocationName"];
    
    [cell.labelAddress setTitle:[location objectForKey:@"kAddress"] forState:UIControlStateNormal];
    cell.labelAddress.latitude = [NSNumber numberWithDouble:[[location objectForKey:@"kLatitude"]  doubleValue]];
    cell.labelAddress.longitude = [NSNumber numberWithDouble:[[location objectForKey:@"kLongitude"] doubleValue]];
    cell.labelAddress.locationName = [location objectForKey:@"kLocationName"];
    cell.labelAddress.locationSnippet = [location objectForKey:@"kAddress"];
    
    [cell.labelAddress addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.labelEmail setTitle:@"---"/*[location objectForKey:@"kEmail"]*/ forState:UIControlStateNormal];
    [cell.labelEmail addTarget:self action:@selector(emailButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.labelContacts setTitle:@"---"/*[location objectForKey:@"kContact"]*/ forState:UIControlStateNormal];
    [cell.labelContacts addTarget:self action:@selector(contactButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.labelWebsite setTitle:@"---"/*[location objectForKey:@"kWebsite"]*/ forState:UIControlStateNormal];
    [cell.labelWebsite addTarget:self action:@selector(webURLButton:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.isAllLocationSelected) {
        return [self.alphabetSections objectAtIndex:section];
    }
    else {
        NSString *title = @"";
        NSInteger km = [[self.nearbySections objectAtIndex:section] integerValue];
        switch (km) {
            case 6:
                title = @"More than 5 KM";
                break;
                
            default:
                title = [NSString stringWithFormat:@"Within %li KM",(long)km];
                break;
        }
        return title;
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.isAllLocationSelected) {
        return self.alphabetSections;
    }
    return nil;
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

             for (NSString *keys in self.alphabetSections) {
                 for (NSDictionary *location in [self.allLocations objectForKey:keys]) {
                     
                     CLLocationDegrees latitude = [[location objectForKey:@"kLatitude"] doubleValue];
                     CLLocationDegrees longitude = [[location objectForKey:@"kLongitude"] doubleValue];
                     
                     CLLocation *restaurantLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                     CLLocationDistance meters = [restaurantLocation distanceFromLocation:currentLocation];
//                     NSLog(@"[%@]meters: %f",[location objectForKey:@"kLocationName"],meters);
                     
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
             
             UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"GPS Failed" message:@"Please enable Locations or go outside for better GPS Signal." preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 [alert dismissViewControllerAnimated:YES completion:nil];
             }];
             [alert addAction:actionOK];
             
             [self presentViewController:alert animated:YES completion:^{
                 
             }];
             
         }
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
    self.nearbyLocations = nil;
    self.nearbySections = nil;
    self.nearbyLocations = [NSDictionary dictionaryWithDictionary:[notification object]];
    
    NSMutableArray *sortArray = [NSMutableArray arrayWithArray:[self.nearbyLocations allKeys]];
    self.nearbySections = [sortArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    self.isLocationFinished = YES;
    [self.tableView reloadData];
}

- (void) insertLocation:(NSDictionary*)location withKey:(NSString*)key inDictionary:(NSMutableDictionary*)dictionary {
    
    if (![[dictionary allKeys] containsObject:key]) {
        NSMutableArray *array = [NSMutableArray array];
        [dictionary setObject:[array mutableCopy] forKey:key];
    }
    
    NSMutableArray *subArray = [dictionary objectForKey:key];
    [subArray addObject:location];
}

- (IBAction) webURLButton:(UIButton*)sender {
    NSString *urlString = sender.titleLabel.text;
    [self showWebViewWithURL:urlString];
}

- (IBAction) emailButton:(UIButton*)sender {
    [self mailAddress:sender];
//    NSString *urlString = sender.titleLabel.text;
//    [self openURL:[NSString stringWithFormat:@"mailto://%@",urlString]];
}

- (IBAction) contactButton:(UIButton*)sender {
    [self callNumber:sender];
//    NSString *urlString = sender.titleLabel.text;
//    [self openURL:[NSString stringWithFormat:@"tel://%@",urlString]];
}
@end
