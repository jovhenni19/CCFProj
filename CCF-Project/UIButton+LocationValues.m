//
//  UIButton+LocationValues.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 05/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "UIButton+LocationValues.h"


NSString * const kLocationValuesLatitudeKey = @"kLocationValuesLatitudeKey";
NSString * const kLocationValuesLongitudeKey = @"kLocationValuesLongitudeKey";
NSString * const kLocationValuesNameKey = @"kLocationValuesNameKey";
NSString * const kLocationValuesSnippetKey = @"kLocationValuesSnippetKey";

@implementation UIButton (LocationValues)
@dynamic latitude;
@dynamic longitude;
@dynamic locationSnippet;
@dynamic locationName;

- (NSNumber*)latitude {
    return objc_getAssociatedObject(self, @selector(latitude));
}

- (NSNumber*)longitude {
    return objc_getAssociatedObject(self, @selector(longitude));
}

- (NSString *)locationName {
    return objc_getAssociatedObject(self, @selector(locationName));
}

- (NSString *)locationSnippet {
    return objc_getAssociatedObject(self, @selector(locationSnippet));
}

- (void)setLatitude:(NSNumber*)latitude {
    objc_setAssociatedObject(self, @selector(latitude), latitude, OBJC_ASSOCIATION_COPY);
}

- (void)setLongitude:(NSNumber*)longitude {
    objc_setAssociatedObject(self, @selector(longitude), longitude, OBJC_ASSOCIATION_COPY);
}

- (void)setLocationName:(NSString *)locationName {
    objc_setAssociatedObject(self, @selector(locationName), locationName, OBJC_ASSOCIATION_COPY);
}

- (void)setLocationSnippet:(NSString *)locationSnippet {
    objc_setAssociatedObject(self, @selector(locationSnippet), locationSnippet, OBJC_ASSOCIATION_COPY);
}


@end
