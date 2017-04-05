//
//  PodDetailAudioTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodDetailAudioTableViewCell.h"

@interface PodDetailAudioTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (assign, nonatomic) BOOL isRepeatEnabled;

@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;
@end

@implementation PodDetailAudioTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(podcastPaused2:) name:@"obs_podcast_pause2" object:nil];
    self.isRepeatEnabled = NO;
//    self.audioPlayer = [[YMCAudioPlayer alloc] init];
//    [self setupAudioPlayer:self.urlForAudio];
    
    self.duration.text = @"--:--";
    
    self.currentTimeSlider.value = 0.0f;
}

- (void)initAudioPlayer
{
    NSString *urlString = [NSString stringWithFormat:@"http://%@",[[self.urlForAudio substringFromIndex:7] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    NSError *error = nil;
    NSData *soundData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES) objectAtIndex:0]
                          stringByAppendingPathComponent:@"sound"];
    BOOL success = [soundData writeToFile:filePath atomically:YES];
    
//    if (success) {
//        NSLog(@"[%@]\nsuccess !!!%@",url,soundData);
//    }
//    else {
//        NSLog(@"[%@]\n (%@)failed !!!%@",url,[error description],soundData);
//    }
    
    [self.audioPlayer initPlayer:[[url lastPathComponent] stringByDeletingPathExtension] fileExtension:[[url lastPathComponent] pathExtension]];
    
    
//    NSLog(@"URL-AUDIO:%@",self.urlForAudio);
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    self.duration.text = [NSString stringWithFormat:@"0:00 / %@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}


- (void)setupAudioPlayer:(NSString*)fileName
{
//    //insert Filename & FileExtension
//    NSString *fileExtension = @"mp3";
//    
//    //init the Player to get file properties to set the time labels
//    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
    
    [self.audioPlayer initPlayerFromURL:self.urlForAudio];
    
    
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    self.duration.text = [NSString stringWithFormat:@"0:00 / %@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}

- (IBAction)playAudioPressed:(id)playButton
{
        
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        
        self.isPaused = YES;
        
        [self.playButton setImage:[UIImage imageNamed:@"pause"]
                         forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        if (self.audioStreamerPlayer) {
            [self.audioStreamerPlayer play];
            return;
        }
        
        NSString *urlString = [NSString stringWithFormat:@"http://%@",[[self.urlForAudio substringFromIndex:7] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]]];
        NSURL *url = [NSURL URLWithString:urlString];
        
        
        // stremar player
        AVPlayer *player = [[AVPlayer alloc]initWithURL:url];
        self.audioStreamerPlayer= player;
        [self.audioStreamerPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
        
        
//        [self.audioPlayer playAudio];
//        
//        [self.delegate audioIsPlaying];
        
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
//        [self.audioPlayer pauseAudio];
        [self.audioStreamerPlayer pause];
        self.isPaused = NO;
    }
}
- (IBAction)replayAudioPressed:(id)sender {
    self.isRepeatEnabled = !self.isRepeatEnabled;
    
    [self.replayButton setImage:[UIImage imageNamed:(self.isRepeatEnabled)?@"replay-selected":@"replay"]
                       forState:UIControlStateNormal];
}

- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
//        NSLog(@"time:%f",CMTimeGetSeconds(self.audioStreamerPlayer.currentItem.currentTime));
        self.currentTimeSlider.value = CMTimeGetSeconds(self.audioStreamerPlayer.currentItem.currentTime);
    }
    
//    NSLog(@"time:%f",CMTimeGetSeconds(self.audioStreamerPlayer.currentItem.currentTime));
    
//    self.duration.text = [NSString stringWithFormat:@"%@",[self.audioPlayer timeFormat:CMTimeGetSeconds(self.audioStreamerPlayer.currentItem.currentTime)]];
    
//    self.duration.text = [NSString stringWithFormat:@"%@ / %@",[self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]],
//                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
//    //When resetted/ended reset the playButton
//    if (![self.audioPlayer isPlaying]) {
//        [self.playButton setImage:[UIImage imageNamed:@"play.png"]
//                                   forState:UIControlStateNormal];
//        [self.audioPlayer pauseAudio];
//        self.isPaused = NO;
//        
//        if (self.isRepeatEnabled) {
//            [self playAudioPressed:self.playButton];
//        }
//    }
    
}

- (IBAction)setCurrentTime:(id)scrubber {
    self.scrubbing = NO;
}

/*
 * Sets if the user is scrubbing right now
 * to avoid slider update while dragging the slider
 */
- (IBAction)userIsScrubbing:(id)sender {
    self.scrubbing = YES;
    //if scrubbing update the timestate, call updateTime faster not to wait a second and dont repeat it
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
    
    [self.audioStreamerPlayer seekToTime:CMTimeMakeWithSeconds(self.currentTimeSlider.value, 10)];
    
//    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)podcastPaused2:(NSNotification*)notification{
    [self.audioPlayer pauseAudio];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == self.audioStreamerPlayer && [keyPath isEqualToString:@"status"]) {
        if (self.audioStreamerPlayer.status == AVPlayerStatusFailed)
        {
            //  //NSLog(@"AVPlayer Failed");
        }
        else if (self.audioStreamerPlayer.status == AVPlayerStatusReadyToPlay)
        {
            [self.audioStreamerPlayer play];
            
            [self.audioStreamerPlayer.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
            
            
            self.duration.text = @"--:--";
            
            self.currentTimeSlider.value = 0.0f;
            
//            NSLog(@"range:%@\n\n%@",self.audioStreamerPlayer.currentItem.tracks, self.audioStreamerPlayer.currentItem.seekableTimeRanges);
            
//            NSLog(@"playable:%f",[self playableDuration]);
            
//            CMTimeRange timeRange = ([self.audioStreamerPlayer.currentItem loadedTimeRanges][0]).CMTimeRangeValue;
//            
//            
//            CGFloat duration = CMTimeGetSeconds(timeRange.duration);
//            
//            NSLog(@"time:%@",[self.audioPlayer timeFormat:self.audioStreamerPlayer.currentItem.preferredForwardBufferDuration]);
//
//            self.currentTimeSlider.maximumValue = duration;
//            
//            self.duration.text = [NSString stringWithFormat:@"0:00 / %@",
//                                  [self.audioPlayer timeFormat:duration]];
        }
        else if (self.audioStreamerPlayer.status == AVPlayerItemStatusUnknown)
        {
            //  //NSLog(@"AVPlayer Unknown");
            
        }
    }
    else if (object == self.audioStreamerPlayer.currentItem && [keyPath isEqualToString:@"status"]) {
        if (self.audioStreamerPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            
//            NSLog(@"##time:%f",CMTimeGetSeconds([[[self.audioStreamerPlayer currentItem] asset] duration]));
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
//    self.scrubbing = NO;
//    self.isPaused = NO;
}

- (NSTimeInterval) playableDuration
{
    
    //  use loadedTimeRanges to compute playableDuration.
    AVPlayerItem * item = self.audioStreamerPlayer.currentItem;
    
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        NSArray * timeRangeArray = item.loadedTimeRanges;
        
        CMTimeRange aTimeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        
        double startTime = CMTimeGetSeconds(aTimeRange.start);
        double loadedDuration = CMTimeGetSeconds(aTimeRange.duration);
        
        // FIXME: shoule we sum up all sections to have a total playable duration,
        // or we just use first section as whole?
        
        NSLog(@"get time range, its start is %f seconds, its duration is %f seconds.", startTime, loadedDuration);
        
        
        return (NSTimeInterval)(startTime + loadedDuration);
    }
    else
    {
        return(CMTimeGetSeconds(kCMTimeInvalid));
    }
}

@end
