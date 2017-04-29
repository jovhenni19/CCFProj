//
//  EventsItem+CoreDataProperties.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsItem+CoreDataProperties.h"

@implementation EventsItem (CoreDataProperties)

+ (NSFetchRequest<EventsItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventsItem"];
}

@dynamic contact_info;
@dynamic created_date;
@dynamic date;
@dynamic date_raw;
@dynamic description_detail;
@dynamic id_num;
@dynamic image;
@dynamic image_data;
@dynamic registration_link;
@dynamic speakers;
@dynamic time;
@dynamic title;
@dynamic venue;

@end
