//
//  PodcastsObject.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastsObject.h"

@implementation PodcastsObject

@synthesize category_name;
@synthesize created_date;
@synthesize description_detail;
@synthesize id_num;
@synthesize image_url;
@synthesize image_data;
@synthesize title;
@synthesize youtubeURL;
@synthesize audioURL;
@synthesize audioFilePath;
@synthesize speaker;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.created_date = [decoder decodeObjectForKey:@"podcasts_created_date"];
        self.description_detail = [decoder decodeObjectForKey:@"podcasts_description_detail"];
        self.id_num = [decoder decodeObjectForKey:@"podcasts_id_num"];
        self.image_url = [decoder decodeObjectForKey:@"podcasts_image_url"];
        self.image_data = [decoder decodeObjectForKey:@"podcasts_image_data"];
        self.title = [decoder decodeObjectForKey:@"podcasts_title"];
        self.category_name = [decoder decodeObjectForKey:@"podcasts_category_name"];
        self.youtubeURL = [decoder decodeObjectForKey:@"podcasts_youtube_url"];
        self.audioURL = [decoder decodeObjectForKey:@"podcasts_audio_url"];
        self.audioFilePath = [decoder decodeObjectForKey:@"podcasts_audio_filepath"];
        self.speaker = [decoder decodeObjectForKey:@"podcasts_speaker"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:created_date forKey:@"podcasts_created_date"];
    [encoder encodeObject:description_detail forKey:@"podcasts_description_detail"];
    [encoder encodeObject:id_num forKey:@"podcasts_id_num"];
    [encoder encodeObject:image_url forKey:@"podcasts_image_url"];
    [encoder encodeObject:image_data forKey:@"podcasts_image_data"];
    [encoder encodeObject:title forKey:@"podcasts_title"];
    [encoder encodeObject:category_name forKey:@"podcasts_category_name"];
    [encoder encodeObject:youtubeURL forKey:@"podcasts_youtube_url"];
    [encoder encodeObject:audioURL forKey:@"podcasts_audio_url"];
    [encoder encodeObject:audioFilePath forKey:@"podcasts_audio_filepath"];
    [encoder encodeObject:speaker forKey:@"podcasts_speaker"];
}

@end
