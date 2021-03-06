//
//  YMCAudioPlayer.m
//  AudioPlayerTemplate
//
//  Created by ymc-thzi on 13.08.13.
//  Copyright (c) 2013 ymc-thzi. All rights reserved.
//

#import "YMCAudioPlayer.h"

@implementation YMCAudioPlayer

/*
 * Init the Player with Filename and FileExtension
 */

- (void)initPlayerFromURL:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error;
    
    NSData *soundData = [NSData dataWithContentsOfURL:url];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES) objectAtIndex:0]
                          stringByAppendingPathComponent:[url lastPathComponent]];
    [soundData writeToFile:filePath atomically:YES];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL
                                                           fileURLWithPath:filePath] error:&error];
    
    if (error) {
        NSLog(@"## %@ error:%@",urlString,[error description]);
    }
}

- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    if (error) {
        NSLog(@"## error:%@",[error description]);
    }
}

- (void)initPlayerFromDocuments:(NSString*) audioFilePath
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                               NSUserDomainMask, YES) objectAtIndex:0]
                          stringByAppendingPathComponent:[audioFilePath lastPathComponent]];
    
    NSLog(@"filePath:%@\n\naudio:%@",filePath,[audioFilePath lastPathComponent]);
    
    
    NSURL *audioFileLocationURL = [NSURL fileURLWithPath:filePath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    if (error) {
        NSLog(@"## error:%@",[error description]);
    }
}

/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}


- (void)stopAudio {
    [self.audioPlayer stop];
}

/*
 * get playingState
 */
- (BOOL)isPlaying {
    return [self.audioPlayer isPlaying];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    NSLog(@"time:%@",time);
    return time;
}

/*
 * To set the current Position of the
 * playing audio File
 */
- (void)setCurrentAudioTime:(float)value {
    [self.audioPlayer setCurrentTime:value];
}

/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime {
    return [self.audioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration {
    return [self.audioPlayer duration];
}


@end
