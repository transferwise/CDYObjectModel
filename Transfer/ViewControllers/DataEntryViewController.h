//
//  DataEntryViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataEntryViewController : UITableViewController

@property (nonatomic, strong) NSArray *presentedSectionCells;

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath;

@end
