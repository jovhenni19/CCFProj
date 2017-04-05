//
//  SettingsTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *groupList;
@property (assign, nonatomic) BOOL allIsOn;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
//    NETWORK_INDICATOR(YES)
    
    
    
    
    self.allIsOn = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callGroupsData:) name:kOBS_GROUPS_NOTIFICATION object:nil];
    
    [self callGETAPI:kGROUPS_LINK withParameters:nil completionNotification:kOBS_GROUPS_NOTIFICATION];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)callGroupsData:(NSNotification*)notification {
//    NSLog(@"## result:%@",notification.object);
    
    
//    NETWORK_INDICATOR(NO)
    
    if(!self.groupList){
        self.groupList = [NSMutableArray array];
    }
    
    
    NSDictionary *result = [NSDictionary dictionaryWithDictionary:notification.object];
    
    NSArray *data = result[@"data"];
    
//    [self showLoadingAnimation:self.view withTotalCount:data.count];
    for (NSDictionary *item in data) {
        [self.groupList addObject:item];
        
        
        
        NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
        
        BOOL switchValue = [[NSUserDefaults standardUserDefaults] boolForKey:valueKey];
        
        if (switchValue) {
            self.allIsOn = NO;
        }
    }
    
//    [self.mainTableView reloadData];
//    [self removeLoadingAnimation];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 1;
    }
    
    return self.groupList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"all:%@",self.allIsOn?@"YES":@"NO");
    if ([indexPath section] == 2) {
        if (self.allIsOn) {
            return 0.0f;
        }
    }
    return 44.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *identifier = @"cellSetting";
    if ([indexPath section] == 0) {
        identifier = @"cellSettingPush";
    }
    else if ([indexPath section] == 1) {
        identifier = @"cellSettingAll";
    }
    else {
        identifier = @"cellSetting";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
    if ([indexPath section] == 0) {
        
        
        
        // Configure the cell...
        
        UILabel *label = [cell.contentView viewWithTag:1];
        UISwitch *switchControl = [cell.contentView viewWithTag:2];
        label.text = @"Push Notification";
        
        BOOL pushNotification_ON = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
        
        [switchControl addTarget:self action:@selector(changePushValue:) forControlEvents:UIControlEventValueChanged];
        [switchControl setOn:pushNotification_ON];
        
    }
    else if ([indexPath section] == 1) {
        
        
        
        // Configure the cell...
        
        UILabel *label = [cell.contentView viewWithTag:1];
        UISwitch *switchControl = [cell.contentView viewWithTag:2];
        
        label.text = @"All Groups";
        
        [switchControl addTarget:self action:@selector(changeAllGroupsValue:) forControlEvents:UIControlEventValueChanged];
        [switchControl setOn:self.allIsOn];
    }
    else {
        
        
        NSDictionary *item = self.groupList[[indexPath row]];
        
        
        
        // Configure the cell...
        
        UILabel *label = [cell.contentView viewWithTag:1];
        UISwitch *switchControl = [cell.contentView viewWithTag:10];
        
        label.text = item[@"name"];
//        switchControl.tag = [indexPath row];
        
        [switchControl addTarget:self action:@selector(changeSwitchValue:) forControlEvents:UIControlEventValueChanged];
        
        NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
        
        BOOL switchValue = [[NSUserDefaults standardUserDefaults] boolForKey:valueKey];
        
        [switchControl setOn:switchValue];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2 && !self.allIsOn) {
        return @"Groups";
    }
    return nil;
}

- (void) changePushValue:(UISwitch*)sender {
    if ([sender isOn]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void) changeAllGroupsValue:(UISwitch*)sender {
    
    if ([sender isOn]) {
        self.allIsOn = YES;
        
        for (NSDictionary *item in self.groupList) {
            
            NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:valueKey];
        }
    }
    else {
        self.allIsOn = NO;
    }
    
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
}

- (void) changeSwitchValue:(UISwitch*)sender {
    
    CGPoint pointInTable = [sender convertPoint:sender.bounds.origin toView:self.mainTableView];
    
    NSIndexPath *indexPath = [self.mainTableView indexPathForRowAtPoint:pointInTable];
    
    NSDictionary *item = self.groupList[[indexPath row]];
    
    NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:valueKey];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:valueKey];
    }
    
    self.allIsOn = [self isAllGroupEnabled];
    if (self.allIsOn) {
        
        for (NSDictionary *item in self.groupList) {
            
            NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:valueKey];
        }
    }
    
    [self.mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    [self.mainTableView reloadData];
}

- (BOOL) isAllGroupEnabled {
    BOOL enabled = NO;
    for (NSDictionary *item in self.groupList) {
        
        NSString *valueKey = [NSString stringWithFormat:@"groups_%@_key",item[@"id"]];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:valueKey]) {
            enabled = NO;
            break;
        }
        enabled = YES;
    }
    
    return enabled;
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

@end
