// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.m instead.

#import "_RecipientType.h"

const struct RecipientTypeAttributes RecipientTypeAttributes = {
	.hideFromCreation = @"hideFromCreation",
	.title = @"title",
	.type = @"type",
};

const struct RecipientTypeRelationships RecipientTypeRelationships = {
	.currencies = @"currencies",
	.defaultForCurrencies = @"defaultForCurrencies",
	.fields = @"fields",
	.recipients = @"recipients",
};

const struct RecipientTypeFetchedProperties RecipientTypeFetchedProperties = {
};

@implementation RecipientTypeID
@end

@implementation _RecipientType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipientType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipientType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipientType" inManagedObjectContext:moc_];
}

- (RecipientTypeID*)objectID {
	return (RecipientTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"hideFromCreationValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hideFromCreation"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic hideFromCreation;



- (BOOL)hideFromCreationValue {
	NSNumber *result = [self hideFromCreation];
	return [result boolValue];
}

- (void)setHideFromCreationValue:(BOOL)value_ {
	[self setHideFromCreation:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHideFromCreationValue {
	NSNumber *result = [self primitiveHideFromCreation];
	return [result boolValue];
}

- (void)setPrimitiveHideFromCreationValue:(BOOL)value_ {
	[self setPrimitiveHideFromCreation:[NSNumber numberWithBool:value_]];
}





@dynamic title;






@dynamic type;






@dynamic currencies;

	
- (NSMutableSet*)currenciesSet {
	[self willAccessValueForKey:@"currencies"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"currencies"];
  
	[self didAccessValueForKey:@"currencies"];
	return result;
}
	

@dynamic defaultForCurrencies;

	
- (NSMutableSet*)defaultForCurrenciesSet {
	[self willAccessValueForKey:@"defaultForCurrencies"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"defaultForCurrencies"];
  
	[self didAccessValueForKey:@"defaultForCurrencies"];
	return result;
}
	

@dynamic fields;

	
- (NSMutableOrderedSet*)fieldsSet {
	[self willAccessValueForKey:@"fields"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fields"];
  
	[self didAccessValueForKey:@"fields"];
	return result;
}
	

@dynamic recipients;

	
- (NSMutableSet*)recipientsSet {
	[self willAccessValueForKey:@"recipients"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recipients"];
  
	[self didAccessValueForKey:@"recipients"];
	return result;
}
	






@end
