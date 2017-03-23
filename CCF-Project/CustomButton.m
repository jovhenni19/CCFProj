//
//  CustomButton.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 22/03/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "CustomButton.h"

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


- (instancetype)initWithText:(NSString*)text image:(UIImage*)image frame:(CGRect)viewFrame {
    
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(28.0f, 0.0f, viewFrame.size.width - 10.0f, viewFrame.size.height)];
    tv.text = text;
    tv.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
    CGSize contentSize = [tv contentSize];
    
    CGFloat height = (contentSize.height > viewFrame.size.height)?contentSize.height:viewFrame.size.height;

    CGRect newFrame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y, viewFrame.size.width, height);
    if ((self = [super initWithFrame:newFrame])) {
        
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.clipsToBounds = YES;
        CGFloat y = /*10.0f;*/(newFrame.size.height/2.0f) - (25.0f/2.0f);
        self.imageView.frame = CGRectMake(0.0f, y, 25.0f, 25.0f);
        
        [self addSubview:self.imageView];
        
        self.labelText = [[UILabel alloc] initWithFrame:CGRectMake(28.0f, 0.0f, newFrame.size.width - 28.0f, newFrame.size.height)];
        self.labelText.text = text;
        self.labelText.font = [UIFont fontWithName:@"OpenSans" size:13.0f];
        self.labelText.numberOfLines = 0;
        self.labelText.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self addSubview:self.labelText];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.frame = newFrame;
        
        [self addSubview:self.button];        
        
    }
    
    return self;
}

@end
