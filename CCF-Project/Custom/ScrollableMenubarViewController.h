//
//  ScrollableMenubarViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollableMenubarViewControllerDelegate;
@interface ScrollableMenubarViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *menuBarView;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *selectedViewController;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) id<UIScrollViewAccessibilityDelegate> delegate;
@property (strong, nonatomic) UIColor *foreColor;

@end


@protocol ScrollableMenubarViewControllerDelegate <NSObject>
@optional

@end
