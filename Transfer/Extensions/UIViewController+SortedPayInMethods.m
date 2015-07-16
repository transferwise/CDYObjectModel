//
//  UIViewController+SortedPayInMethods.m
//  Transfer
//
//  Created by Juhan Hion on 14.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "UIViewController+SortedPayInMethods.h"
#import "Payment.h"
#import "PayInMethod.h"

@implementation UIViewController (SortedPayInMethods)

- (NSMutableArray *)sortedPayInMethodTypesForPayment:(Payment *)payment
{
	NSArray *payInMethodsSorted = [[payment enabledPayInMethods] sortedArrayUsingComparator:^NSComparisonResult(PayInMethod *method1, PayInMethod *method2) {
		return [[[PayInMethod supportedPayInMethods] objectForKeyedSubscript:method1.type] integerValue] > [[[PayInMethod supportedPayInMethods] objectForKey:method2.type] integerValue];
	}];
	
	NSMutableArray *sortedPayInMethodTypes = [[NSMutableArray alloc] initWithCapacity:payInMethodsSorted.count];
	for (PayInMethod *method in payInMethodsSorted)
	{
		[sortedPayInMethodTypes addObject:method.type];
	}
	
	return sortedPayInMethodTypes;
}

@end
