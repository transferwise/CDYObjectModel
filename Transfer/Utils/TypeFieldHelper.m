//
//  TypeFieldParser.m
//  Transfer
//
//  Created by Juhan Hion on 21.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TypeFieldHelper.h"
#import "NSDictionary+Cleanup.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"
#import "DoublePasswordEntryCell.h"
#import "DropdownCell.h"
#import "RecipientFieldCell.h"
#import "ObjectModel+RecipientTypes.h"
#import "CaptchaCell.h"

@implementation TypeFieldHelper

+ (RecipientTypeField *)getTypeWithData:(NSDictionary *)data
							 nameGetter:(GetFieldNameBlock)nameGetterBlock
							fieldGetter:(GetRecipientTypeBlock)fieldGetterBlock
							valueGetter:(GetAllowedTypeFieldValueBlock)valueGetterBlock
							titleGetter:(StringGetterBlock)titleGetterBlock
							 typeGetter:(StringGetterBlock)typeGetterBlock
							imageGetter:(GetImageBlock)imageGetterBlock
{
	NSDictionary *cleanedData = [data dictionaryByRemovingNullObjects];
	NSString *name = nameGetterBlock();
	RecipientTypeField *field = fieldGetterBlock(name);
	
    [self setChangedValue:cleanedData[@"example"] ForKey:@"example" onObject:field];
    [self setChangedValue:cleanedData[@"maxLength"] ForKey:@"maxLength" onObject:field];
    [self setChangedValue:cleanedData[@"minLength"] ForKey:@"minLength" onObject:field];
    [self setChangedValue:cleanedData[@"presentationPattern"] ForKey:@"presentationPattern" onObject:field];
    [self setChangedValue:cleanedData[@"required"] ForKey:@"required" onObject:field];
    [self setChangedValue:titleGetterBlock(cleanedData) ForKey:@"title" onObject:field];
    [self setChangedValue:cleanedData[@"validationRegexp"] ForKey:@"validationRegexp" onObject:field];
    [self setChangedValue:typeGetterBlock(cleanedData) ForKey:@"type" onObject:field];
    [self setChangedValue:imageGetterBlock(cleanedData) ForKey:@"image" onObject:field];
	
	NSArray *allowedValues = cleanedData[@"valuesAllowed"];
	
	if (allowedValues)
	{
		for (NSDictionary *aData in allowedValues)
		{
			NSString *code = aData[@"code"];
			AllowedTypeFieldValue *value = valueGetterBlock(field, code);
            [self setChangedValue:aData[@"title"] ForKey:@"title" onObject:value];
		}
	}
	
	return field;
}

+(void)setChangedValue:(id)value ForKey:(NSString*)key onObject:(id)target
{
    id currentValue = [target valueForKey:key];
    if((currentValue || value) && ![currentValue isEqual:value])
    {
        [target setValue:value forKey:key];
    }
}

+ (NSArray *)generateFieldsArray:(UITableView *)tableView
					fieldsGetter:(GetFieldsBlock)fieldsGetterBlock
					 objectModel:(ObjectModel *)objectModel
{
	NSMutableArray *result = [NSMutableArray array];
	
	for (RecipientTypeField *field in fieldsGetterBlock())
	{
		TextEntryCell *createdCell;
		if ([field.allowedValues count] > 0)
		{
			DropdownCell *cell = [tableView dequeueReusableCellWithIdentifier:TWDropdownCellIdentifier];
			[cell setAllElements:[objectModel fetchedControllerForAllowedValuesOnField:field]];
			[cell configureWithTitle:field.title value:@""];
			[cell setType:field];
			[result addObject:cell];
			createdCell = cell;
		}
		else if ([@"password" caseInsensitiveCompare:field.type] == NSOrderedSame)
		{
			DoublePasswordEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:TWDoublePasswordEntryCellIdentifier];
			[cell setShowDouble:NO];
			[cell configureWithTitle:field.title value:@""];
			[cell setType:field];
			[cell addSingleSeparator];
			[result addObject:cell];
			createdCell = cell;
		}
		else if (field.image)
		{
			CaptchaCell *cell = [tableView dequeueReusableCellWithIdentifier:TWCaptchaCellIdentifier];
			[cell setFieldType:field];
			[result addObject:cell];
			createdCell = cell;
		}
		else
		{
			RecipientFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:TWRecipientFieldCellIdentifier];
			[cell setFieldType:field];
			[result addObject:cell];
			createdCell = cell;
		}
		
		[createdCell setEditable:YES];
	}
	
	return [NSArray arrayWithArray:result];
}

+ (AllowedTypeFieldValue *)existingAllowedValueForField:(RecipientTypeField *)field
												   code:(NSString *)code
											objectModel:(CDYObjectModel *)objectModel
{
	NSPredicate *codePredicate = [NSPredicate predicateWithFormat:@"code = %@", code];
    return [[field.allowedValues filteredSetUsingPredicate:codePredicate] anyObject];
}

@end
