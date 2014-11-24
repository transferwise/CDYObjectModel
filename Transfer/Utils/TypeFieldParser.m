//
//  TypeFieldParser.m
//  Transfer
//
//  Created by Juhan Hion on 21.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TypeFieldParser.h"
#import "NSDictionary+Cleanup.h"
#import "RecipientTypeField.h"
#import "AllowedTypeFieldValue.h"

@implementation TypeFieldParser

+ (RecipientTypeField *)getTypeWithData:(NSDictionary *)data
							 nameGetter:(GetFieldNameBlock)nameGetterBlock
							fieldGetter:(GetRecipientTypeBlock)fieldGetterBlock
							valueGetter:(GetAllowedTypeFieldValueBlock)valueGetterBlock
{
	NSDictionary *cleanedData = [data dictionaryByRemovingNullObjects];
	NSString *name = nameGetterBlock();
	RecipientTypeField *field = fieldGetterBlock(name);
	
	[field setExample:cleanedData[@"example"]];
	[field setMaxLength:cleanedData[@"maxLength"]];
	[field setMinLength:cleanedData[@"minLength"]];
	[field setPresentationPattern:cleanedData[@"presentationPattern"]];
	[field setRequiredValue:[cleanedData[@"required"] boolValue]];
	[field setTitle:cleanedData[@"title"]];
	[field setValidationRegexp:cleanedData[@"validationRegexp"]];
	
	NSArray *allowedValues = cleanedData[@"valuesAllowed"];
	
	if (allowedValues)
	{
		for (NSDictionary *aData in allowedValues)
		{
			NSString *code = aData[@"code"];
			AllowedTypeFieldValue *value = valueGetterBlock(field, code);
			[value setTitle:aData[@"title"]];
		}
	}
	
	return field;
}

@end
