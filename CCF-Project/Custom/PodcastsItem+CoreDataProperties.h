//
//  PodcastsItem+CoreDataProperties.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 16/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "PodcastsItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PodcastsItem (CoreDataProperties)

+ (NSFetchRequest<PodcastsItem *> *)fetchRequest;

+ (NSManagedObject *)addItemWithContext:(NSManagedObjectContext*)context;

@property (nullable, nonatomic, copy) NSString *category_name;
@property (nullable, nonatomic, copy) NSString *created_date;
@property (nullable, nonatomic, copy) NSString *description_detail;
@property (nullable, nonatomic, copy) NSNumber *id_num;
@property (nullable, nonatomic, copy) NSString *image;
@property (nullable, nonatomic, retain) NSData *image_data;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
