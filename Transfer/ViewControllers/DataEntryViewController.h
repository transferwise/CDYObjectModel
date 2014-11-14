//
//  DataEntryViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultipleEntryCell.h"

@class CommonAnimationHelper;

@interface DataEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MultipleEntryCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *presentedSectionCells;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet CommonAnimationHelper* bottomButtonAnimator;

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)textFieldEntryFinished;


-(void)reloadSeparators;

-(void)keyboardWillShow:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
-(void)keyboardWillHide:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
@property (nonatomic, assign) UIEdgeInsets cachedInsets;
@end
