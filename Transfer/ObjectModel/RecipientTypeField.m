#import "RecipientTypeField.h"
#import "NSString+Validation.h"


@interface RecipientTypeField ()

@end

@implementation RecipientTypeField

- (BOOL)hasPredefinedValues {
    return [self.allowedValues count] > 0;
}

- (NSString *)hasIssueWithValue:(NSString *)value {
    if (![value hasValue] && !self.requiredValue) {
        return nil;
    }

    if (![value hasValue] && self.requiredValue) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.type.field.value.not.entered", nil), self.title];
    }

    if (self.minLengthValue != 0 && [value length] < self.minLengthValue) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.type.field.value.too.short", nil), self.title, self.minLengthValue];
    }

    if (self.maxLengthValue != 0 && [value length] > self.maxLengthValue) {
        return [NSString stringWithFormat:NSLocalizedString(@"recipient.type.field.value.too.long", nil), self.title, self.minLengthValue];
    }

    if ([self.name isEqualToString:@"email"] && ![value isValidEmail]) {
        return NSLocalizedString(@"recipient.type.field.email.invalid", nil);
    }

    if (![self.validationRegexp hasValue]) {
        return nil;
    }

    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.validationRegexp];
    if ([regExPredicate evaluateWithObject:value]) {
        return nil;
    }

    return [NSString stringWithFormat:NSLocalizedString(@"recipient.type.field.value.invalid", nil), self.title];
}

@end
