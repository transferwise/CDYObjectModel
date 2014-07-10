//
//  DataEntryViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataEntryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *presentedSectionCells;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)textFieldEntryFinished;


-(void)reloadSeparators;

-(void)keyboardWillShow:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
-(void)keyboardWillHide:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
@property (nonatomic, assign) UIEdgeInsets cachedInsets;
@end
