//
//  LiveStreamingViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 30/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "LiveStreamingViewController.h"

@interface LiveStreamingViewController ()
@property (weak, nonatomic) IBOutlet YTPlayerView *youtubePlayerView;
@property (weak, nonatomic) IBOutlet UILabel *labelTimer;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *viewMain;

@property (assign, nonatomic) NSInteger shownPerPage;
@property (weak, nonatomic) IBOutlet UIButton *buttonFacebook;

@end

@implementation LiveStreamingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(podcastPaused1:) name:@"obs_podcast_pause1" object:nil];
    self.shownPerPage = 0;
    
//    NETWORK_INDICATOR(YES)
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callLiveStreamData:) name:kOBS_LIVESTREAM_NOTIFICATION object:nil];
    
    [self callGETAPI:kLIVESTREAM_LINK withParameters:nil completionNotification:kOBS_LIVESTREAM_NOTIFICATION];
    
    
//    [self.youtubePlayerView loadWithVideoId:@"qzMQza8xZCc"];
    
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        
//        
//    }];
    
    
    if (self.buttonFacebook.frame.origin.y + self.buttonFacebook.frame.size.height + 20.0f > self.view.frame.size.height) {
        
        self.mainScrollView.contentSize = CGSizeMake(0.0f, self.view.frame.size.height + 10.0f);
    }
    

    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    [timer fire];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_podcast_pause1" object:nil];
}

- (void)callLiveStreamData:(NSNotification*)notification {
//    NSLog(@"## result:%@",notification.object);
    
    NSDictionary *result = (NSDictionary*)notification.object;
    
    NSString *latest_videoID = result[@"latest"][@"id"][@"videoId"];
    
    
    [self.youtubePlayerView loadWithVideoId:latest_videoID];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOBS_LIVESTREAM_NOTIFICATION object:nil];
}

- (void) timerAction {
    
    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:@"yyyy-dd-MM  HH:mm:ss"];
    NSDate *streamDate = [dF dateFromString:@"2017-06-02  19:34:00"];
    
    //wrong time!
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];
    NSDateComponents *components = [c components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:d1 toDate:streamDate options:0];
    
    NSInteger days = components.day;
    NSInteger hours = components.hour;
    NSInteger minutes = components.minute;
    
    NSString *text = (days>0)?[NSString stringWithFormat:@"%li DAYS",(long)days]:@"";
    if (hours > 0) {
        text = [NSString stringWithFormat:@"%@%@%li HOURS",text,(days==0)?@"":(minutes==0)?@" AND ":@", ",(long)hours];
    }
    
    if (minutes > 0) {
        text = [NSString stringWithFormat:@"%@ AND %li MINUTES",text,(long)minutes];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.labelTimer.text = [NSString stringWithFormat:@"%@",text];
        if (self.labelTimer.text.length == 0) {
            self.labelTimer.text = @"STAY TUNED FOR OUR NEXT LIVE STREAM";
        }
        
    });
    
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    NSLog(@"view:%@ scroll:%@",NSStringFromCGSize(self.viewMain.frame.size),NSStringFromCGSize(self.mainScrollView.frame.size));
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void) timerCalled:(id)timer {
//    
//    NSDateFormatter *dF = [[NSDateFormatter alloc] init];
//    [dF setDateFormat:@"yyyy-dd-MM  HH:mm:ss"];
//    NSDate *streamDate = [dF dateFromString:@"2017-03-02  19:34:00"];
//
//    //wrong time!
//    
//    NSCalendar *c = [NSCalendar currentCalendar];
//    NSDate *d1 = [NSDate date];
//    NSDateComponents *components = [c components:NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:d1 toDate:streamDate options:0];
//    
//    NSInteger days = components.day;
//    NSInteger hours = components.hour;
//    NSInteger minutes = components.minute;
//    
//    
//    [self updateLabeltimer:days :hours :minutes];
//}
//
//
//- (void) updateLabeltimer:(NSInteger)days :(NSInteger)hours :(NSInteger)minutes {
//    
//    NSString *text = (days>0)?[NSString stringWithFormat:@"%li DAYS",(long)days]:@"";
//    if (hours > 0) {
//        text = [NSString stringWithFormat:@"%@%@%li HOURS",text,(days==0)?@"":(minutes==0)?@" AND ":@", ",(long)hours];
//    }
//    
//    if (minutes > 0) {
//        text = [NSString stringWithFormat:@"%@ AND %li MINUTES",text,(long)minutes];
//    }
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
////        NSLog(@"[%li,%li,%li]TEXT:%@",(long)days,(long)hours,(long)minutes,text);
//        self.labelTimer.text = [NSString stringWithFormat:@"%@",text];
//        
//    });
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"obs_progress" object:@NO];
}


- (void)podcastPaused1:(NSNotification*)notification{
    [self.youtubePlayerView pauseVideo];
}

@end
