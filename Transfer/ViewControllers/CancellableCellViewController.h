//
//  CancelableCellViewController.h
//  Transfer
//
//  Created by Juhan Hion on 16.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "OptionalSplitViewController.h"
#import "SwipeActionCell.h"

@interface CancellableCellViewController : OptionalSplitViewController

@property (strong, nonatomic) NSIndexPath* cancellingCellIndex;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (SwipeActionCell *)getPaymentCell:(NSIndexPath *)index;
- (void)removeCancellingFromCell;
- (void)setCancellingVisibleForScrolling:(SwipeActionCell *)cell
							   indexPath:(NSIndexPath *)indexPath;
+ (NSArray *)generateIndexPathsFrom:(NSInteger)start
						  withCount:(NSInteger)count;

@end
