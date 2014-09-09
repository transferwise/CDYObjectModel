#import "Country.h"


@interface Country ()

// Private interface goes here.

@end


@implementation Country

// Custom logic goes here.
- (NSString *)code
{
	return self.iso3Code;
}

@end
