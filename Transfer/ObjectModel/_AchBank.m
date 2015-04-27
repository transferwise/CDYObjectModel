// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.m instead.

#import "_AchBank.h"

const struct AchBankAttributes AchBankAttributes = {
	.fieldType = @"fieldType",
	.itemId = @"itemId",
	.remoteId = @"remoteId",
	.title = @"title",
};

const struct AchBankRelationships AchBankRelationships = {
	.fieldGroups = @"fieldGroups",
	.mfaFields = @"mfaFields",
	.user = @"user",
};

@implementation AchBankID
@end

@implementation _AchBank

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AchBank" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AchBank";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AchBank" inManagedObjectContext:moc_];
}

- (AchBankID*)objectID {
	return (AchBankID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"itemIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"itemId"];
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

@dynamic fieldType;

@dynamic itemId;

- (int32_t)itemIdValue {
	NSNumber *result = [self itemId];
	return [result intValue];
}

- (void)setItemIdValue:(int32_t)value_ {
	[self setItemId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveItemIdValue {
	NSNumber *result = [self primitiveItemId];
	return [result intValue];
}

- (void)setPrimitiveItemIdValue:(int32_t)value_ {
	[self setPrimitiveItemId:[NSNumber numberWithInt:value_]];
}

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

@dynamic title;

@dynamic fieldGroups;

- (NSMutableOrderedSet*)fieldGroupsSet {
	[self willAccessValueForKey:@"fieldGroups"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fieldGroups"];

	[self didAccessValueForKey:@"fieldGroups"];
	return result;
}

@dynamic mfaFields;

- (NSMutableOrderedSet*)mfaFieldsSet {
	[self willAccessValueForKey:@"mfaFields"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"mfaFields"];

	[self didAccessValueForKey:@"mfaFields"];
	return result;
}

@dynamic user;

@end

@implementation _AchBank (FieldGroupsCoreDataGeneratedAccessors)
- (void)addFieldGroups:(NSOrderedSet*)value_ {
	[self.fieldGroupsSet unionOrderedSet:value_];
}
- (void)removeFieldGroups:(NSOrderedSet*)value_ {
	[self.fieldGroupsSet minusOrderedSet:value_];
}
- (void)addFieldGroupsObject:(FieldGroup*)value_ {
	[self.fieldGroupsSet addObject:value_];
}
- (void)removeFieldGroupsObject:(FieldGroup*)value_ {
	[self.fieldGroupsSet removeObject:value_];
}
- (void)insertObject:(FieldGroup*)value inFieldGroupsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
- (void)removeObjectFromFieldGroupsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
- (void)insertFieldGroups:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
- (void)removeFieldGroupsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
- (void)replaceObjectInFieldGroupsAtIndex:(NSUInteger)idx withObject:(FieldGroup*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
- (void)replaceFieldGroupsAtIndexes:(NSIndexSet *)indexes withFieldGroups:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldGroups"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self fieldGroups]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"fieldGroups"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"fieldGroups"];
}
@end

@implementation _AchBank (MfaFieldsCoreDataGeneratedAccessors)
- (void)addMfaFields:(NSOrderedSet*)value_ {
	[self.mfaFieldsSet unionOrderedSet:value_];
}
- (void)removeMfaFields:(NSOrderedSet*)value_ {
	[self.mfaFieldsSet minusOrderedSet:value_];
}
- (void)addMfaFieldsObject:(MfaField*)value_ {
	[self.mfaFieldsSet addObject:value_];
}
- (void)removeMfaFieldsObject:(MfaField*)value_ {
	[self.mfaFieldsSet removeObject:value_];
}
- (void)insertObject:(MfaField*)value inMfaFieldsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet insertObject:value atIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"mfaFields"];
}
- (void)removeObjectFromMfaFieldsAtIndex:(NSUInteger)idx {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet removeObjectAtIndex:idx];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"mfaFields"];
}
- (void)insertMfaFields:(NSArray *)value atIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet insertObjects:value atIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"mfaFields"];
}
- (void)removeMfaFieldsAtIndexes:(NSIndexSet *)indexes {
    [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet removeObjectsAtIndexes:indexes];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"mfaFields"];
}
- (void)replaceObjectInMfaFieldsAtIndex:(NSUInteger)idx withObject:(MfaField*)value {
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"mfaFields"];
}
- (void)replaceMfaFieldsAtIndexes:(NSIndexSet *)indexes withMfaFields:(NSArray *)value {
    [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"mfaFields"];
    NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mfaFields]];
    [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:@"mfaFields"];
    [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"mfaFields"];
}
@end

