//
//  EventsObject.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsObject.h"

@implementation EventsObject

@synthesize contact_info;
@synthesize created_date;
@synthesize date;
@synthesize date_raw_start;
@synthesize date_raw_end;
@synthesize description_detail;
@synthesize id_num;
@synthesize image_url;
@synthesize image_data;
@synthesize registration_link;
@synthesize speakers;
@synthesize time_start;
@synthesize time_end;
@synthesize title;
@synthesize venue;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.created_date = [decoder decodeObjectForKey:@"events_created_date"];
        self.description_detail = [decoder decodeObjectForKey:@"events_description_detail"];
        self.id_num = [decoder decodeObjectForKey:@"events_id_num"];
        self.image_url = [decoder decodeObjectForKey:@"events_image_url"];
        self.image_data = [decoder decodeObjectForKey:@"events_image_data"];
        self.title = [decoder decodeObjectForKey:@"events_title"];
        self.venue = [decoder decodeObjectForKey:@"events_venue"];
        self.time_start = [decoder decodeObjectForKey:@"events_time_start"];
        self.time_end = [decoder decodeObjectForKey:@"events_time_end"];
        self.speakers = [decoder decodeObjectForKey:@"events_speakers"];
        self.registration_link = [decoder decodeObjectForKey:@"events_registration_link"];
        self.date_raw_start = [decoder decodeObjectForKey:@"events_date_raw_start"];
        self.date_raw_end = [decoder decodeObjectForKey:@"events_date_raw_end"];
        self.date = [decoder decodeObjectForKey:@"events_date"];
        self.contact_info = [decoder decodeObjectForKey:@"events_contact_info"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:created_date forKey:@"events_created_date"];
    [encoder encodeObject:description_detail forKey:@"events_description_detail"];
    [encoder encodeObject:id_num forKey:@"events_id_num"];
    [encoder encodeObject:image_url forKey:@"events_image_url"];
    [encoder encodeObject:image_data forKey:@"events_image_data"];
    [encoder encodeObject:title forKey:@"events_title"];
    [encoder encodeObject:venue forKey:@"events_venue"];
    [encoder encodeObject:time_start forKey:@"events_time_start"];
    [encoder encodeObject:time_end forKey:@"events_time_end"];
    [encoder encodeObject:speakers forKey:@"events_speakers"];
    [encoder encodeObject:registration_link forKey:@"events_registration_link"];
    [encoder encodeObject:date_raw_start forKey:@"events_date_raw_start"];
    [encoder encodeObject:date_raw_end forKey:@"events_date_raw_end"];
    [encoder encodeObject:date forKey:@"events_date"];
    [encoder encodeObject:contact_info forKey:@"events_contact_info"];
}

@end
