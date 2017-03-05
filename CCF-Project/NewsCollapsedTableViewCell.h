//
//  NewsCollapsedTableViewCell.h
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 27/02/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsCellDelegate <NSObject>

@required
- (void) buttonLocationPressed:(NSIndexPath*)indexPath;
- (void) buttonDatePressed:(NSIndexPath*)indexPath;

@end

@interface NewsCollapsedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelNewsTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeCreated;
@property (weak, nonatomic) IBOutlet UITextView *textNewsDetails;
@property (weak, nonatomic) IBOutlet UIView *viewControls;
@property (weak, nonatomic) IBOutlet UIButton *buttonGroupName;
@property (weak, nonatomic) IBOutlet UIButton *buttonLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonDate;

@property (strong, nonatomic) id<NewsCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
