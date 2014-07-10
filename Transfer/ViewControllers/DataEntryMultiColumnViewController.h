//
//  DataEntryMultiColumnViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataEntryMultiColumnViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *sectionCellsByTableView;
@property (nonatomic, strong) IBOutletCollection(UITableView) NSArray* tableViews;

-(BOOL)hasMoreThanOneTableView;

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView;
- (void)textFieldEntryFinished;


-(void)reloadSeparators;

-(void)keyboardWillShow:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
-(void)keyboardWillHide:(NSNotification*)note; // Only handles fullscreen iPhone tables. Ovverride for iPad
@property (nonatomic, assign) UIEdgeInsets cachedInsets;

-(void)scrollToCell:(UITableViewCell*)cell inTableView:(UITableView*)tableView;

@end
