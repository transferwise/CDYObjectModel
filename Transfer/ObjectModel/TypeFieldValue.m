#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "Constants.h"

@interface TypeFieldValue ()

@end


@implementation TypeFieldValue

- (NSString *)presentedValue {
    if ([self.valueForField hasPredefinedValues]) {
        return [self displayValueForCode:self.value];
    }

    return self.value;
}

- (NSString *)displayValueForCode:(NSString *)code {
    for (AllowedTypeFieldValue *allowed in self.valueForField.allowedValues) {
        if ([allowed.code isEqualToString:code]) {
            return allowed.title;
        }
    }

    MCAssert(NO);
    return @"";
}

@end
