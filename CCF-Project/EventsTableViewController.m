//
//  EventsTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsTableViewController.h"
#import "MapViewController.h"
#import "EventsDetailViewController.h"
#import "EventsTableViewCell.h"

@interface EventsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger shownPerPage;

@property (strong, nonatomic) NSMutableArray *events_link;

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    self.shownPerPage = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendEventsList:) name:kOBS_EVENTS_NOTIFICATION object:nil];
    
    [self callGETAPI:kEVENTS_LINK withParameters:nil completionNotification:kOBS_EVENTS_NOTIFICATION];
    
//    [self showLoadingAnimation:self.view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)reloadTables {
    [super reloadTables];
    
    self.events_link = nil;
    
    [self callGETAPI:kEVENTS_LINK withParameters:nil completionNotification:kOBS_EVENTS_NOTIFICATION];
//    [self showLoadingAnimation:self.view];
}

- (void)appendEventsList:(NSNotification*)notification {
//    NSLog(@"### result:%@",notification.object);
    
    [self removeLoadingAnimation];
    
    if(!self.events_link){
        self.events_link = [NSMutableArray array];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    NSArray *data = result[@"data"];
    
    [self showLoadingAnimation:self.view withTotalCount:data.count];
    
    
    
    
    for (NSDictionary *item in data) {
        
//        NSDictionary *events = @{@"kTitle":item[@"title"],@"kImage":item[@"image"],@"kDescription":item[@"description"],@"kDate":item[@"date"],@"kTime":item[@"time"],@"kDateRaw":item[@"dateRaw"][@"date"],@"kRegLink":item[@"registration_link"],@"kSpeaker":item[@"speakers"],@"kMobile":item[@"contact_info"],@"kVenue":item[@"venue"],@"kCreatedTime":item[@"created_at"]};
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            EventsObject *events = [[EventsObject alloc] init];
            events.title = isNIL(item[@"title"]);
            events.image_url = isNIL(item[@"image"]);
            events.description_detail = isNIL(item[@"description"]);
            events.date = isNIL(item[@"date"]);
            events.time = isNIL(item[@"time"]);
            events.date_raw = isNIL(item[@"dateRaw"][@"date"]);
            events.registration_link = isNIL(item[@"registration_link"]);
            events.speakers = isNIL(item[@"speakers"]);
            events.contact_info = isNIL(item[@"contact_info"]);
            events.venue = isNIL(item[@"venue"]);
            events.created_date = isNIL(item[@"created_at"]);
            
            
            [self.events_link addObject:events];
        
        [self progressValue:((float)self.events_link.count/(float)data.count)];
        
//            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
//            });
//        });
        
    }
    
    
    [self removeLoadingAnimation];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events_link.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventsObject *events = (EventsObject*)[self.events_link objectAtIndex:[indexPath row]];
    
    // add controls
    
    CGFloat buttonWidth = (tableView.frame.size.width-25.0f)/3; //divide per control
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[events.venue capitalizedString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f)];
    
    
    CustomButton *buttonDate = [[CustomButton alloc] initWithText:[events.date capitalizedString] image:[UIImage imageNamed:@"calendar-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f)];
    
    CustomButton *buttonTime = [[CustomButton alloc] initWithText:[events.time uppercaseString] image:[UIImage imageNamed:@"time-icon-small"] frame:CGRectMake(buttonWidth + buttonWidth, 0.0f, buttonWidth, 30.0f)];
    
    CGFloat height = 30.0f;
    for (CustomButton *button in @[buttonVenue,buttonDate,buttonTime]) {
        if (button.frame.size.height > height) {
            height = button.frame.size.height;
        }
    }
    
    
    return height + 145.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventsTableViewCell *cell = (EventsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"eventsCell"];
    
    EventsObject *events = (EventsObject*)[self.events_link objectAtIndex:[indexPath row]];
    
    
    cell.eventsImageView.image = [UIImage imageNamed:@"placeholder"];
//    [cell.eventsDate setTitle:[NSString stringWithFormat:@"  %@",events.date] forState:UIControlStateNormal];
//    [cell.eventsTime setTitle:[NSString stringWithFormat:@"  %@",events.time] forState:UIControlStateNormal];
//    
//    
//    NSMutableString *venue = [NSMutableString stringWithFormat:@"%@",events.venue];
//    
//    [venue replaceOccurrencesOfString:@"," withString:@",\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, venue.length)];
//    [cell.eventsVenue setTitle:[NSString stringWithFormat:@"  %@",venue] forState:UIControlStateNormal];

    
    while ([[cell.viewControls subviews] count] > 0) {
        [[[cell.viewControls subviews] lastObject] removeFromSuperview];
    }
    
    cell.eventsTitle.text = events.title;
    cell.eventsTitle.hidden = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EventsTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EventsObject *events = (EventsObject*)[self.events_link objectAtIndex:[indexPath row]];
    
    if (events.image_data) {
        cell.eventsImageView.image = [UIImage imageWithData:events.image_data];
    }
    else {
        if ([events.image_url length]) {
//            [self getImageFromURL:events.image_url onIndex:[indexPath row]];
            [cell.eventsImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,events.image_url]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                events.image_data = UIImageJPEGRepresentation(image, 100.0f);
            }];
        }
        else {
            cell.eventsImageView.image = [UIImage imageNamed:@"placeholder"];
        }
    }
    
    // add controls
    
    CGFloat buttonWidth = (cell.contentView.frame.size.width-25.0f)/3; //divide per control
    
    CustomButton *buttonVenue = [[CustomButton alloc] initWithText:[events.venue capitalizedString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 30.0f)];
    buttonVenue.labelText.textColor = TEAL_COLOR;
    buttonVenue.button.latitude = [NSNumber numberWithDouble:14.589221];
    buttonVenue.button.longitude = [NSNumber numberWithDouble:121.078906];
    buttonVenue.button.locationName = @"CCF CENTER";
    buttonVenue.button.locationSnippet = [events.venue capitalizedString];
    [buttonVenue.button addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    
//    buttonVenue.layer.borderWidth = 1.0f;
    
    [cell.viewControls addSubview:buttonVenue];
    
    
    CustomButton *buttonDate = [[CustomButton alloc] initWithText:[events.date capitalizedString] image:[UIImage imageNamed:@"calendar-icon-small"] frame:CGRectMake(buttonWidth, 0.0f, buttonWidth, 30.0f)];
    buttonDate.labelText.textColor = TEAL_COLOR;
    [buttonDate.button addTarget:self action:@selector(saveDateCalendar:) forControlEvents:UIControlEventTouchUpInside];
    buttonDate.button.eventTitle = events.title;
    buttonDate.button.eventAddress = events.venue;
    buttonDate.button.eventDate = events.date;
    buttonDate.button.eventTime = events.time;
//    buttonDate.layer.borderWidth = 1.0f;
    
    [cell.viewControls addSubview:buttonDate];
    
    CustomButton *buttonTime = [[CustomButton alloc] initWithText:[events.time uppercaseString] image:[UIImage imageNamed:@"time-icon-small"] frame:CGRectMake(buttonWidth + buttonWidth, 0.0f, buttonWidth, 30.0f)];
    buttonTime.labelText.textColor = TEAL_COLOR;
    [buttonTime.button addTarget:self action:@selector(saveDateCalendar:) forControlEvents:UIControlEventTouchUpInside];
    buttonTime.button.eventTitle = events.title;
    buttonTime.button.eventAddress = events.venue;
    buttonTime.button.eventDate = events.date;
    buttonTime.button.eventTime = events.time;
//    buttonTime.layer.borderWidth = 1.0f;
    
    [cell.viewControls addSubview:buttonTime];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectEventAtIndexPath:)];
    [buttonTime addGestureRecognizer:tap];
    [buttonDate addGestureRecognizer:tap];
    tap.numberOfTapsRequired = 1;

    
}

- (void) selectEventAtIndexPath:(UIGestureRecognizer*)gestureRecognizer {
    CustomButton *button = (CustomButton*)gestureRecognizer.view;
//    NSLog(@"##### lol");
    [self performSelector:@selector(saveDateCalendar:) withObject:button.button];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EventsDetailViewController *eventsDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsDetail"];
    eventsDetailVC.showRegisterCell = YES;
    
    EventsObject *events = (EventsObject*)[self.events_link objectAtIndex:[indexPath row]];
    
    eventsDetailVC.titleText = events.title;
    eventsDetailVC.locationName = events.venue;
    eventsDetailVC.dateText = events.date;
    eventsDetailVC.timeText = events.time;
    eventsDetailVC.imageURL = events.image_url;
    eventsDetailVC.imageData = events.image_data;
    eventsDetailVC.detailDescription = events.description_detail;
    eventsDetailVC.personName = events.speakers;
    eventsDetailVC.personMobile = [NSString stringWithFormat:@"+63%@",[events.contact_info substringFromIndex:1]];
    eventsDetailVC.registerLink = events.registration_link;
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    [eventsDetailVC.view.layer addAnimation:transition forKey:nil];
    
    
    eventsDetailVC.view.frame = self.view.bounds;
    [[self.view superview] addSubview:eventsDetailVC.view];
    [[self parentViewController] addChildViewController:eventsDetailVC];
    [eventsDetailVC didMoveToParentViewController:[self parentViewController]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (IBAction)viewMapButton:(id)sender {
//    
//    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapsVC"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.6;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [mapVC.view.layer addAnimation:transition forKey:nil];
//    
//    
//    mapVC.view.frame = self.view.bounds;
//    [self.view addSubview:mapVC.view];
//    [self addChildViewController:mapVC];
//    [mapVC didMoveToParentViewController:self];
//}

- (void) getImageFromURL:(NSString*)urlPath onIndex:(NSInteger)index {
    [self getImageFromURL:urlPath completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(!error) {
            UIImage *image = (UIImage*)responseObject;
            
            
            for (EventsObject *item in self.events_link) {
                if ([item.id_num integerValue] == [((EventsObject*)[self.events_link objectAtIndex:index]).id_num integerValue]) {
                    item.image_data = UIImageJPEGRepresentation(image, 100.0f);
                    break;
                }
            }
            
            EventsTableViewCell *cell = (EventsTableViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
            cell.eventsImageView.image = image;
            
        }
    } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
        
    }];
}

@end
