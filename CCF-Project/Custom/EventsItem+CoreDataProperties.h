//
//  EventsItem+CoreDataProperties.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "EventsItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventsItem (CoreDataProperties)

+ (NSFetchRequest<EventsItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contact_info;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *date_raw;
@property (nullable, nonatomic, copy) NSString *description_detail;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, copy) NSString *registration_link;
@property (nullable, nonatomic, copy) NSString *speakers;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *venue;

@end

NS_ASSUME_NONNULL_END
