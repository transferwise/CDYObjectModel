//
//  CancelableCellViewController.m
//  Transfer
//
//  Created by Juhan Hion on 16.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CancelableCellViewController.h"

@interface CancelableCellViewController ()

@end

@implementation CancelableCellViewController

- (SwipeToCancelCell *)getPaymentCell:(NSIndexPath *)index
{
	return (SwipeToCancelCell *)[self.tableView cellForRowAtIndexPath:index];
}

- (void)removeCancellingFromCell
{
	if (self.cancellingCellIndex != nil)
	{
		[[self getPaymentCell:self.cancellingCellIndex] setIsCancelVisible:NO animated:YES];
		self.cancellingCellIndex = nil;
	}
}

- (void)setCancellingVisibleForScrolling:(SwipeToCancelCell *)cell
							   indexPath:(NSIndexPath *)indexPath
{
	if(self.cancellingCellIndex && self.cancellingCellIndex.row == indexPath.row)
	{
		[cell setIsCancelVisible:YES animated:NO];
	}
	else
	{
		[cell setIsCancelVisible:NO animated:NO];
	}
}

@end
