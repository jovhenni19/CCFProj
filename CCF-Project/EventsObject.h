//
//  EventsObject.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventsObject : NSObject <NSCoding> {
    NSString *contact_info;
    NSString *created_date;
    NSString *date;
    NSString *date_raw;
    NSString *description_detail;
    NSNumber *id_num;
    NSString *image_url;
    NSData *image_data;
    NSString *registration_link;
    NSString *speakers;
    NSString *time;
    NSString *title;
    NSString *venue;
}

@property (nullable, nonatomic, copy) NSString *contact_info;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSString *date;
@property (nullable, nonatomic, copy) NSString *date_raw;
@property (nullable, nonatomic, copy) NSString *description_detail;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, copy) NSString *registration_link;
@property (nullable, nonatomic, copy) NSString *speakers;
@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *venue;


@end
