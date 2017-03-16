//
//  NewsItem+CoreDataProperties.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "NewsItem+CoreDataProperties.h"

@implementation NewsItem (CoreDataProperties)

+ (NSFetchRequest<NewsItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NewsItem"];
}

+ (NSManagedObject *)addItemWithContext:(NSManagedObjectContext*)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"NewsItem" inManagedObjectContext:context];
    return [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

@dynamic created_date;
@dynamic description_detail;
@dynamic id_num;
@dynamic image;
@dynamic image_data;
@dynamic title;
@dynamic group_name;

@end
