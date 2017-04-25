//
//  ScrollableMenubarViewController.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 20/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMCAudioPlayer.h"
#import "YTPlayerView.h"
#import "Pusher.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import "Pusher.h"
#import "PTPusherEventDispatcher.h"

@protocol ScrollableMenubarViewControllerDelegate <NSObject>
@optional

@end
@interface ScrollableMenubarViewController : UIViewController <UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PTPusherDelegate, PTEventListener, PTPusherConnectionDelegate> //UITableViewDelegate, UITableViewDataSource>
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
//@property (weak, nonatomic) IBOutlet UITableView *horizontalTableview;
@property (weak, nonatomic) IBOutlet UIView *containerViewForTable;
@property (weak, nonatomic) IBOutlet UIView *viewForProgressLoading;

@property (weak, nonatomic) IBOutlet UICollectionView *horizontalTableview;

@property (strong, nonatomic) PTPusher *pusherClient;

@property (strong, nonatomic) NSMutableArray *newsFromPusher;
@property (strong, nonatomic) NSMutableArray *groupList;

- (void) showProgressView;
- (void) addValueToProgressView;
- (void) removeProgressView;
- (void) subscribeEvent:(NSString*)eventName;
- (void) unSubscribeEvent:(NSString*)eventName;
- (NSArray*)getNewsFromPusher;
- (void)updateNewsFromPusher:(NSArray*)array;
- (NSArray*)getGroupList;
@end


