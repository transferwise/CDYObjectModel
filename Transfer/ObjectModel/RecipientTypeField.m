#import "RecipientTypeField.h"
#import "PlainRecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "PlainStringValue.h"


@interface RecipientTypeField ()

@end


@implementation RecipientTypeField

+ (NSArray *)createPlainFields:(NSOrderedSet *)set {
    NSMutableArray *result = [NSMutableArray array];
    for (RecipientTypeField *field in set) {
        [result addObject:[RecipientTypeField createPlainField:field]];
    }
    return [NSArray arrayWithArray:result];
}

+ (PlainRecipientTypeField *)createPlainField:(RecipientTypeField *)field {
    PlainRecipientTypeField *plainField = [[PlainRecipientTypeField alloc] init];
    [plainField setName:field.name];
    [plainField setTitle:field.title];
    NSMutableArray *possibleValues = [NSMutableArray array];
    for (AllowedTypeFieldValue *value in field.allowedValues) {
        [possibleValues addObject:[[PlainStringValue alloc] initWithString:value.code]];
    }
    [plainField setPossibleValues:possibleValues];
    return plainField;
}

@end
