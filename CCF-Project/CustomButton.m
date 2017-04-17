//
//  CustomButton.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 22/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "CustomButton.h"
@interface CustomButton ()
@property (assign, nonatomic) CGFloat computedWidth;
@property (assign, nonatomic) CGFloat computedHeight;
@property (assign, nonatomic) BOOL isLocked;
@end

@implementation CustomButton

@synthesize imageView;
@synthesize labelText;
@synthesize button;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    UILayoutGuide *marginGuide = self.layoutMarginsGuide;
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeTopMargin multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeTopMargin multiplier:1.0f constant:3.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTopMargin multiplier:1.0f constant:0.0f]];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:0.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeBottomMargin multiplier:1.0f constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeLeadingMargin multiplier:1.0f constant:0.0f]];
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:20.0f]];
    [self.imageView addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:20.0f]];
    
//    CGFloat hack = (self.isLocked==YES)?20.0f:0.0f;
    [self.labelText addConstraint:[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0f constant:self.computedWidth]];
    
//    [self.labelText addConstraint:[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0f constant:self.computedHeight]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.labelText attribute:NSLayoutAttributeLeading multiplier:1.0f constant:-2.0f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.labelText attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeTrailingMargin multiplier:1.0f constant:0.0f]];
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeLeadingMargin multiplier:1.0f constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:marginGuide attribute:NSLayoutAttributeTrailingMargin multiplier:1.0f constant:0.0f]];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.labelText.translatesAutoresizingMaskIntoConstraints = NO;
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
}

    
- (instancetype)initWithText:(NSString*)text image:(UIImage*)image frame:(CGRect)viewFrame locked:(BOOL)locked {
    self.isLocked = locked;
//    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(22.0f, 0.0f, viewFrame.size.width - 22.0f, viewFrame.size.height)];
//    tv.text = [text uppercaseString];
//    tv.font = [UIFont fontWithName:@"OpenSans" size:11.0f];
//    CGSize contentSize = [tv contentSize];
    
    
    CGSize maximumLabelSize = CGSizeMake(viewFrame.size.width - 22.0f, CGFLOAT_MAX);
    CGRect textRect = [[text uppercaseString] boundingRectWithSize:maximumLabelSize
                                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                        attributes:@{NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:11.0f]}
                                                           context:nil];
    
    CGSize contentSize = textRect.size;
    
    
    
    CGFloat height = (contentSize.height > viewFrame.size.height)?contentSize.height:viewFrame.size.height;
    
    CGRect newFrame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, height);
    
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 0.0f, newFrame.size.width - 22.0f, newFrame.size.height)];
    lblText.text = [text uppercaseString];
    lblText.font = [UIFont fontWithName:@"OpenSans" size:11.0f];
    lblText.numberOfLines = 0;
    lblText.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (locked) {
        [lblText sizeToFit];
    }
    
    newFrame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, lblText.frame.size.width + 22.0f + 10.0f, height+10.0f);
    //NSLog(@"newFrame:%@",NSStringFromCGRect(newFrame));
//    if (locked) {
//        newFrame = viewFrame;
//    }
    if ((self = [super initWithFrame:newFrame])) {
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        CGFloat y = /*10.0f;*/(newFrame.size.height/2.0f) - (20.0f/2.0f);
        self.imageView.frame = CGRectMake(0.0f, y, 20.0f, 20.0f);
        
        [self addSubview:self.imageView];
        
        self.labelText = [[UILabel alloc] initWithFrame:CGRectMake(22.0f, 0.0f, newFrame.size.width - 22.0f, newFrame.size.height)];
        self.labelText.text = [text uppercaseString];
        self.labelText.font = [UIFont fontWithName:@"OpenSans" size:11.0f];
        self.labelText.numberOfLines = 0;
        self.labelText.lineBreakMode = NSLineBreakByWordWrapping;
//        self.labelText.layer.borderWidth = 1.0f;
        
        self.computedWidth = self.labelText.frame.size.width;
//        self.computedHeight = self.labelText.frame.size.height;
        
        [self addSubview:self.labelText];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = newFrame;
        self.button.layer.zPosition = 99.0f;
        
        [self addSubview:self.button];
        
//        self.labelText.layer.borderColor = [UIColor greenColor].CGColor;
//        self.labelText.layer.borderWidth = 1.0f;
//        
//        self.layer.borderColor = [UIColor redColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        
        
        
    }
    
    return self;
}


@end
