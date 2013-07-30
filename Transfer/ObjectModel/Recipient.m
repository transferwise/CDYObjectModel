#import "Recipient.h"
#import "TypeFieldValue.h"
#import "RecipientTypeField.h"
#import "Currency.h"
#import "RecipientType.h"


@interface Recipient ()

@end


@implementation Recipient

- (NSString *)detailsRowOne {
    TypeFieldValue *value = [self.fieldValues firstObject];
    return [self presentationStringFromValue:value];
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

- (NSString *)valueField:(RecipientTypeField *)field {
    TypeFieldValue *value = [self valueForField:field];
    if (value) {
        return [value value];
    }

    return @"";
}

- (void)setValue:(NSString *)value forField:(RecipientTypeField *)field {
    TypeFieldValue *fieldValue = [self valueForField:field];
    if (!fieldValue) {
        fieldValue = [TypeFieldValue insertInManagedObjectContext:self.managedObjectContext];
        [fieldValue setRecipient:self];
        [fieldValue setValueForField:field];
    }

    [fieldValue setValue:value];
}

- (TypeFieldValue *)valueForField:(RecipientTypeField *)field {
    for (TypeFieldValue *value in self.fieldValues) {
        if ([value.valueForField isEqual:field]) {
            return value;
        }
    }

    return nil;
}

- (NSDictionary *)data {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"name"] = self.name;
    data[@"currency"] = self.currency.code;
    data[@"type"] = self.type.type;
    for (TypeFieldValue *value in self.fieldValues) {
        data[value.valueForField.name] = value.value;
    }
    return [NSDictionary dictionaryWithDictionary:data];
}

@end