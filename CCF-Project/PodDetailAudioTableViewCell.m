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
    
    self.isRepeatEnabled = NO;
    self.audioPlayer = [[YMCAudioPlayer alloc] init];
    [self setupAudioPlayer:self.urlForAudio];
}

- (void)setupAudioPlayer:(NSString*)fileName
{
    //insert Filename & FileExtension
    NSString *fileExtension = @"mp3";
    
    //init the Player to get file properties to set the time labels
    [self.audioPlayer initPlayer:fileName fileExtension:fileExtension];
    self.currentTimeSlider.maximumValue = [self.audioPlayer getAudioDuration];
    
    self.duration.text = [NSString stringWithFormat:@"0:00 / %@",
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
}

- (IBAction)playAudioPressed:(id)playButton
{
    [self.timer invalidate];
    //play audio for the first time or if pause was pressed
    if (!self.isPaused) {
        [self.playButton setImage:[UIImage imageNamed:@"pause"]
                                   forState:UIControlStateNormal];
        
        //start a timer to update the time label display
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [self.audioPlayer playAudio];
        
        [self.delegate audioIsPlaying];
        
        self.isPaused = YES;
        
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
    //to don't update every second. When scrubber is mouseDown the the slider will not set
    if (!self.scrubbing) {
        self.currentTimeSlider.value = [self.audioPlayer getCurrentAudioTime];
    }
    
    self.duration.text = [NSString stringWithFormat:@"%@ / %@",[self.audioPlayer timeFormat:[self.audioPlayer getCurrentAudioTime]],
                          [self.audioPlayer timeFormat:[self.audioPlayer getAudioDuration]]];
    
    //When resetted/ended reset the playButton
    if (![self.audioPlayer isPlaying]) {
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


@end
