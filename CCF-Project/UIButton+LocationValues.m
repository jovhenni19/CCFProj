//
//  UIButton+LocationValues.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 05/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "UIButton+LocationValues.h"

@implementation UIButton (LocationValues)
@dynamic latitude;
@dynamic longitude;
@dynamic locationSnippet;
@dynamic locationName;
@dynamic eventTitle;
@dynamic eventAddress;
@dynamic eventDate;
@dynamic eventTime;

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

- (NSString *)eventTitle {
    return objc_getAssociatedObject(self, @selector(eventTitle));
}

- (NSString *)eventAddress {
    return objc_getAssociatedObject(self, @selector(eventAddress));
}

- (NSString *)eventDate {
    return objc_getAssociatedObject(self, @selector(eventDate));
}

- (NSString *)eventTime {
    return objc_getAssociatedObject(self, @selector(eventTime));
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

- (void)setEventTitle:(NSString *)eventTitle {
    objc_setAssociatedObject(self, @selector(eventTitle), eventTitle, OBJC_ASSOCIATION_COPY);
}

- (void)setEventAddress:(NSString *)eventAddress {
    objc_setAssociatedObject(self, @selector(eventAddress), eventAddress, OBJC_ASSOCIATION_COPY);
}

- (void)setEventDate:(NSString *)eventDate {
    objc_setAssociatedObject(self, @selector(eventDate), eventDate, OBJC_ASSOCIATION_COPY);
}

- (void)setEventTime:(NSString *)eventTime {
    objc_setAssociatedObject(self, @selector(eventTime), eventTime, OBJC_ASSOCIATION_COPY);
}

@end
