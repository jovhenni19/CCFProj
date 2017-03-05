//
//  EventsDetailViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsDetailViewController.h"

@interface EventsDetailViewController ()

@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showRegisterCell) {
        return 2;
    }
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 40.0f)];
        tv.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        
        tv.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        CGSize contentSize = [tv contentSize];
        
        if (contentSize.height > 40.0f) {
            return 165 + (contentSize.height - 40.0f);
        }
        
    }
    return 115.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([indexPath row] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell"];
        
        UITextView *textView = (UITextView*)[cell viewWithTag:1];
        textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
        
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];
        
        UIButton *button1 = (UIButton*)[cell viewWithTag:1];
        UIButton *button2 = (UIButton*)[cell viewWithTag:2];
        UIButton *button3 = (UIButton*)[cell viewWithTag:3];
        UIButton *button4 = (UIButton*)[cell viewWithTag:4];
        
        [button2 addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [button4 addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}





- (void) registerButtonTapped {
    NSLog(@" ################## REGISTER BUTTON ################## ");
}

@end
