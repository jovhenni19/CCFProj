//
//  UIButton+LocationValues.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 05/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (LocationValues)
@property (assign, nonatomic) NSNumber *longitude;
@property (assign, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSString *locationName;
@property (strong, nonatomic) NSString *locationSnippet;

@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventAddress;
@property (strong, nonatomic) NSString *eventDate;
@property (strong, nonatomic) NSString *eventTime;

@end
