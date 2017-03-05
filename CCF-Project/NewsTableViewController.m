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
#import <EventKit/EventKit.h>
#import "EventsDetailViewController.h"

@interface NewsTableViewController () <NewsCellDelegate>

//@property (strong, nonatomic) NSIndexPath *indexPath_expanded;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (strong, nonatomic) EKCalendar *calendar;

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.indexPath_expanded = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([indexPath isEqual:self.indexPath_expanded]) {
//        
//        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 40.0f)];
//        tv.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
//        tv.font = [UIFont systemFontOfSize:14.0f];
//        CGSize contentSize = [tv contentSize];
//        
//        if (contentSize.height > 40.0f) {
//            return 165 + (contentSize.height - 40.0f);
//        }
//        
//    }
    return 165.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsCollapsedTableViewCell *cell = (NewsCollapsedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    
    cell.labelNewsTitle.text = @"YOUTH GATHERING";
    cell.labelTimeCreated.text = @"1hr ago";
    cell.textNewsDetails.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    [cell.textNewsDetails scrollsToTop];
    
    [cell.buttonGroupName setTitle:@"  YOUTH GROUP" forState:UIControlStateNormal];
    [cell.buttonLocation setTitle:@"  CCF CHURCH" forState:UIControlStateNormal];
    [cell.buttonDate setTitle:@"  NOVEMBER 5" forState:UIControlStateNormal];
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    EventsDetailViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsDetail"];
    detailsVC.showRegisterCell = NO;
    
    
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

#pragma mark NewsCellDelagate

- (void)buttonDatePressed:(NSIndexPath *)indexPath {
    
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    event.title = [NSString stringWithFormat:@"%@",@"YOUTH GATHERING"];
    
    NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc] init];
    [dateFormmatter setDateFormat:@"MM/dd/yyyy"];
    
    event.startDate = [dateFormmatter dateFromString:@"11/05/2017"];
    event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
    event.calendar = [self.eventStore defaultCalendarForNewEvents];
    event.notes = [NSString stringWithFormat:@"Event Details:\nAddress:%@\n",@"CCF CHURCH"];
    NSTimeInterval aInterval = -1 * 60 * 60;
    EKAlarm *alaram = [EKAlarm alarmWithRelativeOffset:aInterval];
    [event addAlarm:alaram];
    
    NSError *err = nil;
    BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
    
    if (success) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Success" message:@"YOUTH GATHERING saved in calendar" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:close];
        [self presentViewController:ac animated:YES completion:^{
            
        }];
    }
    else {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Error" message:@"YOUTH GATHERING failed to saved in calendar.\nPlease allow the app to save in calendar." preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:close];
        [self presentViewController:ac animated:YES completion:^{
            
        }];
    }
}

- (void)buttonLocationPressed:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapsVC"];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [mapVC.view.layer addAnimation:transition forKey:nil];
    
    
    mapVC.view.frame = self.view.bounds;
    [self.view addSubview:mapVC.view];
    [self addChildViewController:mapVC];
    [mapVC didMoveToParentViewController:self];
}

@end
