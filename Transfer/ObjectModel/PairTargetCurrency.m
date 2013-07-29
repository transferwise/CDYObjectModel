#import "PairTargetCurrency.h"


@interface PairTargetCurrency ()

@end


@implementation PairTargetCurrency

- (BOOL)acceptablePayIn:(NSNumber *)amount {
    NSComparisonResult result = [self.minInvoiceAmount compare:amount];
    return result == NSOrderedAscending || result == NSOrderedSame;
}

@end
