//
//  ObjectModel+RecipientTypes.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"
#import "NSDictionary+Cleanup.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "Credentials.h"
#import "User.h"
#import "Constants.h"

@implementation ObjectModel (RecipientTypes)

- (RecipientType *)recipientTypeWithCode:(NSString *)code {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", code];
    return [self fetchEntityNamed:[RecipientType entityName] withPredicate:predicate];
}

- (NSArray *)recipientTypesWithCodes:(NSArray *)codes {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"hideFromCreation = NO AND type IN %@", codes];
    return [self fetchEntitiesNamed:[RecipientType entityName] withPredicate:predicate];
}

- (BOOL)haveRecipientTypeWithCode:(NSString *)code {
    return [self recipientTypeWithCode:code] != nil;
}

- (void)createOrUpdateRecipientTypeWithData:(NSDictionary *)data {
    NSString *code = data[@"type"];
    RecipientType *type = [self recipientTypeWithCode:code];
    if (!type) {
        type = [RecipientType insertInManagedObjectContext:self.managedObjectContext];
        [type setType:code];
    }

    NSDictionary *cleanedData = [data dictionaryByRemovingNullObjects];
    [type setTitle:cleanedData[@"title"]];
    [type setHideFromCreation:cleanedData[@"specialCreateTreatment"]];
    if(cleanedData[@"recipientAddressRequired"])
    {
        type.recipientAddressRequired = cleanedData[@"recipientAddressRequired"];
    }

    NSArray *fieldsData = cleanedData[@"fields"];
    for (NSDictionary *fData in fieldsData) {
        [self createOrUpdateFieldOnType:type withData:fData];
    }
    
    NSMutableArray *removedFields = [NSMutableArray array];
    NSArray* retrievedFieldNames = [fieldsData valueForKey:@"name"];
    for (RecipientTypeField *field in type.fields)
    {
        if([retrievedFieldNames indexOfObject:field.name] == NSNotFound)
        {
            [removedFields addObject:field];
        }
    }
    
    if([removedFields count] >0)
    {
        NSMutableOrderedSet *adjustedSet = [type.fields mutableCopy];
        [adjustedSet removeObjectsInArray:removedFields];
        type.fields = adjustedSet;
        
        for (RecipientTypeField *field in removedFields)
        {
            for(NSManagedObject *value in field.values)
            {
                [self.managedObjectContext deleteObject:value];
            }
            [self.managedObjectContext deleteObject:field];
        }
    }
    
    
}

- (void)createOrUpdateFieldOnType:(RecipientType *)type withData:(NSDictionary *)data {
    NSDictionary *cleanedData = [data dictionaryByRemovingNullObjects];
    NSString *name = cleanedData[@"name"];
    RecipientTypeField *field = [self existingFieldOnType:type withName:name];
    if (!field) {
        field = [RecipientTypeField insertInManagedObjectContext:self.managedObjectContext];
        [field setName:name];
        [field setFieldForType:type];
    }

    [field setExample:cleanedData[@"example"]];
    [field setMaxLength:cleanedData[@"maxLength"]];
    [field setMinLength:cleanedData[@"minLength"]];
    [field setPresentationPattern:cleanedData[@"presentationPattern"]];
    [field setRequiredValue:[cleanedData[@"required"] boolValue]];
    [field setTitle:cleanedData[@"title"]];
    [field setValidationRegexp:cleanedData[@"validationRegexp"]];

    NSArray *allowedValues = cleanedData[@"valuesAllowed"];
    if (!allowedValues) {
        return;
    }

    for (NSDictionary *aData in allowedValues) {
        NSString *code = aData[@"code"];
        AllowedTypeFieldValue *value = [self existingAllowedValueForField:field code:code];
        if (!value) {
            value = [AllowedTypeFieldValue insertInManagedObjectContext:self.managedObjectContext];
            [value setCode:code];
            [value setValueForField:field];
        }

        [value setTitle:aData[@"title"]];
    }
}

- (RecipientTypeField *)existingFieldOnType:(RecipientType *)type withName:(NSString *)name {
    NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"fieldForType = %@", type];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[typePredicate, namePredicate]];
    return [self fetchEntityNamed:[RecipientTypeField entityName] withPredicate:predicate];
}

- (AllowedTypeFieldValue *)existingAllowedValueForField:(RecipientTypeField *)field code:(NSString *)code {
    NSPredicate *fieldPredicate = [NSPredicate predicateWithFormat:@"valueForField = %@", field];
    NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"code = %@", code];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[fieldPredicate, codePredicate]];
    return [self fetchEntityNamed:[AllowedTypeFieldValue entityName] withPredicate:predicate];
}

- (NSFetchedResultsController *)fetchedControllerForAllowedValuesOnField:(RecipientTypeField *)field {
    NSPredicate *fieldPredicate = [NSPredicate predicateWithFormat:@"valueForField = %@", field];
    NSSortDescriptor *titleSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    return [self fetchedControllerForEntity:[AllowedTypeFieldValue entityName] predicate:fieldPredicate sortDescriptors:@[titleSortDescriptor]];
}

- (void)removeOtherUsers {
    NSPredicate *notLoggedInUser = [NSPredicate predicateWithFormat:@"email != %@", [Credentials userEmail]];
    NSArray *users = [self fetchEntitiesNamed:[User entityName] withPredicate:notLoggedInUser];
    MCLog(@"Will remove %d redundant users", [users count]);
    [self deleteObjects:users saveAfter:NO];
}

@end
