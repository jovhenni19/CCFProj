//
//  SatellitesObject.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 21/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SatellitesObject : NSObject <NSCoding> {
    NSString *address_full;
    NSString *created_date;
    NSNumber *id_num;
    NSString *information;
    NSString *latitude;
    NSString *longitude;
    NSString *name;
    NSString *email;
    NSString *contacts;
    NSString *website;
}

@property (nullable, nonatomic, copy) NSString *address_full;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *information;
@property (nullable, nonatomic, copy) NSString *latitude;
@property (nullable, nonatomic, copy) NSString *longitude;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *contacts;
@property (nullable, nonatomic, copy) NSString *website;
@end
