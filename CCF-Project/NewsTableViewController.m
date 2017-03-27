//
//  NewsTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 23/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "NewsTableViewController.h"
#import "MapViewController.h"
#import "NewsCollapsedTableViewCell.h"
#import "EventsDetailViewController.h"

@interface NewsTableViewController () <NewsCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *groupList;
@property (strong, nonatomic) NSMutableArray *news_list;
@property (assign, nonatomic) NSInteger shownPerPage;

//@property (strong, nonatomic) NSIndexPath *indexPath_expanded;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.indexPath_expanded = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
    self.shownPerPage = 0;
    
    
    NETWORK_INDICATOR(YES)
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callGroupsData:) name:kOBS_GROUPS_NOTIFICATION object:nil];
    
    [self callGETAPI:kGROUPS_LINK withParameters:nil completionNotification:kOBS_GROUPS_NOTIFICATION];
    
    
//    [self showLoadingAnimation:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTables {
    [super reloadTables];
        
    if(self.news_list){
        self.news_list = nil;
        
        [self callGETAPI:kNEWS_LINK withParameters:nil completionNotification:kOBS_NEWS_NOTIFICATION];
    }
//    [self showLoadingAnimation:self.view];
}

- (void)callGroupsData:(NSNotification*)notification {
    //    NSLog(@"## result:%@",notification.object);
    
    
    NETWORK_INDICATOR(NO)
    
    if(!self.groupList){
        self.groupList = [NSMutableArray array];
    }
    
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    NSArray *data = result[@"data"];
    
    for (NSDictionary *item in data) {
        [self.groupList addObject:item];
    }
    
    
    NETWORK_INDICATOR(YES)
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendNewsList:) name:kOBS_NEWS_NOTIFICATION object:nil];
    
    [self callGETAPI:kNEWS_LINK withParameters:nil completionNotification:kOBS_NEWS_NOTIFICATION];
}


- (void)appendNewsList:(NSNotification*)notification {
//    NSLog(@"##%s## result:%@",__FUNCTION__,notification.object);
    
//    [self removeLoadingAnimation];
    
    NETWORK_INDICATOR(NO)
    
    if(!self.news_list){
        self.news_list = [NSMutableArray array];
    }
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    self.shownPerPage = [result[@"meta"][@"pagination"][@"per_page"] integerValue];
    
    NSArray *data = result[@"data"];
    
    
    for (NSDictionary *item in data) {
        
        
        BOOL hasGroupSelection = NO;
        
        for (NSDictionary *groupItem in self.groupList) {
            
            NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
            
            BOOL switchValue = [[NSUserDefaults standardUserDefaults] boolForKey:valueKey];
            
            if ([item[@"groups"] isKindOfClass:[NSArray class]]) {
                if ([item[@"groups"] count]) {
                    for (NSDictionary *groups in item[@"groups"]) {
                        if ([groupItem[@"id"] integerValue] == [groups[@"id"] integerValue] && switchValue) {
                            hasGroupSelection = YES;
                            break;
                        }
                    }
                }
            }
            else if ([item[@"groups"] isEqualToString:@"all"]){
                hasGroupSelection = YES;
                break;
            }
            
            
        }
        
//        NSManagedObjectContext *context = MANAGE_CONTEXT;
//        
//        NewsItem *newsItem = (NewsItem*)[NewsItem addItemWithContext:context];
//        
//        newsItem.id_num = isNIL(item[@"id"]);
//        newsItem.title = isNIL(item[@"title"]);
//        newsItem.image = isNIL(item[@"image"]);
//        newsItem.group_name = isNIL(item[@"groups"][0][@"name"]);
//        newsItem.description_detail = isNIL(item[@"description"]);
//        newsItem.created_date = isNIL(item[@"created_at"]);
//
//        
//        
//        NSError *error = nil;
//        
//        if (![context save:&error]) {
//            UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Fatal Error" message:@"Error saving data. Please contact developer." preferredStyle:UIAlertControllerStyleActionSheet];
//            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [self dismissViewControllerAnimated:YES completion:nil];
//            }];
//            
//            [ac addAction:cancel];
//            
//            [self presentViewController:ac animated:YES completion:nil];
//        }
        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (hasGroupSelection) {
            NewsObject *newsItem = [[NewsObject alloc] init];
            newsItem.id_num = isNIL(item[@"id"]);
            newsItem.title = isNIL(item[@"title"]);
            newsItem.image_url = isNIL(item[@"image"]);
            newsItem.description_detail = isNIL(item[@"description"]);
            newsItem.created_date = isNIL(item[@"created_at"]);
            
            if ([item[@"groups"] isKindOfClass:[NSArray class]]) {
                if ([item[@"groups"] count]) {
                    newsItem.group_name = isNIL(item[@"groups"][0][@"name"]);
                }
            }
            else {
                newsItem.group_name = isNIL(item[@"groups"]);
            }
            
            
            [self.news_list addObject:newsItem];
            
        }
        [self.tableView reloadData];
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.news_list.count;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsObject *newsItem = (NewsObject*)[self.news_list objectAtIndex:[indexPath row]];
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width - 20.0f, 120.0f)];
    tv.text = newsItem.description_detail;
    tv.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
    CGSize contentSize = [tv contentSize];
    
    if (contentSize.height > 120.0f) {
        return 100.0f + (contentSize.height - 120.0f);
    }
    
    return 130.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCollapsedTableViewCell *cell = (NewsCollapsedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:/*@"newsCell"*/@"newsCell-noLocation"];
    
//    NewsItem *newsItem = (NewsItem*)[self.news_list objectAtIndex:[indexPath row]];
    NewsObject *newsItem = (NewsObject*)[self.news_list objectAtIndex:[indexPath row]];
    
    cell.labelNewsTitle.text = newsItem.title;
    cell.labelTimeCreated.text = [self getTimepassedTextFrom:newsItem.created_date];
    cell.textNewsDetails.text = newsItem.description_detail;
    [cell.textNewsDetails scrollsToTop];
    
//    [cell.buttonGroupName setTitle:[NSString stringWithFormat:@"  %@",[newsItem.group_name capitalizedString]] forState:UIControlStateNormal];
//    [cell.buttonLocation setTitle:@"  CCF CENTER" forState:UIControlStateNormal];
//    [cell.buttonDate setTitle:[NSString stringWithFormat:@"  %@",newsItem.created_date] forState:UIControlStateNormal];
//    [cell.buttonSpeaker setTitle:@"  Speaker Name here" forState:UIControlStateNormal];
    [cell.buttonSpeaker setHidden:YES];
//    [cell.buttonLocation setHidden:YES];
    
    
    while ([[cell.viewControls subviews] count] > 0) {
        [[[cell.viewControls subviews] lastObject] removeFromSuperview];
    }
    
    // add controls
    
    CGFloat buttonWidth = cell.contentView.frame.size.width; //divide per control
    
    CustomButton *buttonGroup = [[CustomButton alloc] initWithText:[newsItem.group_name capitalizedString] image:[UIImage imageNamed:@"group-icon-small"] frame:CGRectMake(0.0f, 0.0f, buttonWidth, 25.0f)];
    buttonGroup.labelText.textColor = [UIColor grayColor];
    
    [cell.viewControls addSubview:buttonGroup];
    
    
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    EventsDetailViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsDetail"];
    detailsVC.showRegisterCell = NO;
    
//    NewsItem *newsItem = (NewsItem*)[self.news_list objectAtIndex:[indexPath row]];
    NewsObject *newsItem = (NewsObject*)[self.news_list objectAtIndex:[indexPath row]];
    
    detailsVC.titleText = newsItem.title;
    detailsVC.dateText = newsItem.created_date;
    detailsVC.detailDescription = newsItem.description_detail;
//    detailsVC.imageURL = newsItem.image;
    detailsVC.imageURL = newsItem.image_url;
    
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [detailsVC.view.layer addAnimation:transition forKey:nil];
    
    
    detailsVC.view.frame = self.view.bounds;
    [[self.view superview] addSubview:detailsVC.view];
    [[self parentViewController] addChildViewController:detailsVC];
    [detailsVC didMoveToParentViewController:[self parentViewController]];
    
    
    
    
//    if ([indexPath isEqual:self.indexPath_expanded]) {
//        self.indexPath_expanded = [NSIndexPath indexPathForRow:-1 inSection:-1];
//    }
//    else {
//        self.indexPath_expanded = indexPath;
//    }
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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


- (NSString*) getTimepassedTextFrom:(NSString*)date {
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:@"yyyy-MM-dd"];
    NSDate *postDate = [dF dateFromString:date];
    
    //wrong time!
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSString *today = [dF stringFromDate:[NSDate date]];
    NSDate *d1 = [dF dateFromString:today];
    NSDateComponents *components = [c components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:postDate toDate:d1 options:0];
    
    NSInteger days = components.day;
    NSInteger hours = components.hour;
    NSInteger minutes = components.minute;
    NSInteger seconds = components.second;
//    NSLog(@"(%@)date:%@ [%li:%li:%li:%li]",date,postDate,(long)days,(long)hours,(long)minutes,(long)seconds);
    
    NSString *text = @"";
    if (days > 6) {
        text = date;
    }
    else {
        if (days > 0) {
            if (days == 1) {
                text = @"1 day ago";
            }
            else {
                text = [NSString stringWithFormat:@"%li days ago",(long)days];
            }
        }
        else if (hours > 0 && hours < 24) {
            
            if (hours == 1) {
                text = @"1 hour ago";
            }
            else {
                text = [NSString stringWithFormat:@"%li hours ago",(long)hours];
            }
        }
        else if (minutes > 0 && minutes < 60) {
            
            if (minutes == 1) {
                text = @"1 minute ago";
            }
            else {
                text = [NSString stringWithFormat:@"%li minutes ago",(long)minutes];
            }
        }
        else if (seconds > 0 && seconds < 60) {
            
            if (seconds == 1) {
                text = @"1 second ago";
            }
            else {
                text = [NSString stringWithFormat:@"%li seconds ago",(long)seconds];
            }
        }
    }
    
    
    return text;
}


#pragma mark NewsCellDelagate

- (void)buttonDatePressed:(NSIndexPath *)indexPath {
    
}

- (void)buttonLocationPressed:(NSIndexPath *)indexPath {
    
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapsVC"];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.3;
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
}

@end
