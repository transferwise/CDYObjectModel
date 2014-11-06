#import "PayInMethod.h"


@interface PayInMethod ()

// Private interface goes here.

@end


@implementation PayInMethod


+(NSArray*)supportedPayInMethods
{
    return @[@"REGULAR",@"DATA_CASH",@"SWIFT"];
}

@end
