//
//  PodcastsObject.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PodcastsObject : NSObject <NSCoding> {
    NSString *category_name;
    NSString *created_date;
    NSString *description_detail;
    NSNumber *id_num;
    NSString *image_url;
    NSData *image_data;
    NSString *title;
}

@property (nullable, nonatomic, copy) NSString *category_name;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSString *description_detail;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, copy) NSString *title;

@end
