// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.m instead.

#import "_Recipient.h"

const struct RecipientAttributes RecipientAttributes = {
	.addressCity = @"addressCity",
	.addressCountryCode = @"addressCountryCode",
	.addressFirstLine = @"addressFirstLine",
	.addressPostCode = @"addressPostCode",
	.addressState = @"addressState",
	.email = @"email",
	.hidden = @"hidden",
	.name = @"name",
	.remoteId = @"remoteId",
};

const struct RecipientRelationships RecipientRelationships = {
	.currency = @"currency",
	.fieldValues = @"fieldValues",
	.payInMethods = @"payInMethods",
	.payments = @"payments",
	.refundForPayment = @"refundForPayment",
	.type = @"type",
	.user = @"user",
};

@implementation RecipientID
@end

@implementation _Recipient

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recipient" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recipient";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recipient" inManagedObjectContext:moc_];
}

- (RecipientID*)objectID {
	return (RecipientID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"remoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic addressCity;

@dynamic addressCountryCode;

@dynamic addressFirstLine;

@dynamic addressPostCode;

@dynamic addressState;

@dynamic email;

@dynamic hidden;

- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:[NSNumber numberWithBool:value_]];
}

@dynamic name;

@dynamic remoteId;

- (int32_t)remoteIdValue {
	NSNumber *result = [self remoteId];
	return [result intValue];
}

- (void)setRemoteIdValue:(int32_t)value_ {
	[self setRemoteId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRemoteIdValue {
	NSNumber *result = [self primitiveRemoteId];
	return [result intValue];
}

- (void)setPrimitiveRemoteIdValue:(int32_t)value_ {
	[self setPrimitiveRemoteId:[NSNumber numberWithInt:value_]];
}

@dynamic currency;

@dynamic fieldValues;

- (NSMutableOrderedSet*)fieldValuesSet {
	[self willAccessValueForKey:@"fieldValues"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fieldValues"];

	[self didAccessValueForKey:@"fieldValues"];
	return result;
}

@dynamic payInMethods;

- (NSMutableSet*)payInMethodsSet {
	[self willAccessValueForKey:@"payInMethods"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payInMethods"];

	[self didAccessValueForKey:@"payInMethods"];
	return result;
}

@dynamic payments;

- (NSMutableSet*)paymentsSet {
	[self willAccessValueForKey:@"payments"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payments"];

	[self didAccessValueForKey:@"payments"];
	return result;
}

@dynamic refundForPayment;

@dynamic type;

@dynamic user;

@end

@implementation _Recipient (FieldValuesCoreDataGeneratedAccessors)
- (void)addFieldValues:(NSOrderedSet*)value_ {
	[self.fieldValuesSet unionOrderedSet:value_];
}
- (void)removeFieldValues:(NSOrderedSet*)value_ {
	[self.fieldValuesSet minusOrderedSet:value_];
}
- (void)addFieldValuesObject:(TypeFieldValue*)value_ {
	[self.fieldValuesSet addObject:value_];
}
- (void)removeFieldValuesObject:(TypeFieldValue*)value_ {
	[self.fieldValuesSet removeObject:value_];
}
- (void)insertObject:(TypeFieldValue*)value inFieldValuesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldValues"];
}
- (void)removeObjectFromFieldValuesAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldValues"];
}
- (void)insertFieldValues:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldValues"];
}
- (void)removeFieldValuesAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldValues"];
}
- (void)replaceObjectInFieldValuesAtIndex:(NSUInteger)idx withObject:(TypeFieldValue*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldValues"];
}
- (void)replaceFieldValuesAtIndexes:(NSIndexSet *)indexes withFieldValues:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldValues"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldValues]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldValues"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldValues"];
}
@end

