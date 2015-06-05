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
#import "TypeFieldHelper.h"

@implementation ObjectModel (RecipientTypes)

- (RecipientType *)recipientTypeWithCode:(NSString *)code {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", code];
    return [self fetchEntityNamed:[RecipientType entityName] withPredicate:predicate];
}

- (NSArray *)recipientTypesWithCodes:(NSArray *)codes includeHidden:(BOOL)includeHidden
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:includeHidden?@"type IN %@":@"type IN %@ AND hideFromCreation = NO", codes];
    return [self fetchEntitiesNamed:[RecipientType entityName] withPredicate:predicate];
}

- (BOOL)haveRecipientTypeWithCode:(NSString *)code {
    return [self recipientTypeWithCode:code] != nil;
}

- (void)createOrUpdateRecipientTypesWithData:(NSArray*)data commonAdditions:(NSDictionary*)common
{
    NSArray* typeCodes = [data valueForKey:@"type"];
    NSArray* preFetchedTypes = [self recipientTypesWithCodes:typeCodes includeHidden:YES];
    
    
    for (NSDictionary *recipientTypeData in data) {
        NSDictionary *dataToUse = recipientTypeData;
        if(common)
        {
            NSMutableDictionary* mutableData = [NSMutableDictionary dictionaryWithDictionary:dataToUse];
            [mutableData addEntriesFromDictionary:common];
            dataToUse = mutableData;
        }
        
        NSString *code = dataToUse[@"type"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", code];
        RecipientType *preFetchedType = [[preFetchedTypes filteredArrayUsingPredicate:predicate] lastObject];
        
        [self createOrUpdateRecipientTypeWithData:dataToUse preFetchedType:preFetchedType];
        
    }
}

- (void)createOrUpdateRecipientTypeWithData:(NSDictionary *)data
{
    NSString *code = data[@"type"];
    [self createOrUpdateRecipientTypeWithData:data preFetchedType:[self recipientTypeWithCode:code]];

}


- (void)createOrUpdateRecipientTypeWithData:(NSDictionary *)data preFetchedType:(RecipientType*)preFetched {
    RecipientType *type = preFetched;
    if (!type) {
        NSString *code = data[@"type"];
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

- (void)createOrUpdateFieldOnType:(RecipientType *)type withData:(NSDictionary *)data
{
	NSString *name = data[@"name"];
    __block short allowedValuesOrdinal = 0;
	[TypeFieldHelper getTypeWithData:data
						  nameGetter:^NSString *{
							  return name;
						  }
						 fieldGetter:^RecipientTypeField *(NSString *name) {
                             NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
                             NSOrderedSet *filteredPreFetched = [type.fields filteredOrderedSetUsingPredicate:namePredicate];
                             RecipientTypeField *field = [filteredPreFetched lastObject];
                             if(!field)
                             {
                                 field = [self existingFieldOnType:type withName:name];
                                 if (!field) {
                                     field = [RecipientTypeField insertInManagedObjectContext:self.managedObjectContext];
                                     [field setName:name];
                                     [field setFieldForType:type];
                                 }
                             }
							 return field;
						 }
						 valueGetter:^AllowedTypeFieldValue *(RecipientTypeField *field, NSString *code) {
							 AllowedTypeFieldValue *value = [TypeFieldHelper existingAllowedValueForField:field
																									 code:code
																							  objectModel:self];
							 if (!value) {
								 value = [AllowedTypeFieldValue insertInManagedObjectContext:self.managedObjectContext];
								 [value setCode:code];
								 [value setValueForField:field];
							 }
                             if(![value.sortOrder isEqualToNumber:@(allowedValuesOrdinal)])
                             {
                                 value.sortOrder = @(allowedValuesOrdinal);
                             }
                             allowedValuesOrdinal++;
							 return value;
						 }
						 titleGetter:^NSString *(NSDictionary *data) {
							 return data[@"title"];
						 }
						  typeGetter:^NSString *(NSDictionary *data) {
							  return nil;
						  }
						 imageGetter:^NSString *(NSDictionary *data) {
							 return nil;
						 }];
}

- (RecipientTypeField *)existingFieldOnType:(RecipientType *)type withName:(NSString *)name
{
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    return [[type.fields filteredOrderedSetUsingPredicate:namePredicate] lastObject];
}

- (NSFetchedResultsController *)fetchedControllerForAllowedValuesOnField:(RecipientTypeField *)field
{
    NSPredicate *fieldPredicate = [NSPredicate predicateWithFormat:@"valueForField = %@", field];
    NSSortDescriptor *titleSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
    return [self fetchedControllerForEntity:[AllowedTypeFieldValue entityName] predicate:fieldPredicate sortDescriptors:@[titleSortDescriptor]];
}

- (void)removeOtherUsers
{
    NSPredicate *notLoggedInUser = [NSPredicate predicateWithFormat:@"email != %@", [Credentials userEmail]];
    NSArray *users = [self fetchEntitiesNamed:[User entityName] withPredicate:notLoggedInUser];
    MCLog(@"Will remove %lu redundant users", (unsigned long)[users count]);
    [self deleteObjects:users saveAfter:NO];
}

@end
