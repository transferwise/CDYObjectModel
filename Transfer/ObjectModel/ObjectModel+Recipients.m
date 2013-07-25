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

@implementation ObjectModel (Recipients)

- (NSFetchedResultsController *)fetchedControllerForAllUserRecipients {
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
    NSPredicate *notSettlementPredicate = [NSPredicate predicateWithFormat:@"settlementRecipient = NO"];
    NSPredicate *notTemporaryPredicate = [NSPredicate predicateWithFormat:@"temporary = NO"];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[notSettlementPredicate, notTemporaryPredicate]];
    return [self fetchedControllerForEntity:[Recipient entityName] predicate:predicate sortDescriptors:@[nameDescriptor]];
}

- (Recipient *)recipientWithRemoteId:(NSNumber *)recipientId {
    NSPredicate *remoteIdPredicate = [NSPredicate predicateWithFormat:@"remoteId = %@", recipientId];
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user = %@", [self currentUser]];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[remoteIdPredicate, userPredicate]];
    return [self fetchEntityNamed:[Recipient entityName] withPredicate:predicate];
}

- (Recipient *)createOrUpdateRecipientWithData:(NSDictionary *)rawData {
    NSDictionary *data = [rawData dictionaryByRemovingNullObjects];
    NSNumber *remoteId = data[@"id"];
    Recipient *recipient = [self recipientWithRemoteId:remoteId];
    if (!recipient) {
        recipient = [Recipient insertInManagedObjectContext:self.managedObjectContext];
        [recipient setRemoteId:remoteId];
        [recipient setUser:[self currentUser]];
    }

    [recipient setName:data[@"name"]];
    [recipient setCurrency:[self currencyWithCode:data[@"currency"]]];
    [recipient setEmail:data[@"email"]];

    NSString *typeCode = data[@"type"];
    RecipientType *type = [self recipientTypeWithCode:typeCode];
    [recipient setType:type];
    for (RecipientTypeField *field in type.fields) {
        NSString *fieldValue = data[field.name];
        [self addOrUpdateValue:fieldValue forField:field toRecipient:recipient];
    }

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
    NSPredicate *recipientPredicate = [NSPredicate predicateWithFormat:@"recipient = %@", recipient];
    NSPredicate *fieldPredicate = [NSPredicate predicateWithFormat:@"valueForField = %@", field];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[recipientPredicate, fieldPredicate]];
    return [self fetchEntityNamed:[TypeFieldValue entityName] withPredicate:predicate];
}

- (Recipient *)createOrUpdateSettlementRecipientWithData:(NSDictionary *)data {
    Recipient *recipient = [self createOrUpdateRecipientWithData:data];
    [recipient setSettlementRecipientValue:YES];
    return recipient;
}

- (Recipient *)createRecipient {
    Recipient *recipient = [Recipient insertInManagedObjectContext:self.managedObjectContext];
    [recipient setTemporaryValue:YES];
    [recipient setUser:[self currentUser]];
    return recipient;
}

@end
