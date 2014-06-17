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

@end
