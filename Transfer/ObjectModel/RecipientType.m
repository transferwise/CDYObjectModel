#import "RecipientType.h"
#import "PlainRecipientType.h"
#import "RecipientTypeField.h"


@interface RecipientType ()

@end


@implementation RecipientType

+ (NSArray *)createPlainTypes:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];

    for (RecipientType *type in array) {
        [result addObject:[RecipientType createPlainType:type]];
    }

    return [NSArray arrayWithArray:result];
}

+ (PlainRecipientType *)createPlainType:(RecipientType *)type {
    PlainRecipientType *recipientType = [[PlainRecipientType alloc] init];
    [recipientType setType:type.type];
    [recipientType setFields:[RecipientTypeField createPlainFields:type.fields]];
    return recipientType;
}

+ (NSArray *)typeCodesArray:(NSSet *)set {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[set count]];
    for (RecipientType *type in set) {
        [result addObject:type.type];
    }

    return [NSArray arrayWithArray:result];
}

@end
