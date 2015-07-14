#import "PayInMethod.h"


@interface PayInMethod ()

// Private interface goes here.

@end


@implementation PayInMethod

+ (NSDictionary*)supportedPayInMethods
{
    return @{
			 @"REGULAR" : @4,
			 @"DATA_CASH" : @3,
			 @"SWIFT" : @5,
			 @"ADYEN" : @2,
			 @"ACH" : @0,
			 @"BANKGIRO" : @1
			 };
}

@end
