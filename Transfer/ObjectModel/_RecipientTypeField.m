// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientTypeField.m instead.

#import "_RecipientTypeField.h"

const struct RecipientTypeFieldAttributes RecipientTypeFieldAttributes = {
	.example = @"example",
	.maxLength = @"maxLength",
	.minLength = @"minLength",
	.name = @"name",
	.presentationPattern = @"presentationPattern",
	.required = @"required",
	.title = @"title",
	.validationRegexp = @"validationRegexp",
};

const struct RecipientTypeFieldRelationships RecipientTypeFieldRelationships = {
	.allowedValues = @"allowedValues",
	.fieldForType = @"fieldForType",
	.values = @"values",
};

const struct RecipientTypeFieldFetchedProperties RecipientTypeFieldFetchedProperties = {
};

@implementation RecipientTypeFieldID
@end

@implementation _RecipientTypeField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipientTypeField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipientTypeField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipientTypeField" inManagedObjectContext:moc_];
}

- (RecipientTypeFieldID*)objectID {
	return (RecipientTypeFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"maxLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxLength"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minLength"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"requiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"required"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic example;






@dynamic maxLength;



- (int16_t)maxLengthValue {
	NSNumber *result = [self maxLength];
	return [result shortValue];
}

- (void)setMaxLengthValue:(int16_t)value_ {
	[self setMaxLength:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMaxLengthValue {
	NSNumber *result = [self primitiveMaxLength];
	return [result shortValue];
}

- (void)setPrimitiveMaxLengthValue:(int16_t)value_ {
	[self setPrimitiveMaxLength:[NSNumber numberWithShort:value_]];
}





@dynamic minLength;



- (int16_t)minLengthValue {
	NSNumber *result = [self minLength];
	return [result shortValue];
}

- (void)setMinLengthValue:(int16_t)value_ {
	[self setMinLength:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveMinLengthValue {
	NSNumber *result = [self primitiveMinLength];
	return [result shortValue];
}

- (void)setPrimitiveMinLengthValue:(int16_t)value_ {
	[self setPrimitiveMinLength:[NSNumber numberWithShort:value_]];
}





@dynamic name;






@dynamic presentationPattern;






@dynamic required;



- (BOOL)requiredValue {
	NSNumber *result = [self required];
	return [result boolValue];
}

- (void)setRequiredValue:(BOOL)value_ {
	[self setRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRequiredValue {
	NSNumber *result = [self primitiveRequired];
	return [result boolValue];
}

- (void)setPrimitiveRequiredValue:(BOOL)value_ {
	[self setPrimitiveRequired:[NSNumber numberWithBool:value_]];
}





@dynamic title;






@dynamic validationRegexp;






@dynamic allowedValues;

	
- (NSMutableSet*)allowedValuesSet {
	[self willAccessValueForKey:@"allowedValues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"allowedValues"];
  
	[self didAccessValueForKey:@"allowedValues"];
	return result;
}
	

@dynamic fieldForType;

	

@dynamic values;

	
- (NSMutableSet*)valuesSet {
	[self willAccessValueForKey:@"values"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"values"];
  
	[self didAccessValueForKey:@"values"];
	return result;
}
	






@end
