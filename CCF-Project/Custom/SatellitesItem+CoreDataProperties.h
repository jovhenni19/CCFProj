//
//  SatellitesItem+CoreDataProperties.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "SatellitesItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SatellitesItem (CoreDataProperties)

+ (NSFetchRequest<SatellitesItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address_full;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *information;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
