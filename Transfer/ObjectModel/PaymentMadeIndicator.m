#import "PaymentMadeIndicator.h"


@interface PaymentMadeIndicator ()

// Private interface goes here.

@end


@implementation PaymentMadeIndicator

-(BOOL)isCancellable
{
    return [@"ACH" caseInsensitiveCompare:self.payInMethodName] != NSOrderedSame;
}

@end
