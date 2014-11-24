// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FieldGroup.m instead.

#import "_FieldGroup.h"

const struct FieldGroupAttributes FieldGroupAttributes = {
	.title = @"title",
};

const struct FieldGroupRelationships FieldGroupRelationships = {
	.achBank = @"achBank",
	.fields = @"fields",
};

@implementation FieldGroupID
@end

@implementation _FieldGroup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FieldGroup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FieldGroup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FieldGroup" inManagedObjectContext:moc_];
}

- (FieldGroupID*)objectID {
	return (FieldGroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic title;

@dynamic achBank;

@dynamic fields;

- (NSMutableOrderedSet*)fieldsSet {
	[self willAccessValueForKey:@"fields"];

	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fields"];

	[self didAccessValueForKey:@"fields"];
	return result;
}

@end

@implementation _FieldGroup (FieldsCoreDataGeneratedAccessors)
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

