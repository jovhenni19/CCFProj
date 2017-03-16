//
//  SatellitesItem+CoreDataProperties.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SatellitesItem+CoreDataProperties.h"

@implementation SatellitesItem (CoreDataProperties)

+ (NSFetchRequest<SatellitesItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SatellitesItem"];
}

@dynamic address_full;
@dynamic created_date;
@dynamic id_num;
@dynamic information;
@dynamic latitude;
@dynamic longitude;
@dynamic name;

@end
