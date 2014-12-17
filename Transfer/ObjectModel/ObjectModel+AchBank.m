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
	
	for (NSDictionary* group in data)
	{
		NSString* title = group[@"title"];
		FieldGroup* fieldGroup = [self existingFieldGroupForBank:bank
												 fieldGroupTitle:title];
		if (!fieldGroup)
		{
			fieldGroup = [FieldGroup insertInManagedObjectContext:self.managedObjectContext];
			[fieldGroup setAchBank:bank];
			[fieldGroup setTitle:title];
			[fieldGroup setName:group[@"name"]];
		}
		
		uint rowCount = 1u;
		
		for (NSDictionary* row in group[@"fields"])
		{
			[TypeFieldHelper getTypeWithData:row
								  nameGetter:^NSString *{
									  return row[@"name"];
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
		
		NSMutableArray *removedFields = [NSMutableArray array];
		NSArray* retrievedFieldNames = [group[@"fields"] valueForKey:@"name"];
		
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
}

- (AchBank *)existingBankForTitle:(NSString *)title
{
	NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
	return [self fetchEntityNamed:[AchBank entityName]
					withPredicate:titlePredicate];
}

- (FieldGroup *)existingFieldGroupForBank:(AchBank *)bank
						  fieldGroupTitle:(NSString *)title
{
	NSPredicate *bankPredicate = [NSPredicate predicateWithFormat:@"achBank = %@", bank];
	NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title = %@", title];
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
