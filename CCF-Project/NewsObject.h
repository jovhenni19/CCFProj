//
//  NewsObject.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject <NSCoding> {
    NSString *created_date;
    NSString *description_detail;
    NSNumber *id_num;
    NSString *image_url;
    NSData *image_data;
    NSString *title;
    NSString *group_name;
}

@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSString *description_detail;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *image_url;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *group_name;

@end