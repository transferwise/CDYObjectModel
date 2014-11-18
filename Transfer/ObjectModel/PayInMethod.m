#import "PayInMethod.h"


@interface PayInMethod ()

// Private interface goes here.

@end


@implementation PayInMethod


+(NSDictionary*)supportedPayInMethods
{
    return @{
			 @"REGULAR" : @1,
			 @"DATA_CASH" : @0,
			 @"SWIFT" : @2,
			 @"ADYEN" : @0,
//			 @"ACH" : @0
			 };
}

@end
