//
//  ObjectModel+AchBank.m
//  Transfer
//
//  Created by Juhan Hion on 24.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+AchBank.h"
#import "AchBank.h"
#import "FieldGroup.h"
#import "RecipientTypeField.h"
#import "TypeFieldHelper.h"
#import "AllowedTypeFieldValue.h"

@implementation ObjectModel (AchBank)

- (AchBank *)bankWithTitle:(NSString *)title
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
	return [self fetchEntityNamed:[AchBank entityName] withPredicate:predicate];
}

- (void)createOrUpdateAchBankWithData:(NSDictionary *)data
							bankTitle:(NSString *)bankTitle
							   formId:(NSString *)formId
{
	AchBank* bank = [self existingBankForTitle:bankTitle];
	if (!bank)
	{
		bank = [AchBank insertInManagedObjectContext:self.managedObjectContext];
		[bank setTitle:bankTitle];
	}

	//this id changes per each request and it needs to be submitted back
	[bank setId:[NSNumber numberWithInteger:[formId integerValue]]];
	
	//collect received field group names to be used to determine which fields to remove
	NSMutableArray *retrievedFieldGroupNames = [[NSMutableArray alloc] initWithCapacity:data.count];
	
	for (NSDictionary* group in data)
	{
		NSString* name = group[@"name"];
		NSString* title = group[@"title"];
		
		[retrievedFieldGroupNames addObject:name];
		FieldGroup* fieldGroup = [self existingFieldGroupForBank:bank
												 fieldGroupName:name];
		if (!fieldGroup)
		{
			fieldGroup = [FieldGroup insertInManagedObjectContext:self.managedObjectContext];
			[fieldGroup setAchBank:bank];
			[fieldGroup setTitle:title];
			[fieldGroup setName:name];
		}

		NSMutableArray *retrievedFieldNames = [[NSMutableArray alloc] init];
		
		uint rowCount = 1u;
		
		for (NSDictionary* row in group[@"fields"])
		{
			NSString *name = row[@"name"];
			[retrievedFieldNames addObject:name];
			
			[TypeFieldHelper getTypeWithData:row
								  nameGetter:^NSString *{
									  return name;
								  }
								 fieldGetter:^RecipientTypeField *(NSString *name) {
									 RecipientTypeField *field = [self existingFieldInGroup:fieldGroup
																				   withName:name];
									 if (!field)
									 {
										 field = [RecipientTypeField insertInManagedObjectContext:self.managedObjectContext];
										 [field setName:name];
										 [field setFieldForGroup:fieldGroup];
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
									 return value;
								 }
								 titleGetter:^NSString *(NSDictionary *data) {
									 if (rowCount > 1u)
									 {
										 return [NSString stringWithFormat:@"%@ %ui", title, rowCount];
									 }
									 else
									 {
										 return title;
									 }
								 }
								  typeGetter:^NSString *(NSDictionary *data) {
									  return data[@"type"];
								  }];
			rowCount++;
		}
		
		//remove fields that we did not receive
		NSMutableArray *removedFields = [NSMutableArray array];
		
		for (RecipientTypeField *field in fieldGroup.fields)
		{
			if([retrievedFieldNames indexOfObject:field.name] == NSNotFound)
			{
				[removedFields addObject:field];
			}
		}
		
		if([removedFields count] >0)
		{
			NSMutableOrderedSet *adjustedSet = [fieldGroup.fields mutableCopy];
			[adjustedSet removeObjectsInArray:removedFields];
			fieldGroup.fields = adjustedSet;
			
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
	
	//remove fields that we did not receive
	NSMutableArray *removedFieldGroups = [NSMutableArray array];
	
	for (FieldGroup *field in bank.fieldGroups)
	{
		if([retrievedFieldGroupNames indexOfObject:field.name] == NSNotFound)
		{
			[removedFieldGroups addObject:field];
		}
	}
	
	if([removedFieldGroups count] >0)
	{
		NSMutableOrderedSet *adjustedSet = [bank.fieldGroups mutableCopy];
		[adjustedSet removeObjectsInArray:removedFieldGroups];
		bank.fieldGroups = adjustedSet;
		
		for (FieldGroup *fieldGroup in removedFieldGroups)
		{
			for (RecipientTypeField *field in fieldGroup.fields)
			{
				for(NSManagedObject *value in field.values)
				{
					[self.managedObjectContext deleteObject:value];
				}
				[self.managedObjectContext deleteObject:field];
			}
			[self.managedObjectContext deleteObject:fieldGroup];
		}
	}
}

- (AchBank *)existingBankForTitle:(NSString *)title
{
	NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
	return [self fetchEntityNamed:[AchBank entityName]
					withPredicate:titlePredicate];
}

- (FieldGroup *)existingFieldGroupForBank:(AchBank *)bank
						  fieldGroupName:(NSString *)name
{
	NSPredicate *bankPredicate = [NSPredicate predicateWithFormat:@"achBank = %@", bank];
	NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[bankPredicate, titlePredicate]];
	return [self fetchEntityNamed:[FieldGroup entityName]
					withPredicate:predicate];
}

- (RecipientTypeField *)existingFieldInGroup:(FieldGroup *)group
								   withName:(NSString *)name
{
	NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"fieldForGroup = %@", group];
	NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[groupPredicate, titlePredicate]];
	return [self fetchEntityNamed:[RecipientTypeField entityName]
					withPredicate:predicate];
}

@end
