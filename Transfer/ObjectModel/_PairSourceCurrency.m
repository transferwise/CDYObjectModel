// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairSourceCurrency.m instead.

#import "_PairSourceCurrency.h"

const struct PairSourceCurrencyAttributes PairSourceCurrencyAttributes = {
	.hidden = @"hidden",
	.index = @"index",
	.maxInvoiceAmount = @"maxInvoiceAmount",
};

const struct PairSourceCurrencyRelationships PairSourceCurrencyRelationships = {
	.currency = @"currency",
	.targets = @"targets",
};

@implementation PairSourceCurrencyID
@end

@implementation _PairSourceCurrency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PairSourceCurrency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

- (PairSourceCurrencyID*)objectID {
	return (PairSourceCurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxInvoiceAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxInvoiceAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

@dynamic maxInvoiceAmount;

- (int32_t)maxInvoiceAmountValue {
	NSNumber *result = [self maxInvoiceAmount];
	return [result intValue];
}

- (void)setMaxInvoiceAmountValue:(int32_t)value_ {
	[self setMaxInvoiceAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMaxInvoiceAmountValue {
	NSNumber *result = [self primitiveMaxInvoiceAmount];
	return [result intValue];
}

- (void)setPrimitiveMaxInvoiceAmountValue:(int32_t)value_ {
	[self setPrimitiveMaxInvoiceAmount:[NSNumber numberWithInt:value_]];
}

@dynamic currency;

@dynamic targets;

- (NSMutableOrderedSet*)targetsSet {
	[self willAccessValueForKey:@"targets"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"targets"];

	[self didAccessValueForKey:@"targets"];
	return result;
}

@end

@implementation _PairSourceCurrency (TargetsCoreDataGeneratedAccessors)
- (void)addTargets:(NSOrderedSet*)value_ {
	[self.targetsSet unionOrderedSet:value_];
}
- (void)removeTargets:(NSOrderedSet*)value_ {
	[self.targetsSet minusOrderedSet:value_];
}
- (void)addTargetsObject:(PairTargetCurrency*)value_ {
	[self.targetsSet addObject:value_];
}
- (void)removeTargetsObject:(PairTargetCurrency*)value_ {
	[self.targetsSet removeObject:value_];
}
- (void)insertObject:(PairTargetCurrency*)value inTargetsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"targets"];
}
- (void)removeObjectFromTargetsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"targets"];
}
- (void)insertTargets:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"targets"];
}
- (void)removeTargetsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"targets"];
}
- (void)replaceObjectInTargetsAtIndex:(NSUInteger)idx withObject:(PairTargetCurrency*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"targets"];
}
- (void)replaceTargetsAtIndexes:(NSIndexSet *)indexes withTargets:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"targets"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self targets]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"targets"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"targets"];
}
@end

