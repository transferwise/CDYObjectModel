//
//  CancelableCellViewController.m
//  Transfer
//
//  Created by Juhan Hion on 16.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CancellableCellViewController.h"

@interface CancellableCellViewController ()

@end

@implementation CancellableCellViewController

- (SwipeActionCell *)getPaymentCell:(NSIndexPath *)index
{
	return (SwipeActionCell *)[self.tableView cellForRowAtIndexPath:index];
}

- (void)removeCancellingFromCell
{
	if (self.cancellingCellIndex != nil)
	{
		[[self getPaymentCell:self.cancellingCellIndex] setIsActionButtonVisible:NO animated:YES];
		self.cancellingCellIndex = nil;
	}
}

- (void)setCancellingVisibleForScrolling:(SwipeActionCell *)cell
							   indexPath:(NSIndexPath *)indexPath
{
	if(self.cancellingCellIndex && self.cancellingCellIndex.row == indexPath.row)
	{
		[cell setIsActionButtonVisible:YES animated:NO];
	}
	else
	{
		[cell setIsActionButtonVisible:NO animated:NO];
	}
}

+ (NSArray *)generateIndexPathsFrom:(NSInteger)start withCount:(NSInteger)count
{
	NSMutableArray* results = [[NSMutableArray alloc] initWithCapacity:count];
	
	for (int i = 0; i < count; i++)
	{
		[results addObject:[NSIndexPath indexPathForRow:start + i inSection:0]];
	}
	
	return results;
}

@end
