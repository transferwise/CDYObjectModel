// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Currency.m instead.

#import "_Currency.h"

const struct CurrencyAttributes CurrencyAttributes = {
	.code = @"code",
	.index = @"index",
	.name = @"name",
	.paymentReferenceAllowed = @"paymentReferenceAllowed",
	.recipientBicRequired = @"recipientBicRequired",
	.recipientEmailRequired = @"recipientEmailRequired",
	.referenceMaxLength = @"referenceMaxLength",
	.symbol = @"symbol",
};

const struct CurrencyRelationships CurrencyRelationships = {
	.currencyForRecipients = @"currencyForRecipients",
	.defaultRecipientType = @"defaultRecipientType",
	.recipientTypes = @"recipientTypes",
	.sourceForPayments = @"sourceForPayments",
	.sources = @"sources",
	.targetForPayments = @"targetForPayments",
	.targets = @"targets",
};

@implementation CurrencyID
@end

@implementation _Currency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Currency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:moc_];
}

- (CurrencyID*)objectID {
	return (CurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"paymentReferenceAllowedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"paymentReferenceAllowed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recipientBicRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientBicRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recipientEmailRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientEmailRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"referenceMaxLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"referenceMaxLength"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic code;

@dynamic index;

- (int16_t)indexValue {
	NSNumber *result = [self index];
	return [result shortValue];
}

- (void)setIndexValue:(int16_t)value_ {
	[self setIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result shortValue];
}

- (void)setPrimitiveIndexValue:(int16_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithShort:value_]];
}

@dynamic name;

@dynamic paymentReferenceAllowed;

- (BOOL)paymentReferenceAllowedValue {
	NSNumber *result = [self paymentReferenceAllowed];
	return [result boolValue];
}

- (void)setPaymentReferenceAllowedValue:(BOOL)value_ {
	[self setPaymentReferenceAllowed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePaymentReferenceAllowedValue {
	NSNumber *result = [self primitivePaymentReferenceAllowed];
	return [result boolValue];
}

- (void)setPrimitivePaymentReferenceAllowedValue:(BOOL)value_ {
	[self setPrimitivePaymentReferenceAllowed:[NSNumber numberWithBool:value_]];
}

@dynamic recipientBicRequired;

- (BOOL)recipientBicRequiredValue {
	NSNumber *result = [self recipientBicRequired];
	return [result boolValue];
}

- (void)setRecipientBicRequiredValue:(BOOL)value_ {
	[self setRecipientBicRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRecipientBicRequiredValue {
	NSNumber *result = [self primitiveRecipientBicRequired];
	return [result boolValue];
}

- (void)setPrimitiveRecipientBicRequiredValue:(BOOL)value_ {
	[self setPrimitiveRecipientBicRequired:[NSNumber numberWithBool:value_]];
}

@dynamic recipientEmailRequired;

- (BOOL)recipientEmailRequiredValue {
	NSNumber *result = [self recipientEmailRequired];
	return [result boolValue];
}

- (void)setRecipientEmailRequiredValue:(BOOL)value_ {
	[self setRecipientEmailRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRecipientEmailRequiredValue {
	NSNumber *result = [self primitiveRecipientEmailRequired];
	return [result boolValue];
}

- (void)setPrimitiveRecipientEmailRequiredValue:(BOOL)value_ {
	[self setPrimitiveRecipientEmailRequired:[NSNumber numberWithBool:value_]];
}

@dynamic referenceMaxLength;

- (int16_t)referenceMaxLengthValue {
	NSNumber *result = [self referenceMaxLength];
	return [result shortValue];
}

- (void)setReferenceMaxLengthValue:(int16_t)value_ {
	[self setReferenceMaxLength:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveReferenceMaxLengthValue {
	NSNumber *result = [self primitiveReferenceMaxLength];
	return [result shortValue];
}

- (void)setPrimitiveReferenceMaxLengthValue:(int16_t)value_ {
	[self setPrimitiveReferenceMaxLength:[NSNumber numberWithShort:value_]];
}

@dynamic symbol;

@dynamic currencyForRecipients;

- (NSMutableSet*)currencyForRecipientsSet {
	[self willAccessValueForKey:@"currencyForRecipients"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"currencyForRecipients"];

	[self didAccessValueForKey:@"currencyForRecipients"];
	return result;
}

@dynamic defaultRecipientType;

@dynamic recipientTypes;

- (NSMutableOrderedSet*)recipientTypesSet {
	[self willAccessValueForKey:@"recipientTypes"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"recipientTypes"];

	[self didAccessValueForKey:@"recipientTypes"];
	return result;
}

@dynamic sourceForPayments;

- (NSMutableSet*)sourceForPaymentsSet {
	[self willAccessValueForKey:@"sourceForPayments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sourceForPayments"];

	[self didAccessValueForKey:@"sourceForPayments"];
	return result;
}

@dynamic sources;

- (NSMutableSet*)sourcesSet {
	[self willAccessValueForKey:@"sources"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sources"];

	[self didAccessValueForKey:@"sources"];
	return result;
}

@dynamic targetForPayments;

- (NSMutableSet*)targetForPaymentsSet {
	[self willAccessValueForKey:@"targetForPayments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targetForPayments"];

	[self didAccessValueForKey:@"targetForPayments"];
	return result;
}

@dynamic targets;

- (NSMutableSet*)targetsSet {
	[self willAccessValueForKey:@"targets"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targets"];

	[self didAccessValueForKey:@"targets"];
	return result;
}

@end

@implementation _Currency (RecipientTypesCoreDataGeneratedAccessors)
- (void)addRecipientTypes:(NSOrderedSet*)value_ {
	[self.recipientTypesSet unionOrderedSet:value_];
}
- (void)removeRecipientTypes:(NSOrderedSet*)value_ {
	[self.recipientTypesSet minusOrderedSet:value_];
}
- (void)addRecipientTypesObject:(RecipientType*)value_ {
	[self.recipientTypesSet addObject:value_];
}
- (void)removeRecipientTypesObject:(RecipientType*)value_ {
	[self.recipientTypesSet removeObject:value_];
}
- (void)insertObject:(RecipientType*)value inRecipientTypesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
- (void)removeObjectFromRecipientTypesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
- (void)insertRecipientTypes:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
- (void)removeRecipientTypesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
- (void)replaceObjectInRecipientTypesAtIndex:(NSUInteger)idx withObject:(RecipientType*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
- (void)replaceRecipientTypesAtIndexes:(NSIndexSet *)indexes withRecipientTypes:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"recipientTypes"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self recipientTypes]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"recipientTypes"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"recipientTypes"];
}
@end

