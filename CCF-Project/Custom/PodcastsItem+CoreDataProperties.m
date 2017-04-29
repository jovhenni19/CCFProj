//
//  PodcastsItem+CoreDataProperties.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastsItem+CoreDataProperties.h"

@implementation PodcastsItem (CoreDataProperties)

+ (NSFetchRequest<PodcastsItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PodcastsItem"];
}

+ (NSManagedObject *)addItemWithContext:(NSManagedObjectContext*)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"PodcastsItem" inManagedObjectContext:context];
    return [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

@dynamic category_name;
@dynamic created_date;
@dynamic description_detail;
@dynamic id_num;
@dynamic image;
@dynamic image_data;
@dynamic title;

@end
