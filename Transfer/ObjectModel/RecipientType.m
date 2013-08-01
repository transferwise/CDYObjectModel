#import "RecipientType.h"


@interface RecipientType ()

@end

@implementation RecipientType

- (BOOL)isEmailType {
    return [self.type isEqualToString:@"EMAIL"];
}

@end
