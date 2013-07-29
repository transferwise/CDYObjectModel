#import "RecipientTypeField.h"


@interface RecipientTypeField ()

@end

@implementation RecipientTypeField

- (BOOL)hasPredefinedValues {
    return [self.allowedValues count] > 0;
}

@end
