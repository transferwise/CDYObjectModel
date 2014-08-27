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
