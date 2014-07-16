//
//  CancelableCellViewController.h
//  Transfer
//
//  Created by Juhan Hion on 16.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "OptionalSplitViewController.h"
#import "SwipeToCancelCell.h"

@interface CancelableCellViewController : OptionalSplitViewController

@property (strong, nonatomic) NSIndexPath* cancellingCellIndex;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (SwipeToCancelCell *)getPaymentCell:(NSIndexPath *)index;
- (void)removeCancellingFromCell;
- (void)setCancellingVisibleForScrolling:(SwipeToCancelCell *)cell
							   indexPath:(NSIndexPath *)indexPath;

@end
