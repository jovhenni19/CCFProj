//
//  NewsObject.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "NewsObject.h"

@implementation NewsObject

@synthesize created_date;
    @synthesize description_detail;
    @synthesize description_excerpt;
@synthesize id_num;
@synthesize image_url;
@synthesize image_data;
@synthesize title;
@synthesize group_name;
@synthesize is_read;

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.created_date = [decoder decodeObjectForKey:@"news_created_date"];
        self.description_detail = [decoder decodeObjectForKey:@"news_description_detail"];
        self.description_excerpt = [decoder decodeObjectForKey:@"news_description_excerpt"];
        self.id_num = [decoder decodeObjectForKey:@"news_id_num"];
        self.image_url = [decoder decodeObjectForKey:@"news_image_url"];
        self.image_data = [decoder decodeObjectForKey:@"news_image_data"];
        self.title = [decoder decodeObjectForKey:@"news_title"];
        self.group_name = [decoder decodeObjectForKey:@"news_group_name"];
        self.is_read = [decoder decodeObjectForKey:@"news_is_read"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:created_date forKey:@"news_created_date"];
    [encoder encodeObject:description_detail forKey:@"news_description_detail"];
    [encoder encodeObject:description_excerpt forKey:@"news_description_excerpt"];
    [encoder encodeObject:id_num forKey:@"news_id_num"];
    [encoder encodeObject:image_url forKey:@"news_image_url"];
    [encoder encodeObject:image_data forKey:@"news_image_data"];
    [encoder encodeObject:title forKey:@"news_title"];
    [encoder encodeObject:group_name forKey:@"news_group_name"];
    [encoder encodeObject:is_read forKey:@"news_is_read"];
}
@end
