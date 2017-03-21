//
//  SatellitesObject.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SatellitesObject.h"

@implementation SatellitesObject

@synthesize address_full;
@synthesize created_date;
@synthesize id_num;
@synthesize information;
@synthesize latitude;
@synthesize longitude;
@synthesize name;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.address_full = [decoder decodeObjectForKey:@"satellites_address_full"];
        self.created_date = [decoder decodeObjectForKey:@"satellites_created_date"];
        self.id_num = [decoder decodeObjectForKey:@"satellites_id_num"];
        self.information = [decoder decodeObjectForKey:@"satellites_information"];
        self.latitude = [decoder decodeObjectForKey:@"satellites_latitude"];
        self.longitude = [decoder decodeObjectForKey:@"satellites_longitude"];
        self.name = [decoder decodeObjectForKey:@"satellites_name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:address_full forKey:@"satellites_address_full"];
    [encoder encodeObject:created_date forKey:@"satellites_created_date"];
    [encoder encodeObject:id_num forKey:@"satellites_id_num"];
    [encoder encodeObject:information forKey:@"satellites_information"];
    [encoder encodeObject:latitude forKey:@"satellites_latitude"];
    [encoder encodeObject:longitude forKey:@"satellites_longitude"];
    [encoder encodeObject:name forKey:@"satellites_name"];
}
@end
