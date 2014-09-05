#import "PairSourceCurrency.h"


@interface PairSourceCurrency ()

// Private interface goes here.

@end


@implementation PairSourceCurrency

- (BOOL)acceptablePayIn:(NSNumber *)amount {
	NSComparisonResult result = [self.maxInvoiceAmount compare:amount];
	return result == NSOrderedDescending || result == NSOrderedSame;
}

@end
