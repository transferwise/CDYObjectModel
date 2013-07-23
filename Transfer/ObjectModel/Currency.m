#import "Currency.h"

@interface Currency ()

@end


@implementation Currency

- (NSString *)formattedCodeAndName {
    return [NSString stringWithFormat:@"%@ %@", self.code, self.name];
}

@end
