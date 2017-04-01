//
//  ScrollableMenubarViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"

@protocol ScrollableMenubarViewControllerDelegate <NSObject>
@optional

@end
@interface ScrollableMenubarViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewBar;
@property (strong, nonatomic) IBOutlet UIView *menuBarView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *pagingScrollview;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *menuButtonList;
@property (strong, nonatomic) UIViewController *selectedViewController;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) id<ScrollableMenubarViewControllerDelegate> delegate;
@property (strong, nonatomic) UIColor *foreColor;

@property (strong, nonatomic) UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *horizontalTableview;
@property (weak, nonatomic) IBOutlet UIView *containerViewForTable;

- (void) showProgressView;
- (void) addValueToProgressView;
- (void) removeProgressView;


@end


