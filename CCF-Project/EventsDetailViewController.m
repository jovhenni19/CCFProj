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
    
    self.labelTitle.text = self.titleText;
    [self.buttondate setTitle:[NSString stringWithFormat:@"  %@",self.dateText] forState:UIControlStateNormal];
    [self.buttonTime setTitle:[NSString stringWithFormat:@"  %@",self.timeText] forState:UIControlStateNormal];
    [self.buttonLocation setTitle:[NSString stringWithFormat:@"  %@",self.locationName] forState:UIControlStateNormal];
    self.buttonLocation.latitude = [NSNumber numberWithDouble:self.locationLatitude];
    self.buttonLocation.longitude = [NSNumber numberWithDouble:self.locationLongitude];
    self.buttonLocation.locationName = self.locationName;
    
    
    if (self.imageData) {
        self.imageView.image = [UIImage imageWithData:self.imageData];
    }
    else if ([self.imageURL length]) {
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/image/%@",kAPI_LINK,self.imageURL]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.imageData = UIImageJPEGRepresentation(image, 100.0f);
        }];
        
        
//        [self getImageFromURL:self.imageURL completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//            
//            UIImage *image = (UIImage*)responseObject;
//            
//            [self.imageView setImage:image];
//            
//        } andProgress:^(NSInteger expectedBytesToReceive, NSInteger receivedBytes) {
//            
//        }];
    }
    else {
        self.imageView.image = [UIImage imageNamed:@"placeholder"];
    }
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
        
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, 20.0f)];
        tv.text = self.detailDescription;
        
        tv.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        CGSize contentSize = [tv contentSize];
        
        if (contentSize.height > 20.0f) {
            return 165 + (contentSize.height - 20.0f);
        }
        
    }
    return 115.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if ([indexPath row] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailsCell"];
        
        UITextView *textView = (UITextView*)[cell viewWithTag:1];
        textView.text = self.detailDescription;
        
    }
    else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"registerCell"];
        
        UIButton *button1 = (UIButton*)[cell viewWithTag:1];
        UIButton *button2 = (UIButton*)[cell viewWithTag:2];
        UIButton *button3 = (UIButton*)[cell viewWithTag:3];
        UIButton *button4 = (UIButton*)[cell viewWithTag:4];
        
        [button1 setTitle:[NSString stringWithFormat:@"  %@",self.personName] forState:UIControlStateNormal];
        [button2 setTitle:[NSString stringWithFormat:@"  %@",(self.personMobile)?:@"---"] forState:UIControlStateNormal];
        [button3 setTitle:[NSString stringWithFormat:@"  %@",(self.personEmail)?:@"---"] forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(callNumber:) forControlEvents:UIControlEventTouchUpInside];
        
        [button3 addTarget:self action:@selector(mailAddress:) forControlEvents:UIControlEventTouchUpInside];
        
        [button4 addTarget:self action:@selector(registerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
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
