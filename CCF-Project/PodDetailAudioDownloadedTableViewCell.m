//
//  PodDetailAudioDownloadedTableViewCell.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 04/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodDetailAudioDownloadedTableViewCell.h"

@interface PodDetailAudioDownloadedTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UISlider *currentTimeSlider;
@property (assign, nonatomic) BOOL isRepeatEnabled;

@property BOOL isPaused;
@property BOOL scrubbing;

@property NSTimer *timer;
@end

@implementation PodDetailAudioDownloadedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(podcastPaused3:) name:@"obs_podcast_pause3" object:nil];
    self.isRepeatEnabled = NO;
    self.audioPlayer = [[YMCAudioPlayer alloc] init];
    NSLog(@"self.audioFilePath:%@",self.audioFilePath);
    [self setupAudioPlayer:self.audioFilePath];
}


- (void)setupAudioPlayer:(NSString*)fileName
{
//    //insert Filename & FileExtension
//    NSString *fileExtension = @"mp3";
//    
//    //init the Player to get file properties to set the time labels
    
//    [self.audioPlayer initPlayer:[[NSString stringWithFormat:@"file://%@",[fileName substringFromIndex:5]] stringByDeletingPathExtension] fileExtension:[fileName pathExtension]];
    
//    [self.audioPlayer initPlayerFromURL:fileName];

    [self.audioPlayer initPlayerFromDocuments:fileName];
    
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    self.duration.text = [NSString stringWithFormat:@"0:00 / %@",
                          [self timeFormat:[self.audioPlayer getAudioDuration]]];
    
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
        
                
       [self.audioPlayer playAudio];
        
        
    } else {
        //player is paused and Button is pressed again
        [self.playButton setImage:[UIImage imageNamed:@"play"]
                                   forState:UIControlStateNormal];
        
        [self.audioPlayer pauseAudio];
        self.isPaused = NO;
    }
}
- (IBAction)replayAudioPressed:(id)sender {
    self.isRepeatEnabled = !self.isRepeatEnabled;
    
    [self.replayButton setImage:[UIImage imageNamed:(self.isRepeatEnabled)?@"replay-selected":@"replay"]
                       forState:UIControlStateNormal];
}

- (void)updateTime:(NSTimer *)timer {
    
//    [self observeValueForKeyPath:@"status" ofObject:self.audioStreamerPlayer change:nil context:nil];
    
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    
    
    self.currentTimeSlider.maximumValue = 1;
    
    if ([self.audioPlayer getAudioDuration]>0) {
        self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    }
    
    self.duration.text = [NSString stringWithFormat:@"%@ / %@",[self timeFormat:[self.audioPlayer getCurrentAudioTime]],
                          [self timeFormat:[self.audioPlayer getAudioDuration]]];

    
//    //When resetted/ended reset the playButton
    if ([self.audioPlayer getAudioDuration] == [self.audioPlayer getCurrentAudioTime]) {
        [self.playButton setImage:[UIImage imageNamed:@"play.png"]
                                   forState:UIControlStateNormal];
        [self.audioPlayer pauseAudio];
        self.isPaused = NO;
        
        if (self.isRepeatEnabled) {
            [self playAudioPressed:self.playButton];
        }
    }
    
}

- (IBAction)setCurrentTime:(id)scrubber {
    self.scrubbing = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(updateTime:)
                                   userInfo:nil
                                    repeats:NO];
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
    
    
    [self.audioPlayer setCurrentAudioTime:self.currentTimeSlider.value];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)podcastPaused3:(NSNotification*)notification{
    [self.audioPlayer pauseAudio];
        
    self.audioPlayer = nil;
}


-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
//    NSLog(@"time:%@",time);
    return time;
}


@end
