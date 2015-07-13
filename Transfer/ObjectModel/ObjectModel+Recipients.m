//
//  ObjectModel+Recipients.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Recipients.h"
#import "Recipient.h"
#import "ObjectModel+Currencies.h"
#import "NSDictionary+Cleanup.h"
#import "RecipientType.h"
#import "ObjectModel+RecipientTypes.h"
#import "RecipientTypeField.h"
#import "TypeFieldValue.h"
#import "ObjectModel+Users.h"
#import "Currency.h"

@implementation ObjectModel (Recipients)

- (NSArray *)allUserRecipientsForDisplay
{
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSPredicate *notHiddenPredicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
	NSPredicate *notHiddenTypePredicate = [NSPredicate predicateWithFormat:@"type.hideFromCreation = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notHiddenPredicate, notHiddenTypePredicate]];
	return [self fetchEntitiesNamed:[Recipient entityName] usingPredicate:predicate withSortDescriptors:@[nameDescriptor]];
}

- (Recipient *)recipientWithRemoteId:(NSNumber *)recipientId {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId = %@", recipientId];
    return [self fetchEntityNamed:[Recipient entityName] withPredicate:remoteIdPredicate];
}

- (Recipient *)createOrUpdateRecipientWithData:(NSDictionary *)rawData {
    return [self createOrUpdateRecipientWithData:rawData hideCreated:NO];
}

- (Recipient *)createOrUpdateRecipientWithData:(NSDictionary *)rawData hideCreated:(BOOL)hideCreated {
    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSNumber *remoteId = data[@"id"];
    Recipient *recipient = [self recipientWithRemoteId:remoteId];
    if (!recipient) {
        recipient = [Recipient insertInManagedObjectContext:self.managedObjectContext];
        [recipient setRemoteId:remoteId];
        [recipient setUser:[self currentUser]];
        [recipient setHiddenValue:hideCreated];
    }

    [recipient setName:data[@"name"]];
    [recipient setCurrency:[self currencyWithCode:data[@"currency"]]];
    [recipient setEmail:data[@"email"]];
    if (!hideCreated) {
        [recipient setHiddenValue:NO];
    }

    NSString *typeCode = data[@"type"];
    RecipientType *type = [self recipientTypeWithCode:typeCode];
    [recipient setType:type];
    for (RecipientTypeField *field in type.fields) {
        NSString *fieldValue = data[field.name];
        [self addOrUpdateValue:fieldValue forField:field toRecipient:recipient];
    }
    
    recipient.addressFirstLine = data[@"addressFirstLine"];
    recipient.addressPostCode = data[@"addressPostCode"];
    recipient.addressCity = data[@"addressCity"];
    recipient.addressCountryCode = data[@"addressCountryCode"];
    recipient.addressState = data[@"addressState"];

    return recipient;
}

- (void)addOrUpdateValue:(NSString *)value forField:(RecipientTypeField *)field toRecipient:(Recipient *)recipient {
    TypeFieldValue *fieldValue = [self existingValueForRecipient:recipient field:field];
    if (!fieldValue) {
        fieldValue = [TypeFieldValue insertInManagedObjectContext:self.managedObjectContext];
        [fieldValue setValueForField:field];
        [fieldValue setRecipient:recipient];
    }

    [fieldValue setValue:value];
}

- (TypeFieldValue *)existingValueForRecipient:(Recipient *)recipient field:(RecipientTypeField *)field {
    NSPredicate *fieldPredicate = [NSPredicate predicateWithFormat:@"valueForField = %@", field];
    return [[recipient.fieldValues filteredOrderedSetUsingPredicate:fieldPredicate] lastObject];
}

- (Recipient *)createOrUpdatePayInMethodRecipientWithData:(NSDictionary *)data {
    Recipient *recipient = [self createOrUpdateRecipientWithData:data];
    [recipient setHiddenValue:YES];
    return recipient;
}

- (Recipient *)createRecipient {
    Recipient *recipient = [Recipient insertInManagedObjectContext:self.managedObjectContext];
    [recipient setHiddenValue:YES];
    [recipient setUser:[self currentUser]];
    return recipient;
}

- (NSFetchedResultsController *)fetchedControllerForRecipientsWithCurrency:(Currency *)currency {
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSPredicate *notHiddenPredicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
    NSPredicate *currencyPredicate = [NSPredicate predicateWithFormat:@"currency = %@", currency];
    NSPredicate *notSpecialCaseRecipient = [NSPredicate predicateWithFormat:@"type.hideFromCreation = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notHiddenPredicate, currencyPredicate, notSpecialCaseRecipient]];
    return [self fetchedControllerForEntity:[Recipient entityName] predicate:predicate sortDescriptors:@[nameDescriptor]];
}

- (NSArray *)allUserRecipients {
    NSPredicate *notHiddenPredicate = [NSPredicate predicateWithFormat:@"hidden = NO"];
    return [self fetchEntitiesNamed:[Recipient entityName] withPredicate:notHiddenPredicate];
}

@end
