// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.m instead.

#import "_AchBank.h"

const struct AchBankAttributes AchBankAttributes = {
	.id = @"id",
	.mfaTitle = @"mfaTitle",
	.title = @"title",
};

const struct AchBankRelationships AchBankRelationships = {
	.fieldGroups = @"fieldGroups",
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

	if ([key isEqualToString:@"idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

- (int32_t)idValue {
	NSNumber *result = [self id];
	return [result intValue];
}

- (void)setIdValue:(int32_t)value_ {
	[self setId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveIdValue {
	NSNumber *result = [self primitiveId];
	return [result intValue];
}

- (void)setPrimitiveIdValue:(int32_t)value_ {
	[self setPrimitiveId:[NSNumber numberWithInt:value_]];
}

@dynamic mfaTitle;

@dynamic title;

@dynamic fieldGroups;

- (NSMutableOrderedSet*)fieldGroupsSet {
	[self willAccessValueForKey:@"fieldGroups"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fieldGroups"];

	[self didAccessValueForKey:@"fieldGroups"];
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

