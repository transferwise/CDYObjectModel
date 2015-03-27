#import "PayInMethod.h"


@interface PayInMethod ()

// Private interface goes here.

@end


@implementation PayInMethod


+(NSDictionary*)supportedPayInMethods
{
    return @{
			 @"REGULAR" : @3,
			 @"DATA_CASH" : @2,
			 @"SWIFT" : @4,
			 @"ADYEN" : @1,
			 @"ACH" : @0
			 };
}

@end
