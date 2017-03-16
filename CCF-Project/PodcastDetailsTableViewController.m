//
//  PodcastDetailsTableViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastDetailsTableViewController.h"
#import "PodDetailAudioTableViewCell.h"
#import "PodDetailImageTableViewCell.h"
#import "PodDetailDescriptionTableViewCell.h"
#import "PodDetailVideoTableViewCell.h"
#import "YMCAudioPlayer.h"

#define isNil(x) (x==nil)?@"":x

@interface PodcastDetailsTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelPodcastTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonSpeaker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayContents;

@property (strong, nonatomic) YMCAudioPlayer *audioPlayer;
@end

@implementation PodcastDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.buttonSpeaker setTitle:self.podcastSpeaker forState:UIControlStateNormal];
    self.labelPodcastTitle.text = self.podcastTitle;
    
    self.arrayContents = @[isNil(self.imageURL),isNil(self.podcastDescription),isNil(self.urlForAudio),isNil(self.youtubeID)];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.audioPlayer pauseAudio];
    [self.audioPlayer stopAudio];
    self.audioPlayer = nil;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger section = 2;
    if (self.urlForAudio) {
        section++;
    }
    if (self.youtubeID) {
        section++;
    }
    return section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch ([indexPath section]) {
        case 1:{
            UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 80.0f)];
            tv.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
            tv.font = [UIFont systemFontOfSize:14.0f];
            CGSize contentSize = [tv contentSize];
            
            if (contentSize.height > 80.0f) {
                return 80.0f + (contentSize.height - 80.0f);
            }
            
            return 80.0f;

            
        }
            break;
        case 2:
            height = (self.urlForAudio && [indexPath section]==2)?80.0f:240.0f;
            break;
        case 3:
            height = 300.0f;
            break;
            
        default:
            height = 140.0f;
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    return 35.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == [self numberOfSectionsInTableView:tableView] ) {
        return 45.0f;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    
    UIView *viewHeader = [self generateViewHeaderForSection:section];
    viewHeader.tag = section;
    UITapGestureRecognizer *tapScrollTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollSectionToTop:)];
    [viewHeader addGestureRecognizer:tapScrollTop];
    return viewHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch ([indexPath section]) {
        case 1:{
            PodDetailDescriptionTableViewCell *custom = (PodDetailDescriptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"descriptionCell" forIndexPath:indexPath];
            custom.podcastDescription.text = self.podcastDescription;
            cell = custom;
        }
            break;
        case 2:{
            if (self.urlForAudio) {
                PodDetailAudioTableViewCell *custom = (PodDetailAudioTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"audioCell" forIndexPath:indexPath];
                custom.urlForAudio = self.urlForAudio;
                self.audioPlayer = custom.audioPlayer;
                cell = custom;
            }
            else {
                PodDetailVideoTableViewCell *custom = (PodDetailVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
                custom.youtubeID = self.youtubeID;
                cell = custom;
            }
        }
            break;
        case 3:{
            PodDetailVideoTableViewCell *custom = (PodDetailVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"videoCell" forIndexPath:indexPath];
            custom.youtubeID = self.youtubeID;
            cell = custom;
        }
            break;
        default:{
            PodDetailImageTableViewCell *custom = (PodDetailImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"imageCell" forIndexPath:indexPath];
//            custom.podcastImage.image = self.image;
            cell = custom;
        }
            break;
    }
    
    return cell;
}


- (UIView*)generateViewHeaderForSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, [self tableView:self.tableView heightForHeaderInSection:section])];
    
    if (section == 2 || section == 3) {
        view.backgroundColor = [UIColor colorWithRed:17.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];

//        UIImage *image = [UIImage imageNamed:(self.urlForAudio && section==2)?@"listenbar":@"watchbar"];
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.frame = CGRectMake(0.0f, 0.0f, view.bounds.size.width, view.bounds.size.height);
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        
//        [view addSubview:imageView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 56.0f, 24.0f)];
        imageView.image = [UIImage imageNamed:(self.urlForAudio && section==2)?@"listen":@"watch"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 24.0f)];
        label.text = (self.urlForAudio && section==2)?@"LISTEN":@"WATCH";
        label.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
        label.textColor = [UIColor whiteColor];
        
        [view addSubview:imageView];
        [view addSubview:label];
        
        //layout
        
        UILayoutGuide *marginLayout = view.layoutMarginsGuide;
        
        [view addConstraint:[imageView.leadingAnchor constraintEqualToAnchor:marginLayout.leadingAnchor constant:20.0f]];
        
        [view addConstraint:[imageView.centerYAnchor constraintEqualToAnchor:marginLayout.centerYAnchor]];
        
        [view addConstraint:[label.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor]];
        
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeWidth multiplier:0.8f constant:0.0f]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:15.0f]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
        [view addConstraint:[label.trailingAnchor constraintEqualToAnchor:marginLayout.trailingAnchor constant:20.0f]];
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        label.translatesAutoresizingMaskIntoConstraints = NO;
    }
    else if (section == 1){
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 24.0f, 24.0f)];
        imageView.image = [UIImage imageNamed:@"person"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 24.0f)];
        label.text = (self.otherText.length>0)?self.otherText:@"JESUS UNBOXED";
        label.textColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
        label.font = [UIFont fontWithName:@"OpenSans" size:14.0f];
        
        [view addSubview:imageView];
        [view addSubview:label];
        
        UIButton *buttonDownload = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonDownload.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
        buttonDownload.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [buttonDownload setTitle:@"DOWNLOAD" forState:UIControlStateNormal];
        [buttonDownload setFrame:CGRectMake(0.0f, 0.0f, 120.0f, 24.0f)];
        
        
        UIButton *buttonRead = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonRead.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
        buttonRead.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [buttonRead setTitle:@"READ" forState:UIControlStateNormal];
        [buttonRead setFrame:CGRectMake(0.0f, 0.0f, 50.0f, 24.0f)];
        
        [view addSubview:buttonDownload];
//        [view addSubview:buttonRead];
        
        //layout
        
        UILayoutGuide *marginLayout = view.layoutMarginsGuide;
        
        [view addConstraint:[imageView.leadingAnchor constraintEqualToAnchor:marginLayout.leadingAnchor constant:12.0f]];
        
        [view addConstraint:[imageView.centerYAnchor constraintEqualToAnchor:marginLayout.centerYAnchor]];
        
        [view addConstraint:[label.centerYAnchor constraintEqualToAnchor:marginLayout.centerYAnchor]];
        
        [view addConstraint:[buttonDownload.centerYAnchor constraintEqualToAnchor:marginLayout.centerYAnchor]];
        
//        [view addConstraint:[buttonRead.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor]];
        
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
        [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0f]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonDownload attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:label attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0f]];
        
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonRead attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonDownload attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10.0f]];
        
        [label addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
        
        [buttonDownload addConstraint:[NSLayoutConstraint constraintWithItem:buttonDownload attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
//        [buttonRead addConstraint:[NSLayoutConstraint constraintWithItem:buttonRead attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:24.0f]];
        
        
        [buttonDownload addConstraint:[NSLayoutConstraint constraintWithItem:buttonDownload attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:120.0f]];
        
        
//        [buttonRead addConstraint:[NSLayoutConstraint constraintWithItem:buttonRead attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:50.0f]];
        
        
        [view addConstraint:[buttonDownload.trailingAnchor constraintEqualToAnchor:marginLayout.trailingAnchor constant:-12.0f]];
        
//        [view addConstraint:[buttonRead.trailingAnchor constraintEqualToAnchor:marginLayout.trailingAnchor constant:-12.0f]];
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        label.translatesAutoresizingMaskIntoConstraints = NO;
//        buttonRead.translatesAutoresizingMaskIntoConstraints = NO;
        buttonDownload.translatesAutoresizingMaskIntoConstraints = NO;
    }
    else {
        
//        view.backgroundColor = [UIColor whiteColor];
//        
//        UIButton *buttonBack = [UIButton buttonWithType:UIButtonTypeCustom];
//        [buttonBack setImage:[UIImage imageNamed:@"back-button"] forState:UIControlStateNormal];
//        [buttonBack setFrame:CGRectMake(0.0f, 0.0f, 44.0f, 44.0f)];
//        [buttonBack addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [view addSubview:buttonBack];
//        
//        
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 32.0f)];
//        titleLabel.textColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
//        titleLabel.font = [UIFont systemFontOfSize:24.0f];
//        titleLabel.text = self.podcastTitle;
//        
//        [view addSubview:titleLabel];
//        
//        UIButton *speakerName = [UIButton buttonWithType:UIButtonTypeCustom];
//        speakerName.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//        [speakerName setTitle:[NSString stringWithFormat:@"  %@",self.podcastSpeaker] forState:UIControlStateNormal];
//        [speakerName setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [speakerName setImage:[UIImage imageNamed:@"pin"] forState:UIControlStateNormal];
//        [speakerName setFrame:CGRectMake(0.0f, 0.0f, 120.0f, 16.0f)];
//        speakerName.userInteractionEnabled = NO;
//        speakerName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        
//        [view addSubview:speakerName];
//        
//        
//        UIButton *buttonFB = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttonFB.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
//        [buttonFB setTitle:@"FB" forState:UIControlStateNormal];
//        [buttonFB setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
//        
//        UIButton *buttonYT = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttonYT.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
//        [buttonYT setTitle:@"YT" forState:UIControlStateNormal];
//        [buttonYT setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
//        
//        UIButton *buttonGP = [UIButton buttonWithType:UIButtonTypeCustom];
//        buttonGP.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:179.0f/255.0f blue:196/255.0f alpha:1.0f];
//        [buttonGP setTitle:@"GP" forState:UIControlStateNormal];
//        [buttonGP setFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
//        
//        [view addSubview:buttonFB];
//        [view addSubview:buttonYT];
//        [view addSubview:buttonGP];
//        
//        
//        //layout
//        
//        UILayoutGuide *marginLayout = view.layoutMarginsGuide;
//        
//        
//        [view addConstraint:[buttonBack.leadingAnchor constraintEqualToAnchor:marginLayout.leadingAnchor constant:0.0f]];
//        [view addConstraint:[buttonBack.centerYAnchor constraintEqualToAnchor:marginLayout.centerYAnchor]];
//        [buttonBack addConstraint:[NSLayoutConstraint constraintWithItem:buttonBack attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:44.0f]];
//        [buttonBack addConstraint:[NSLayoutConstraint constraintWithItem:buttonBack attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:44.0f]];
//        
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonBack attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0f]];
//        [view addConstraint:[titleLabel.trailingAnchor constraintEqualToAnchor:marginLayout.trailingAnchor constant:-8.0f]];
//        [view addConstraint:[titleLabel.topAnchor constraintEqualToAnchor:marginLayout.topAnchor constant:0.0f]];
//        
//        [titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:32.0f]];
//        
//        [view addConstraint:[speakerName.leadingAnchor constraintEqualToAnchor:titleLabel.leadingAnchor constant:0.0f]];
//        [view addConstraint:[speakerName.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:0.0f]];
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonFB attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:speakerName attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0f]];
//        
//        [speakerName addConstraint:[NSLayoutConstraint constraintWithItem:speakerName attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:16.0f]];
//        
//        
//        [view addConstraint:[buttonGP.trailingAnchor constraintEqualToAnchor:marginLayout.trailingAnchor]];
//        [view addConstraint:[buttonGP.centerYAnchor constraintEqualToAnchor:buttonYT.centerYAnchor]];
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonGP attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonYT attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0f]];
//        
//        [buttonGP addConstraint:[NSLayoutConstraint constraintWithItem:buttonGP attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:30.0f]];
//        
//        [buttonGP addConstraint:[NSLayoutConstraint constraintWithItem:buttonGP attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:30.0f]];
//        
//        
//        
//        [view addConstraint:[buttonYT.centerYAnchor constraintEqualToAnchor:buttonFB.centerYAnchor]];
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonYT attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonFB attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0f]];
//        
//        [buttonYT addConstraint:[NSLayoutConstraint constraintWithItem:buttonYT attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:30.0f]];
//        
//        [buttonYT addConstraint:[NSLayoutConstraint constraintWithItem:buttonYT attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:30.0f]];
//        
//        
//        
//        [view addConstraint:[buttonFB.centerYAnchor constraintEqualToAnchor:speakerName.centerYAnchor]];
//        [view addConstraint:[NSLayoutConstraint constraintWithItem:buttonFB attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:speakerName attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0f]];
//        
//        [buttonFB addConstraint:[NSLayoutConstraint constraintWithItem:buttonFB attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:0.0f constant:30.0f]];
//        
//        [buttonFB addConstraint:[NSLayoutConstraint constraintWithItem:buttonFB attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:0.0f constant:30.0f]];
//        
//        
//        
//        buttonBack.translatesAutoresizingMaskIntoConstraints = NO;
//        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//        speakerName.translatesAutoresizingMaskIntoConstraints = NO;
//        buttonFB.translatesAutoresizingMaskIntoConstraints = NO;
//        buttonYT.translatesAutoresizingMaskIntoConstraints = NO;
//        buttonGP.translatesAutoresizingMaskIntoConstraints = NO;
        
    }
   
//    36,179,196
    
    return view;
}

- (void)scrollSectionToTop:(UITapGestureRecognizer*)gesture {
    NSInteger section = gesture.view.tag;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) backButtonPressed  {
    
    UIView *viewShown = [((NSArray*)self.parentViewController.view.subviews) lastObject];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.parentViewController.view.layer addAnimation:transition forKey:nil];
    
    [viewShown removeFromSuperview];
    
    [self removeFromParentViewController];
}

@end
