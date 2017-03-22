//
//  CustomButton.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 22/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+LocationValues.h"

@interface CustomButton : UIView

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *labelText;
@property (strong, nonatomic) UIImageView *imageView;


- (instancetype)initWithText:(NSString*)text image:(UIImage*)image frame:(CGRect)viewFrame;

@end
