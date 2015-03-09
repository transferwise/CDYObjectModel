#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "Constants.h"
#import "NSString+Presentation.h"

@interface TypeFieldValue ()

@end


@implementation TypeFieldValue

- (NSString *)presentedValue {
    if ([self.valueForField hasPredefinedValues]) {
        return [self displayValueForCodeOrValue:self.value];
    }

    if (self.valueForField.presentationPattern) {
        return [self.value applyPattern:self.valueForField.presentationPattern];
    }

    return self.value;
}

- (NSString *)displayValueForCodeOrValue:(NSString *)codeOrValue {
    for (AllowedTypeFieldValue *allowed in self.valueForField.allowedValues) {
        if ([allowed.code isEqualToString:codeOrValue]) {
            return allowed.title;
        }
    }

    return codeOrValue;
}

@end
