#import "PayInMethod.h"


@interface PayInMethod ()

// Private interface goes here.

@end


@implementation PayInMethod

+ (NSDictionary*)supportedPayInMethods
{
    return @{
			 @"REGULAR" : @4,
			 @"DATA_CASH" : @2,
			 @"SWIFT" : @5,
			 @"ADYEN" : @1,
			 @"ACH" : @0,
			 @"BANKGIRO" : @3
			 };
}

@end
