//
//  EventsDetailViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsDetailViewController.h"

@interface EventsDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageHeaderView;
//@property (weak, nonatomic) IBOutlet UIView *shareControlFooterView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableVIew;
@property (strong, nonatomic) UIView *header;
@property (strong, nonatomic) UIView *footer;
@end

@implementation EventsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.labelTitle.text = [self.titleText uppercaseString];
    self.labelTitle.adjustsFontSizeToFitWidth = YES;
    self.labelTitle.minimumScaleFactor = -0.6f;
    self.labelTitle.numberOfLines = 0;
    self.labelTitle.lineBreakMode = NSLineBreakByWordWrapping;
//    self.labelTitle.layer.borderWidth = 1.0f;
    
    [self.buttondate setTitle:[NSString stringWithFormat:@"  %@",[self.dateText uppercaseString]] forState:UIControlStateNormal];
    [self.buttonTime setTitle:[NSString stringWithFormat:@"  %@",[self.timeText uppercaseString]] forState:UIControlStateNormal];
    [self.buttonLocation setTitle:[NSString stringWithFormat:@"  %@",[self.locationName uppercaseString]] forState:UIControlStateNormal];
    self.buttonLocation.latitude = [NSNumber numberWithDouble:self.locationLatitude];
    self.buttonLocation.longitude = [NSNumber numberWithDouble:self.locationLongitude];
    self.buttonLocation.locationName = self.locationName;
    
//    self.buttondate.eventTitle = self.titleText;
//    self.buttondate.eventAddress = self.locationName;
//    self.buttondate.eventDate = self.dateText;
//    self.buttondate.eventTime = self.timeText;
//    
//    self.buttonTime.eventTitle = self.titleText;
//    self.buttonTime.eventAddress = self.locationName;
//    self.buttonTime.eventDate = self.dateText;
//    self.buttonTime.eventTime = self.timeText;
    
    self.buttonLocation.hidden = !self.showVenueDateTime;
    self.buttondate.hidden = !self.showVenueDateTime;
    self.buttonTime.hidden = !self.showVenueDateTime;
    self.viewForControls.hidden = !self.showVenueDateTime;
    
    // add controls
    
    CGFloat buttonWidth = (self.view.bounds.size.width - 10.0f)/3; //divide per control
    
    CustomButton *buttonLocation = [[CustomButton alloc] initWithText:[self.locationName uppercaseString] image:[UIImage imageNamed:@"pin-icon-small"] frame:CGRectMake(0.0f, 5.0f, buttonWidth, 22.0f) locked:NO];
    buttonLocation.labelText.textColor = TEAL_COLOR;
    buttonLocation.userInteractionEnabled = YES;
    buttonLocation.tag = 12;
    buttonLocation.button.latitude = [NSNumber numberWithDouble:self.locationLatitude];
    buttonLocation.button.longitude = [NSNumber numberWithDouble:self.locationLongitude];
    buttonLocation.button.locationName = self.locationName;
    [buttonLocation.button addTarget:self action:@selector(viewMapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewForControls addSubview:buttonLocation];
    
    
    CustomButton *buttonDate = [[CustomButton alloc] initWithText:[self.dateText uppercaseString] image:[UIImage imageNamed:@"calendar-icon-small"] frame:CGRectMake(buttonWidth, 5.0f, buttonWidth, 22.0f) locked:NO];
    buttonDate.labelText.textColor = TEAL_COLOR;
    buttonDate.userInteractionEnabled = YES;
    buttonLocation.tag = 13;
    buttonDate.button.eventTitle = self.titleText;
    buttonDate.button.eventAddress = self.locationName;
    buttonDate.button.eventDate = self.date_start;
//    buttonDate.button.eventTime = self.timeText;
    [self.viewForControls addSubview:buttonDate];
    
    CustomButton *buttonTime = [[CustomButton alloc] initWithText:[self.timeText uppercaseString] image:[UIImage imageNamed:@"time-icon-small"] frame:CGRectMake(buttonWidth + buttonWidth, 5.0f, buttonWidth, 22.0f) locked:NO];
    buttonTime.labelText.textColor = TEAL_COLOR;
    buttonTime.userInteractionEnabled = YES;
    buttonLocation.tag = 14;
    buttonTime.button.eventTitle = self.titleText;
    buttonTime.button.eventAddress = self.locationName;
    buttonTime.button.eventDate = self.date_start;
//    buttonTime.button.eventTime = self.timeText;
    [self.viewForControls addSubview:buttonTime];
    
    buttonDate.translatesAutoresizingMaskIntoConstraints = NO;
    buttonLocation.translatesAutoresizingMaskIntoConstraints = NO;
    buttonTime.translatesAutoresizingMaskIntoConstraints = NO;
    //layout
    
    UILayoutGuide *marginLayout = self.imageHeaderView.layoutMarginsGuide;
    
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonDate attribute:NSLayoutAttributeCenterXWithinMargins relatedBy:NSLayoutRelationEqual toItem:marginLayout attribute:NSLayoutAttributeCenterXWithinMargins multiplier:1.0 constant:-(buttonDate.frame.size.width/2)]];
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonDate attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:buttonLocation attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:buttonLocation.frame.size.width]];
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonTime attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:buttonDate attribute:NSLayoutAttributeLeadingMargin multiplier:1.0 constant:buttonDate.frame.size.width]];
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonDate attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5.0f]];
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonLocation attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:buttonDate attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0.0f]];
    
    [self.imageHeaderView addConstraint:[NSLayoutConstraint constraintWithItem:buttonTime attribute:NSLayoutAttributeBaseline relatedBy:NSLayoutRelationEqual toItem:buttonDate attribute:NSLayoutAttributeBaseline multiplier:1.0 constant:0.0f]];
    
    buttonDate.translatesAutoresizingMaskIntoConstraints = YES;
    buttonLocation.translatesAutoresizingMaskIntoConstraints = YES;
    buttonTime.translatesAutoresizingMaskIntoConstraints = YES;
    
    if (self.imageData) {
        self.imageView.image = [UIImage imageWithData:self.imageData];
    }
    else if ([self.imageURL length]) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,self.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.imageData = UIImageJPEGRepresentation(image, 100.0f);
        }];
        
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
    }
    
    self.header = self.imageHeaderView;
//    self.footer = self.shareControlFooterView;
    
    [self.imageHeaderView removeFromSuperview];
//    [self.shareControlFooterView removeFromSuperview];
    
    self.mainTableVIew.tableHeaderView = nil;
//    self.mainTableVIew.tableFooterView = nil;
    
    
    
    buttonDate.translatesAutoresizingMaskIntoConstraints = YES;
    buttonLocation.translatesAutoresizingMaskIntoConstraints = YES;
    buttonTime.translatesAutoresizingMaskIntoConstraints = YES;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
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
        return 3;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (!self.showVenueDateTime) {
        return self.header.frame.size.height - 40.0f;
    }
    return self.header.frame.size.height + 20.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    return self.header;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return self.shareControlFooterView.frame.size.height;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.shareControlFooterView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        
        CGSize maximumLabelSize = CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX);
        CGRect textRect = [self.detailDescription boundingRectWithSize:maximumLabelSize
                                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:14.0f]}
                                                 context:nil];
        
        CGSize contentSize = textRect.size;
        
        if (contentSize.height > 20.0f) {
            return 65.0f + (contentSize.height);
        }
        
        
        
        
        return 65.0f + (contentSize.height);
        
    }
    else if ([indexPath row] == 1 && self.showRegisterCell) {
        if (self.registerLink.length == 0) {
            return 40.0f;
        }
        return 100.0f;
        
    }
    return 65.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([indexPath row] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell"];
        
        UITextView *textView = (UITextView*)[cell viewWithTag:1];
        textView.text = self.detailDescription;
        textView.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        
                
    }
    else if ([indexPath row] == 1 && self.showRegisterCell) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];
        
        UIButton *button1 = (UIButton*)[cell viewWithTag:1];
        UIButton *button2 = (UIButton*)[cell viewWithTag:2];
        UIButton *button3 = (UIButton*)[cell viewWithTag:3];
        UIButton *button4 = (UIButton*)[cell viewWithTag:4];
        
        [button1 setTitle:[NSString stringWithFormat:@"  %@",[self.personName uppercaseString]] forState:UIControlStateNormal];
        [button2 setTitle:[NSString stringWithFormat:@"  %@",([self.personMobile uppercaseString])?:@"---"] forState:UIControlStateNormal];
        [button3 setTitle:[NSString stringWithFormat:@"  %@",([self.personEmail uppercaseString])?:@"---"] forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(callNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        [button3 addTarget:self action:@selector(mailAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.registerLink.length == 0) {
            button4.hidden = YES;
        }
        [button4 addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}





- (void) registerButtonTapped {
    
    if (self.registerLink.length == 0) {
        return;
    }
    
    
    if ([SFSafariViewController class]) {
        // Open the URL in SFSafariViewController (iOS 9+)
        SFSafariViewController* controller = [[SFSafariViewController alloc]
                                              initWithURL:[NSURL URLWithString:self.registerLink]];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        // Open the URL in the device's browser
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.registerLink]];
    }
}

@end
