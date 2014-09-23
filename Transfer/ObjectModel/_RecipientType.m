// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.m instead.

#import "_RecipientType.h"

const struct RecipientTypeAttributes RecipientTypeAttributes = {
	.hideFromCreation = @"hideFromCreation",
	.recipientAddressRequired = @"recipientAddressRequired",
	.title = @"title",
	.type = @"type",
};

const struct RecipientTypeRelationships RecipientTypeRelationships = {
	.currencies = @"currencies",
	.defaultForCurrencies = @"defaultForCurrencies",
	.fields = @"fields",
	.pendingPayment = @"pendingPayment",
	.recipients = @"recipients",
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
	if ([key isEqualToString:@"recipientAddressRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientAddressRequired"];
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

@dynamic recipientAddressRequired;

- (BOOL)recipientAddressRequiredValue {
	NSNumber *result = [self recipientAddressRequired];
	return [result boolValue];
}

- (void)setRecipientAddressRequiredValue:(BOOL)value_ {
	[self setRecipientAddressRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRecipientAddressRequiredValue {
	NSNumber *result = [self primitiveRecipientAddressRequired];
	return [result boolValue];
}

- (void)setPrimitiveRecipientAddressRequiredValue:(BOOL)value_ {
	[self setPrimitiveRecipientAddressRequired:[NSNumber numberWithBool:value_]];
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

@dynamic pendingPayment;

@dynamic recipients;

- (NSMutableSet*)recipientsSet {
	[self willAccessValueForKey:@"recipients"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recipients"];

	[self didAccessValueForKey:@"recipients"];
	return result;
}

@end

@implementation _RecipientType (FieldsCoreDataGeneratedAccessors)
- (void)addFields:(NSOrderedSet*)value_ {
	[self.fieldsSet unionOrderedSet:value_];
}
- (void)removeFields:(NSOrderedSet*)value_ {
	[self.fieldsSet minusOrderedSet:value_];
}
- (void)addFieldsObject:(RecipientTypeField*)value_ {
	[self.fieldsSet addObject:value_];
}
- (void)removeFieldsObject:(RecipientTypeField*)value_ {
	[self.fieldsSet removeObject:value_];
}
- (void)insertObject:(RecipientTypeField*)value inFieldsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fields"];
}
- (void)removeObjectFromFieldsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fields"];
}
- (void)insertFields:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fields"];
}
- (void)removeFieldsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fields"];
}
- (void)replaceObjectInFieldsAtIndex:(NSUInteger)idx withObject:(RecipientTypeField*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fields"];
}
- (void)replaceFieldsAtIndexes:(NSIndexSet *)indexes withFields:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fields]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fields"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fields"];
}
@end

