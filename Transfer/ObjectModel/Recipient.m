#import "Recipient.h"
#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "PlainRecipient.h"
#import "_Currency.h"
#import "Currency.h"
#import "_RecipientType.h"
#import "RecipientType.h"


@interface Recipient ()

@end


@implementation Recipient

- (NSString *)detailsRowOne {
    TypeFieldValue *value = [self.fieldValues firstObject];
    return [self presentationStringFromValue:value];
}

+ (NSArray *)createPlainRecipients:(NSArray *)recipientObjects {
    NSMutableArray *result = [NSMutableArray array];
    for (Recipient *recipient in recipientObjects) {
        [result addObject:[Recipient createPlainRecipient:recipient]];
    }
    return [NSArray arrayWithArray:result];
}

+ (PlainRecipient *)createPlainRecipient:(Recipient *)recipient {
    PlainRecipient *plain = [[PlainRecipient alloc] init];
    [plain setId:recipient.remoteId];
    [plain setName:recipient.name];
    [plain setCurrency:recipient.currency.code];
    [plain setType:recipient.type.type];
    for (TypeFieldValue *value in recipient.fieldValues) {
        [plain setValue:value.value forKeyPath:value.valueForField.name];
    }
    return plain;
}

- (NSString *)detailsRowTwo {
    if ([self.fieldValues count] < 2) {
        return @"";
    }

    TypeFieldValue *value = self.fieldValues[1];
    return [self presentationStringFromValue:value];
}

- (NSString *)presentationStringFromValue:(TypeFieldValue *)value {
    if (!value || !value.value) {
        return @"";
    }

    return [NSString stringWithFormat:@"%@: %@", value.valueForField.title, value.value];
}

- (PlainRecipient *)plainRecipient {
    return [Recipient createPlainRecipient:self];
}

@end
